import itertools,pathlib,subprocess
src=['long g;', 'int ga[4];','enum E { A, B };']
detail={}
for n,(operand,destination,outer) in enumerate(itertools.product(
    ['(long)&g','(long)ga','1','256','0.5','-1.0','(a || 1)','(a && 0)','!(a && 0)','(1 || a)','(0 && a)','(a != 0)','a'],
    ['char','unsigned short','int','long','__int128','_Bool','double','int *','enum E'],
    ['if ({}) return 1;', 'if (!({})) return 1;', 'if (({}) || a) return 1;', 'if (a && ({})) return 1;', 'while ({}) return 1;', 'return ({}) ? 3 : (1/0);', 'if ((long)(short)({})) return 1;'])):
    if destination=='int *' and operand in ['0.5','-1.0']: continue
    expr=f'({destination})({operand})'
    fname=f'f{n}'
    detail[len(src)+1]=(fname,operand,destination,outer)
    src.append(f'int {fname}(int a) {{ '+outer.format(expr)+' }')
p=pathlib.Path('../cast-matrix.c');p.write_text('\n'.join(src)+'\n')
import re,collections,sys
def read(cc):
    r=subprocess.run([cc,'-fsyntax-only','-fno-caret-diagnostics','-Wno-int-to-pointer-cast','-Wno-pointer-to-int-cast','-Wno-constant-logical-operand','-Wno-literal-conversion',str(p)],capture_output=True,text=True)
    diags={}
    for line in r.stderr.splitlines():
        m=re.search(r':(\d+):\d+: (?:warning|error): (.*)',line)
        if m: diags.setdefault(int(m[1]),[]).append(m[2])
    return diags
ref=read(sys.argv[1]);candidate=read(sys.argv[2]);diff=[(detail[k],ref.get(k),candidate.get(k)) for k in sorted(detail) if ref.get(k)!=candidate.get(k)]
print(len(detail),'functions',len(diff),'mismatches')
for d in diff: print(d)
