# File-level census: each file's own tokens in each inclusion (nested inclusions' tokens excluded), keyed by
# (path, hash of its own token text). Usage: python3 -I files.py OUTDIR/*.i
import sys, re, hashlib, collections
TOKEN = re.compile(r'''(?:u8|[LuU])?"(?:\\.|[^"\\])*"|[LuU]?'(?:\\.|[^'\\])*'|[A-Za-z_][A-Za-z_0-9]*|\.?[0-9](?:[eEpP][+-]|[A-Za-z_0-9.])*|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|<<=|>>=|\.\.\.|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[*/%+\-&^|]=|##|[^\s]''')
MARKER = re.compile(r'^# (\d+) "((?:\\.|[^"\\])*)"((?: \d)*)\s*$')

def unit_files(path):
    stack = []   # [path, hasher, tokens]
    done = []
    main = None
    with open(path, 'r', errors='replace') as f:
        for line in f:
            m = MARKER.match(line)
            if m:
                fname = m.group(2); flags = m.group(3).split()
                if main is None:
                    main = fname; stack = [[fname, hashlib.sha1(), 0]]; continue
                if '1' in flags:
                    stack.append([fname, hashlib.sha1(), 0])
                elif '2' in flags:
                    while len(stack) > 1 and stack[-1][0] != fname:
                        e = stack.pop(); done.append((e[0], e[1].hexdigest(), e[2]))
                else:
                    while len(stack) > 1 and stack[-1][0] != fname:
                        e = stack.pop(); done.append((e[0], e[1].hexdigest(), e[2]))
                continue
            if line.startswith('#'):
                continue
            toks = TOKEN.findall(line)
            if toks:
                stack[-1][1].update((' '.join(toks) + '\n').encode()); stack[-1][2] += len(toks)
    while len(stack) > 1:
        e = stack.pop(); done.append((e[0], e[1].hexdigest(), e[2]))
    own = stack[0][2] if stack else 0
    return own, done

total_own = 0; total_hdr = 0
seen = {}
texts_by_path = collections.defaultdict(set)
incl = 0
units_by_key = collections.Counter()
for p in sys.argv[1:]:
    own, files = unit_files(p)
    total_own += own
    for (fp, dg, n) in files:
        incl += 1
        total_hdr += n
        seen.setdefault((fp, dg), n)
        texts_by_path[fp].add(dg)
        units_by_key[(fp, dg)] += 1
distinct = sum(seen.values())
print(f"tokens own {total_own} headers {total_hdr}")
print(f"file inclusions {incl}, distinct paths {len(texts_by_path)}, distinct (path, own text) {len(seen)} with {distinct} tokens = {distinct/total_hdr:.4f} of header tokens")
print(f"work if each distinct file text is processed once: {total_own + distinct} tokens = {(total_own+distinct)/(total_own+total_hdr):.4f} of all ({(total_own+total_hdr)/(total_own+distinct):.2f} times fewer)")
multi = sorted(((len(v), k) for k, v in texts_by_path.items()), reverse=True)[:12]
print("paths with most distinct own texts:")
for n, k in multi:
    toks = [seen[(k, d)] for d in texts_by_path[k]]
    print(f"  {n:4d} texts, tokens {min(toks)}..{max(toks)}  {k.split('preprocessor-391e729af658/')[-1]}")
# singletons: keys seen in one unit only
single = sum(n for k, n in seen.items() if units_by_key[k] == 1)
print(f"distinct texts seen in one unit only: {sum(1 for k in seen if units_by_key[k]==1)} with {single} tokens")
