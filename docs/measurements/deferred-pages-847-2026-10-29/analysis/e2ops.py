#!/usr/bin/env python3
# #847's E2: each fault classified by its instruction (OPS: "TREE IP INSTRUCTION" lines, objdump's AT&T syntax, from
# disasm_ips.sh): a store when its last operand is memory (a read-modify-write too) and the instruction isn't a compare
# or a test, a load when only another operand is; then, per unit and run, the 2 MB regions at which more than one thread
# took a store fault within WINDOW µs of the region's first store fault, each thread at one 4 KB page there (a huge
# page's first write, which no thread repeats once the region is mapped, not a region of base pages, where a thread
# faults each page it reaches), the threads past the first there, and the lanes' load and store faults.
#   e2ops.py OPS DIR UNIT...
import collections, gzip, os, re, sys
WINDOW = 100e-6
ops_path, directory, units = sys.argv[1], sys.argv[2], sys.argv[3:]
def operands(text):
    out, depth, cur = [], 0, ''
    for ch in text:
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        if ch == ',' and depth == 0:
            out.append(cur)
            cur = ''
        else:
            cur += ch
    if cur.strip():
        out.append(cur)
    return [o.strip() for o in out]
kind = {}
for line in open(ops_path):
    parts = line.split(None, 3)
    if len(parts) < 3:
        continue
    tree, ip = parts[0], int(parts[1], 16)
    mnemonic = parts[2]
    args = operands(parts[3].strip()) if len(parts) > 3 else []
    memory = [i for i, o in enumerate(args) if '(' in o]
    if not memory:
        k = 'other'
    elif memory[-1] == len(args) - 1 and not re.match(r'(cmp|test|vptest|kortest|ucomis|comis|bt\b)', mnemonic):
        k = 'store'
    else:
        k = 'load'
    kind[(tree, ip)] = k
def tree_of(name):
    return 'main-d11a91d2' if name.startswith('main-d11a91d2') else 'new-f3ac8f15'
print('| Unit | Run | Lanes\' load faults | Lanes\' store faults | Calling thread\'s store faults | Regions two threads stored into at once | Threads past the first |')
print('| --- | --- | ---: | ---: | ---: | ---: | ---: |')
for unit in units:
    for name in ('new-f3ac8f15-huge', 'main-d11a91d2', 'new-f3ac8f15'):
        path = os.path.join(directory, f'faults-{name}-{unit}.txt.gz')
        if not os.path.exists(path):
            continue
        counts = collections.Counter()
        stores = collections.defaultdict(list)
        for line in gzip.open(path, 'rt', errors='replace'):
            p = line.split()
            if len(p) < 6 or '/' not in p[0] or not p[1].endswith(':'):
                continue
            pid, tid = p[0].split('/')
            address, ip = int(p[2], 16), int(p[-2], 16)
            if not (0x10000000 < address < 0x7f0000000000) or ip >= 0x10000000:
                continue
            k = kind.get((tree_of(name), ip), 'unknown')
            counts[('main' if pid == tid else 'lane', k)] += 1
            if k == 'store':
                stores[address >> 21].append((float(p[1][:-1]), int(tid), address >> 12))
        met = extra = 0
        for region, events in stores.items():
            events.sort()
            i = 0
            while i < len(events):
                j = i
                while j < len(events) and events[j][0] - events[i][0] <= WINDOW:
                    j += 1
                per = collections.Counter(t for _, t, _ in events[i:j])
                pages = collections.defaultdict(set)
                for _, t, page in events[i:j]:
                    pages[t].add(page)
                if len(per) > 1 and max(len(v) for v in pages.values()) == 1:
                    met += 1
                    extra += len(per) - 1
                i = j
        print(f'| `{unit}.c` | {name} | {counts[("lane", "load")]} | {counts[("lane", "store")]} | {counts[("main", "store")]} | {met} | {extra} |')
unknown = sum(1 for k in kind.values() if k == 'other')
print(f'\ninstructions: {len(kind)}, without a memory operand (implicit: calls, pushes, string operations): {unknown}')
