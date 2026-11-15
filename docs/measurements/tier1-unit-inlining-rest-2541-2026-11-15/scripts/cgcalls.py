import sys, re, collections
# Sum callgrind "calls=" by callee and by caller->callee edge.
names = {}
def name(tok, kind):
    m = re.match(r'\((\d+)\)(?: (.*))?', tok)
    if not m: return tok
    key=(kind, m.group(1))
    if m.group(2): names[key]=m.group(2)
    return names.get(key, tok)
fn=None; cfn=None
callee=collections.Counter(); edge=collections.Counter(); total=0
for line in open(sys.argv[1], errors='replace'):
    line=line.rstrip('\n')
    if line.startswith('fn='): fn=name(line[3:],'fn')
    elif line.startswith('cfn='): cfn=name(line[4:],'fn')
    elif line.startswith('cfi=') or line.startswith('cfl='): pass
    elif line.startswith('calls='):
        n=int(line[6:].split()[0]); callee[cfn]+=n; edge[(fn,cfn)]+=n; total+=n
print("total calls", total)
for c,n in callee.most_common(int(sys.argv[2]) if len(sys.argv)>2 else 30): print(f"{n:12d} {100*n/total:6.2f}% {c}")
print("--- edges")
for (a,b),n in edge.most_common(int(sys.argv[2]) if len(sys.argv)>2 else 30): print(f"{n:12d} {100*n/total:6.2f}% {a} -> {b}")
