# Census of a build's header work from each unit's -E output (with line markers).
# Usage: python3 -I segments.py OUTDIR/*.i > report.txt
# A unit's tokens are split into its own (in the main file) and segments: each top-level inclusion from the
# main file, up to the return to the main file. A segment's key is (path, hash of its token text).
import sys, re, hashlib, collections

TOKEN = re.compile(r'''(?:u8|[LuU])?"(?:\\.|[^"\\])*"|[LuU]?'(?:\\.|[^'\\])*'|[A-Za-z_][A-Za-z_0-9]*|\.?[0-9](?:[eEpP][+-]|[A-Za-z_0-9.])*|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|<<=|>>=|\.\.\.|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[*/%+\-&^|]=|##|[^\s]''')
MARKER = re.compile(r'^# (\d+) "((?:\\.|[^"\\])*)"((?: \d)*)\s*$')

def unit_segments(path):
    main = None
    stack = []
    own = 0
    segs = []           # (header path, digest, tokens)
    cur = None          # [path, hasher, tokens]
    with open(path, 'r', errors='replace') as f:
        for line in f:
            m = MARKER.match(line)
            if m:
                fname = m.group(2)
                flags = m.group(3).split()
                if main is None:
                    main = fname
                    stack = [fname]
                    continue
                if '1' in flags:
                    if len(stack) == 1 and fname not in ('<built-in>', '<command line>'):
                        cur = [fname, hashlib.sha1(), 0]
                    stack.append(fname)
                elif '2' in flags:
                    while len(stack) > 1 and stack[-1] != fname:
                        stack.pop()
                    if len(stack) == 1 and fname == main and cur is not None:
                        pass
                    if stack and stack[-1] == fname:
                        pass
                    if len(stack) == 1 and cur is not None:
                        segs.append((cur[0], cur[1].hexdigest(), cur[2]))
                        cur = None
                else:
                    if fname == main:
                        while len(stack) > 1:
                            stack.pop()
                        if cur is not None:
                            segs.append((cur[0], cur[1].hexdigest(), cur[2]))
                            cur = None
                continue
            if line.startswith('#'):
                continue
            toks = TOKEN.findall(line)
            if not toks:
                continue
            if len(stack) <= 1 or cur is None:
                own += len(toks)
            else:
                cur[1].update((' '.join(toks) + '\n').encode())
                cur[2] += len(toks)
    if cur is not None:
        segs.append((cur[0], cur[1].hexdigest(), cur[2]))
    return own, segs

def main():
    files = sys.argv[1:]
    total_own = 0
    total_hdr = 0
    seen = {}
    by_path = collections.defaultdict(set)
    trie = {}
    trie_nodes = 0
    trie_tokens_distinct = 0
    per_unit = []
    for p in files:
        own, segs = unit_segments(p)
        total_own += own
        hdr = sum(s[2] for s in segs)
        total_hdr += hdr
        node = trie
        for (hp, dg, n) in segs:
            key = (hp, dg)
            if key not in seen:
                seen[key] = n
            by_path[hp].add(dg)
            if key not in node:
                node[key] = {}
                trie_nodes += 1
                trie_tokens_distinct += n
            node = node[key]
        per_unit.append((p, own, hdr, len(segs)))
    distinct_tokens = sum(seen.values())
    print(f"units {len(files)}")
    print(f"tokens own {total_own} headers {total_hdr} all {total_own + total_hdr}")
    print(f"header share {total_hdr / max(1, total_own + total_hdr):.4f}")
    print(f"top-level inclusions {sum(u[3] for u in per_unit)}")
    print(f"distinct (path, text) segments {len(seen)} with {distinct_tokens} tokens: {distinct_tokens / max(1,total_hdr):.4f} of header tokens")
    print(f"prefix trie nodes {trie_nodes} with {trie_tokens_distinct} tokens: {trie_tokens_distinct / max(1,total_hdr):.4f} of header tokens")
    print(f"distinct header paths at top level {len(by_path)}")
    multi = sorted(((len(v), k) for k, v in by_path.items()), reverse=True)[:15]
    print("paths with most distinct texts:")
    for n, k in multi:
        print(f"  {n:5d} {k}")
    print(f"work if each distinct segment is processed once: own {total_own} + distinct {distinct_tokens} = {total_own + distinct_tokens} ({(total_own + distinct_tokens) / max(1, total_own + total_hdr):.4f} of all)")

main()
