import sys,re
# unused.py UNIT.i: of a preprocessed unit's system-header declarations (split at their top-level semicolons and
# bodies), how many name nothing the unit's own lines name. A heuristic: a declaration's names are its tags, its
# enumerators and the identifiers before a declarator's `(`, `[`, `;`, `,`, `=` or `)`; it counts a declaration as
# used only when one of them is spelled in the unit's own lines, so a declaration reached only through another system
# declaration (a typedef's struct, say) counts as unused.
tokre=re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|[A-Za-z_]\w*|\d[\w.]*|\.\.\.|->|\S')
ident=re.compile(r'[A-Za-z_]\w*$')
KW=set('auto break case char const continue default do double else enum extern float for goto if inline int long register restrict return short signed sizeof static struct switch typedef union unsigned void volatile while _Bool _Complex _Noreturn _Static_assert _Thread_local _Alignas _Alignof __attribute__ __attribute __restrict __restrict__ __inline __inline__ __extension__ __asm__ __asm asm __const __volatile__ __signed__ __typeof__ typeof __builtin_va_list __int128 __thread'.split())
segs=[]; cur=[]; sysflag=None
for line in open(sys.argv[1], errors='replace'):
    m=re.match(r'# (\d+) "([^"]*)"(.*)', line) if line.startswith('# ') else None
    if m:
        f='3' in m.group(3).split()
        if f!=sysflag and cur: segs.append((sysflag,cur)); cur=[]
        sysflag=f; continue
    cur+=tokre.findall(line)
if cur: segs.append((sysflag,cur))
user=set(t for s,ts in segs if not s for t in ts if ident.match(t))
decls=[]
for s,ts in segs:
    if not s: continue
    depth=0; d=[]
    for t in ts:
        d.append(t)
        if t in '({[': depth+=1
        elif t in ')}]': depth-=1
        if depth==0 and (t==';' or (t=='}' and d.count('{')>0 and d[0] not in ('struct','union','enum','typedef') and '=' not in d)):
            decls.append(d); d=[]
    if d: decls.append(d)
def declared(d):
    names=set()
    for i,t in enumerate(d):
        if t in ('struct','union','enum') and i+1<len(d) and ident.match(d[i+1]) and d[i+1] not in KW: names.add(d[i+1])
    if 'enum' in d and '{' in d:
        prev=','
        for t in d[d.index('{')+1:]:
            if prev in (',','{') and ident.match(t): names.add(t)
            prev=t
    depth=0
    for i,t in enumerate(d):
        if t in ('(','['): depth+=1
        elif t in (')',']'): depth-=1
        if ident.match(t) and t not in KW and i+1<len(d) and depth<=1 and d[i+1] in ('(','[',';',',','=',')'):
            if not (i>0 and d[i-1] in ('struct','union','enum','__attribute__')): names.add(t)
    return names
used=unused=used_tok=unused_tok=0
for d in decls:
    if declared(d) & user: used+=1; used_tok+=len(d)
    else: unused+=1; unused_tok+=len(d)
print(f'system declarations {len(decls)}: named in the unit\'s own lines {used} ({used_tok} tokens), not {unused} ({unused_tok} tokens); unnamed share of the system tokens {100*unused_tok/(used_tok+unused_tok):.1f}%')
