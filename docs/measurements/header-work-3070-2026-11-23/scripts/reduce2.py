# Two more emulations beside build-images-2026-11-19's reduce.py, from each unit's -E output:
#   all:  every top-level item, as a preprocessed unit (the units without their preprocessing);
#   defs-warn: defs, with the two definitions whose reading warns kept in every unit that has them;
#   defs: every item but the header function definitions of internal linkage or inline that the unit's own code
#         doesn't reach by name (through the definitions it does reach): what attested header definitions would skip.
# Usage: python3 -I reduce2.py MODE OUTDIR UNIT.i...
import sys, os, importlib.util
spec = importlib.util.spec_from_file_location('reduce1', sys.argv[1])
src = open(sys.argv[1]).read()
src = src[:src.index("outdir = sys.argv[1]")]
ns = {}
exec(compile(src, sys.argv[1], 'exec'), ns)
items_of, declared, referenced = ns['items_of'], ns['declared'], ns['referenced']
mode, outdir = sys.argv[2], sys.argv[3]
# The header definitions whose reading warns: read in every unit that has them (defs-warn).
KEEP = ('__bswap64', '__bswap_64') if mode == 'defs-warn' else ()
mode = 'defs' if mode == 'defs-warn' else mode
os.makedirs(outdir, exist_ok=True)
tot = [0, 0, 0, 0, 0]
for path in sys.argv[4:]:
    items = items_of(path)
    own = [any(x[1] for x in it) for it in items]
    sps = [[x[0] for x in it if not x[2]] for it in items]
    def is_definition(sp):
        return len(sp) > 1 and sp[-1] == '}' and '{' in sp and sp[sp.index('{') - 1] == ')'
    definition = [is_definition(sp) for sp in sps]
    def discardable(sp):
        head = sp[:sp.index('{')]
        return 'static' in head or (('inline' in head or '__inline' in head or '__inline__' in head) and 'extern' not in head)
    keep = [True] * len(items)
    if mode == 'defs':
        decl = [declared(it) for it in items]
        refs = [referenced(it) for it in items]
        candidates = {}
        for i in range(len(items)):
            if not own[i] and definition[i] and discardable(sps[i]):
                keep[i] = False
                # A definition is reached by its function's name alone: the identifier before its parameters' '('
                # (reduce.py's declared() also gives a parameter's name in parentheses, which reaches too much).
                head = sps[i][:sps[i].index('{')]
                depth = 0
                name = None
                for k, t in enumerate(head):
                    if t == '(' and depth == 0 and k > 0 and name is None and head[k - 1] not in ('__attribute__', '__attribute', '__asm__'):
                        name = head[k - 1]
                    if t in '({[': depth += 1
                    elif t in ')}]': depth -= 1
                candidates.setdefault(name, []).append(i)
        # (Every kept item's names: a declaration's too, whose alias or typeof names a definition.)
        work = [n for i in range(len(items)) if keep[i] for n in refs[i]] + list(KEEP)
        seen = set()
        while work:
            n = work.pop()
            if n in seen: continue
            seen.add(n)
            for i in candidates.get(n, ()):
                if not keep[i]:
                    keep[i] = True
                    work.extend(refs[i])
    out = os.path.join(outdir, os.path.basename(path)[:-2] + '.c')
    with open(out, 'w') as f:
        for i, it in enumerate(items):
            n = sum(1 for x in it if not x[2])
            tot[0] += n
            if not own[i] and definition[i]:
                tot[2] += 1; tot[3] += n
                if not keep[i]: tot[4] += n
            if keep[i]:
                tot[1] += n
                line = []
                for t, o, raw in it:
                    if raw:
                        f.write(' '.join(line) + '\n' + t + '\n'); line = []
                    else:
                        line.append(t)
                f.write(' '.join(line) + '\n')
print(f"{mode}: tokens {tot[0]} kept {tot[1]} ({tot[1]/max(1,tot[0]):.4f}); header definitions {tot[2]} with {tot[3]} tokens, dropped tokens {tot[4]}", file=sys.stderr)
