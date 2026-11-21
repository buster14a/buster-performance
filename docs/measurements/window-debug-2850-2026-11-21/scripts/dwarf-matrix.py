import pathlib,subprocess,os,hashlib,collections
root=pathlib.Path(__file__).resolve().parent
src=pathlib.Path(os.environ.get('WINDOW_TEST_TREE',pathlib.Path.cwd())); out=pathlib.Path(os.environ.get('WINDOW_TEST_RESULTS',pathlib.Path.cwd()/'debug-results'));out.mkdir(exist_ok=True)
cc=src/'build/compiler'; dmp='llvm-dwarfdump'
h=out/'values.h';h.write_text('#define TWENTY (20)\n#define FORTY 40\n#define NEG(x) -x\n#define BODY { return 5 + 3; }\n')
f=out/'remapped.c'
f.write_text('''#include "values.h"
int header(void) BODY
int add(void)
{
    return
#line 45 "left.h"
    7
#line 90 "op.h"
    + 35;
}
#line 15 "main.c"
int local(int x){ if (x > 1) return -3; return x + 1; }
int pair(void) {return FORTY + 2;}
int wrap(void){ return NEG(3); }
int folded(void) { return TWENTY * 2; }
''')
modes=[['-g'],['-gmodules'],['-gline-tables-only'],['-g','-gdwarf-4'],['-g','-gdwarf-5'],['-g','--poison-arenas'],['-g','--tier1'],['-g','--lanes','2'],['-g','--no-deferred-bodies'],['-g','--deferred-bodies']]
tallies=collections.Counter()
for file in [src/'tests/checker/node-window.c',f,root/'routes.c']:
 for idx,opts in enumerate(modes):
    buf=[]
    for flag in [[],['--node-window']]:
        obj=out/('win.o' if flag else 'orig.o')
        obj.unlink(missing_ok=True)
        x=subprocess.run([cc,'-c','-Wall',*opts,*flag,file,'-o',obj],capture_output=True,cwd=src)
        buf.append((x.returncode,x.stdout,x.stderr,obj.read_bytes() if obj.exists() else b''))
    if buf[0]!=buf[1]:
        raise SystemExit(f'mismatch {file} {opts} {[(x[0],len(x[3]),x[2][:145]) for x in buf]}')
    assert buf[0][0]==0,(opts,buf[0][:3])
    ver=subprocess.run([dmp,'--verify',str(obj)],capture_output=True);assert ver.returncode==0,(opts,ver.stderr)
    lines=subprocess.run([dmp,'--debug-line',str(obj)],capture_output=True,check=True).stdout
    tallies['objects']+=1;tallies['line_tables']+=b'DWARF' in lines and b'Address' in lines
    q=subprocess.run([cc,'-c','--node-window','--time-stages',*opts,file,'-o',obj],capture_output=True)
    import re
    match=re.search(rb'node-window: taken=(\d+)',q.stderr)
    assert match is not None,(opts,q.stderr);tallies['actually_admitted']+=int(match[1])
print(tallies,flush=True)
