# Emulates a unit fed from header images: from each unit's -E output, keeps the unit's own top-level items and the
# header items its own code reaches by name (transitively), in their order, and writes them as a preprocessed unit.
# Usage: python3 -I reduce.py OUTDIR UNIT.i...   Prints a line a unit: name, tokens, kept tokens, header items, kept.
import sys, re, os
TOKEN = re.compile(r'''(?:u8|[LuU])?"(?:\\.|[^"\\])*"|[LuU]?'(?:\\.|[^'\\])*'|[A-Za-z_][A-Za-z_0-9]*|\.?[0-9](?:[eEpP][+-]|[A-Za-z_0-9.])*|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|<<=|>>=|\.\.\.|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[*/%+\-&^|]=|##|[^\s]''')
MARKER = re.compile(r'^# (\d+) "((?:\\.|[^"\\])*)"((?: \d)*)\s*$')
IDENT = re.compile(r'^[A-Za-z_][A-Za-z_0-9]*$')
KEYWORDS = set('''auto break case char const continue default do double else enum extern float for goto if inline int long
register restrict return short signed sizeof static struct switch typedef union unsigned void volatile while _Bool _Complex
_Imaginary _Alignas _Alignof _Atomic _Generic _Noreturn _Static_assert _Thread_local __attribute__ __attribute __asm__ asm
__asm __inline __inline__ __restrict __restrict__ __volatile__ __extension__ __typeof__ typeof __builtin_va_list __int128
__signed__ __const __alignof__ _Float16 __label__ __typeof'''.split())

def items_of(path):
    """Top-level items as (tokens with their spelling and line text, own?)."""
    toks = []   # (spelling, own)
    main = None
    depth_files = []
    with open(path, 'r', errors='replace') as f:
        for line in f:
            m = MARKER.match(line)
            if m:
                fname = m.group(2); flags = m.group(3).split()
                if main is None:
                    main = fname; depth_files = [fname]; continue
                if '1' in flags:
                    depth_files.append(fname)
                elif '2' in flags:
                    while len(depth_files) > 1 and depth_files[-1] != fname:
                        depth_files.pop()
                else:
                    while len(depth_files) > 1 and depth_files[-1] != fname:
                        depth_files.pop()
                continue
            if line.startswith('#'):
                # A pragma line the -E printer kept: keep it as an item of its own.
                toks.append((line.rstrip('\n'), len(depth_files) == 1, True))
                continue
            for t in TOKEN.findall(line):
                toks.append((t, len(depth_files) == 1, False))
    items = []
    cur = []
    depth = 0
    body = False     # whether the item's depth-0 brace opened after a ')': a function's body
    prev = ''
    for t, own, raw in toks:
        if raw:
            if cur:
                cur.append((t, own, raw))
            else:
                items.append([(t, own, raw)])
            continue
        cur.append((t, own, raw))
        if t == '{' and depth == 0:
            body = prev == ')'
        if not raw:
            prev = t
        if t in '({[':
            depth += 1
        elif t in ')}]':
            depth -= 1
            if depth == 0 and t == '}' and body:
                # A function definition ends at its closing brace; a record's body doesn't (a ';' follows).
                items.append(cur); cur = []; body = False
        elif t == ';' and depth == 0:
            items.append(cur); cur = []; body = False
    if cur:
        items.append(cur)
    return items

def declared(item):
    sp = [x[0] for x in item if not x[2]]
    names = set()
    depth = 0
    is_typedef = 'typedef' in sp
    for i, t in enumerate(sp):
        if t in '({[':
            depth += 1
        elif t in ')}]':
            depth -= 1
        if IDENT.match(t) and t not in KEYWORDS:
            nxt = sp[i + 1] if i + 1 < len(sp) else ';'
            prv = sp[i - 1] if i > 0 else ''
            if prv in ('struct', 'union', 'enum'):
                names.add('tag:' + t)
            elif depth == 0 and nxt in (';', ',', '=', '[', '(', ')', ':') :
                names.add(t)
            elif depth >= 1 and prv in ('(', '*') and nxt == ')' :
                names.add(t)   # a declarator in parentheses: (*fp)(...)
    # enumerators: identifiers inside an enum's braces followed by '=' ',' or '}'
    for i, t in enumerate(sp):
        if t == 'enum':
            j = i + 1
            while j < len(sp) and sp[j] != '{' and sp[j] != ';':
                j += 1
            if j < len(sp) and sp[j] == '{':
                k = j + 1; d = 1
                while k < len(sp) and d > 0:
                    if sp[k] == '{': d += 1
                    elif sp[k] == '}': d -= 1
                    elif d == 1 and IDENT.match(sp[k]) and sp[k] not in KEYWORDS and sp[k - 1] in ('{', ','):
                        names.add(sp[k])
                    k += 1
    return names

def referenced(item):
    sp = [x[0] for x in item if not x[2]]
    refs = set()
    for i, t in enumerate(sp):
        if IDENT.match(t) and t not in KEYWORDS:
            prv = sp[i - 1] if i > 0 else ''
            refs.add('tag:' + t if prv in ('struct', 'union', 'enum') else t)
    return refs

def reduce_unit(path, outdir):
    items = items_of(path)
    own = [any(x[1] for x in it) for it in items]
    decl = [declared(it) for it in items]
    refs = [referenced(it) for it in items]
    by_name = {}
    for i, ds in enumerate(decl):
        if not own[i]:
            for n in ds:
                by_name.setdefault(n, []).append(i)
    def external_definition(it):
        sp = [x[0] for x in it if not x[2]]
        return len(sp) > 0 and sp[-1] == '}' and 'static' not in sp[:sp.index('{')] if '{' in sp else False
    keep = [own[i] or (not own[i] and external_definition(items[i])) for i in range(len(items))]
    work = [n for i in range(len(items)) if keep[i] for n in refs[i]]
    seen = set()
    while work:
        n = work.pop()
        if n in seen:
            continue
        seen.add(n)
        for i in by_name.get(n, ()):
            if not keep[i]:
                keep[i] = True
                work.extend(refs[i])
    out = os.path.join(outdir, os.path.basename(path)[:-2] + '.c')
    tokens = 0; kept = 0; hdr_items = 0; hdr_kept = 0
    with open(out, 'w') as f:
        for i, it in enumerate(items):
            n = sum(1 for x in it if not x[2])
            tokens += n
            if not own[i]:
                hdr_items += 1
                hdr_kept += keep[i]
            if keep[i]:
                kept += n
                line = []
                for t, o, raw in it:
                    if raw:
                        f.write(' '.join(line) + '\n' + t + '\n'); line = []
                    else:
                        line.append(t)
                f.write(' '.join(line) + '\n')
    return os.path.basename(path), tokens, kept, hdr_items, hdr_kept

outdir = sys.argv[1]
os.makedirs(outdir, exist_ok=True)
tot = [0, 0, 0, 0]
for p in sys.argv[2:]:
    r = reduce_unit(p, outdir)
    for k in range(4):
        tot[k] += r[k + 1]
    print('\t'.join(str(x) for x in r))
print(f"total\ttokens {tot[0]}\tkept {tot[1]} ({tot[1]/max(1,tot[0]):.4f})\theader items {tot[2]}\tkept {tot[3]} ({tot[3]/max(1,tot[2]):.4f})", file=sys.stderr)
