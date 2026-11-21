from pathlib import Path
import random,re,subprocess,sys,collections
out=Path(sys.argv[2]).resolve();out.mkdir(exist_ok=True,parents=True)
exe=Path(sys.argv[1]).resolve()
rng=random.Random(2850040); summary=collections.Counter(); mismatches=[]
for k in range(64):
    s=out/f'inc-{k}.c'; lines=['#define INC(x) ((x)++)','#define CHANGE(x,op) x op','#define BODY(x) do { x++; } while (0)']
    for i in range(24):
        x=rng.choice(('a','b','c','v')); op=rng.choice(('++','--')); up=x+op
        stmt=rng.choice([up+';', f'if(a) {up};', f'for(; b<4; {up}) {{ if(b<0) break; b+=2; }}',
           f'for(; b<4; {up}) if(c) break; else b+=2;', f'while(b) {{ {up}; break; }}',
           f'return ({{ {up}; }});', f'c=({{ {up}; 13; }});', f'c=({up});',f'c += ({up} != 0);',
           f'if (a) goto label; {up}; label: ;',f'for(; b < 4; {up}, c--) {{ if(a)break; }}',
           f'CHANGE({x},{op});',f'BODY({x});',f'return b? {up}: c++;',f'INC({x});',
           f'for (int j=0; j<4; j++) {{ for (int h=0; h<2; h++) {{ {up}; }} if(a)break; }}',
           f'for ({up}; (a++<3); b++) {{ if(a) break; }}', f'void *p=&&end; goto *p; end: {up};',
           f'switch(b){{case 2: {up}; break; default: --a;}}'])
        lines.append(f'int f{i}(int a,int b){{int c; volatile int v=1; {stmt} return a+b;}}')
    s.write_text('\n'.join(lines)+'\n')
    for policy in (['-w'], ['-Wall','-Wextra'], ['-Weverything'], ['-Wall','-Wextra','-Werror']):
        rs=[]
        for j,flags in enumerate(([],['--node-window-assignments'])):
            o=out/f'file{j}.o';o.unlink(missing_ok=True)
            run=subprocess.run([str(exe),*flags,*policy,'-c',str(s),'-o',str(o)],capture_output=True)
            rs.append((run.returncode,run.stdout,run.stderr,o.read_bytes() if o.exists() else None))
        summary['pairs']+=1;summary['objects']+=rs[0][3] is not None
        if rs[0]!=rs[1]:
            mismatches.append((k, policy)); print('DIFFERENCE',k,policy, flush=True)
            for m in range(2):(out/f'{k}-{m}.err').write_bytes(rs[m][2])
    stage=subprocess.run([str(exe),'--node-window-assignments','--time-stages','-w','-fsyntax-only',str(s)],capture_output=True)
    count=re.search(rb'node-window: taken=(\d+)',stage.stderr); summary['admitted']+=int(count.group(1)) if count else 0
print(summary,'differences',mismatches); assert not mismatches and summary['admitted']
