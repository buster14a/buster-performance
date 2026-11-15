# loop_depth.py UNOPTIMIZED.ll REMARKS: for each inlined (callee, caller) pair of the whole unit's remarks, the loop
# depths (natural loops, unoptimized IR) of the caller's direct calls to the callee, grouped by the remark's threshold.
import re, sys, collections
ll, rem = sys.argv[1], sys.argv[2]
funcs = {}
cur = None
for line in open(ll):
    if line.startswith('define '):
        m = re.match(r'define .*?@"?([A-Za-z0-9_.$]+)"?\(', line)
        cur = m.group(1); funcs[cur] = [('entry', [])]
        continue
    if cur is None: continue
    if line.startswith('}'):
        cur = None; continue
    m = re.match(r'^([A-Za-z0-9_.$-]+):', line)
    if m:
        funcs[cur].append((m.group(1), [])); continue
    funcs[cur][-1][1].append(line)
def analyze(blocks):
    names = [b[0] for b in blocks]
    if names[0] == 'entry' and not blocks[0][1] and len(blocks) > 1: pass
    index = {n: i for i, n in enumerate(names)}
    # LLVM numbers the entry block %0 implicitly when unnamed; our 'entry' pseudo-block holds its lines.
    succ = []
    for n, lines in blocks:
        s = []
        for l in lines:
            for t in re.findall(r'label %"?([A-Za-z0-9_.$-]+)"?', l):
                if t in index: s.append(index[t])
        succ.append(s)
    nb = len(blocks)
    # RPO
    order = []; seen = [False] * nb; stack = [(0, 0)]; seen[0] = True
    while stack:
        v, k = stack.pop()
        if k < len(succ[v]):
            stack.append((v, k + 1)); w = succ[v][k]
            if not seen[w]: seen[w] = True; stack.append((w, 0))
        else: order.append(v)
    rpo = order[::-1]; pos = {v: i for i, v in enumerate(rpo)}
    preds = [[] for _ in range(nb)]
    for v in range(nb):
        for w in succ[v]: preds[w].append(v)
    idom = [-1] * nb; idom[0] = 0
    def intersect(a, b):
        while a != b:
            while pos[a] > pos[b]: a = idom[a]
            while pos[b] > pos[a]: b = idom[b]
        return a
    changed = True
    while changed:
        changed = False
        for v in rpo[1:]:
            ps = [p for p in preds[v] if idom[p] != -1 and p in pos]
            if not ps: continue
            new = ps[0]
            for p in ps[1:]: new = intersect(p, new)
            if idom[v] != new: idom[v] = new; changed = True
    def dominates(a, b):
        while True:
            if a == b: return True
            if b == 0 or idom[b] == -1: return False
            b = idom[b]
    depth = [0] * nb
    for u in range(nb):
        if u not in pos: continue
        for h in succ[u]:
            if dominates(h, u):
                body = {h}; work = [u]
                while work:
                    x = work.pop()
                    if x in body: continue
                    body.add(x); work.extend(p for p in preds[x] if p in pos)
                for x in body: depth[x] += 1
    return depth
cache = {}
def call_depths(caller, callee):
    if caller not in funcs: return None
    if caller not in cache: cache[caller] = analyze(funcs[caller])
    d = cache[caller]; out = []
    for i, (n, lines) in enumerate(funcs[caller]):
        for l in lines:
            if re.search(r'call [^@]*@"?' + re.escape(callee) + r'"?\(', l): out.append(d[i])
    return out
groups = collections.defaultdict(collections.Counter)
for line in open(rem):
    m = re.search(r"'([^']+)' inlined into '([^']+)' with \(cost=(-?\d+), threshold=(-?\d+)\)", line)
    if not m: continue
    callee, caller, t = m.group(1).replace('.buster_split',''), m.group(2).replace('.buster_split',''), int(m.group(4))
    ds = call_depths(caller, callee)
    if not ds: groups[t]['no direct call'] += 1; continue
    for d in ds: groups[t]['depth %d' % min(d, 3)] += 1
for t in sorted(groups):
    if sum(groups[t].values()) > 20: print(t, dict(groups[t]))
