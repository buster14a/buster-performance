from pathlib import Path
from collections import Counter
import subprocess,random,re,sys
# Usage: python3 generate-field-comparisons.py /path/to/compiler /path/to/empty/output
exe=Path(sys.argv[1]).resolve()
out=Path(sys.argv[2]).resolve()
out.mkdir(exist_ok=True,parents=True)
rng=random.Random(2850)
widths=['char','signed char','unsigned char','short','unsigned short','int','unsigned','long','unsigned long','long long','unsigned long long']
args=['p','q','a','dst','value','it']
withs=['','volatile ','const ']
prefixes=['char front;', 'char space[274];','', 'short front;', 'long long aligner;']
count=Counter();wrong=[]
for unit in range(96):
    special=unit%12
    file=out/f'g{unit}.c'
    code=['#define VAL(n) n','#define WR(t,v) t->x = (v)','#define STORE(t,v) t->x = v']
    for i in range(12):
        typ=rng.choice(widths)
        pre=rng.choice(prefixes)
        q=rng.choice(args)
        val=rng.choice([0,1,15,31,99,127,128,250,255,256,16384,32767,65537,101125,371234568])
        mod='__attribute__((packed))' if special==1 else ''
        qual='volatile ' if special==2 else ''
        field=qual+typ+' x'
        if special==3:field='unsigned x:4'
        if special==4:field='int x __attribute__((deprecated))'
        body=f'{q}->x = {val};'
        wrapper=rng.randrange(11)
        if wrapper==0:body=f'if (which) {{ {body} }}'
        if wrapper==1:body=f'if (which) {body}'
        if wrapper==2:body=f'do {{ {body} }} while(0);'
        if wrapper==3:body=f'{q}->x=VAL({val});'
        if wrapper==4:body=f'STORE({q},{val});'
        if wrapper==5:body=f'WR({q},{val});'
        if wrapper==6:body=f'(void)({{{body}}});'
        if wrapper==7:body=f'for(int j=0; j<which; j++) {{ {body} }}'
        if wrapper==8:body=f'if(!which) return; {body}'
        if special==5:body=f'struct S{i} *u; if(which) u={q}; u->x = {val};'
        if special==6:body=f'struct S{i} *u; u->x = {val};'
        if special==7:body=f'{q}->x={val}; {q}->x={val}; {q}->x={val};'
        if special==8:body=f'__typeof__({q}) u={q}; u->x={val};'
        if special==9:body=f'static struct S{i} *save; save={q}; save->x={val};'
        if special==10:body=f'#pragma clang diagnostic push\n#pragma clang diagnostic ignored "-Wconstant-conversion"\n{body}\n#pragma clang diagnostic pop\n'
        code.append(f'struct {mod} S{i} {{ {pre} {field}; }};')
        code.append(f'void f{i}(struct S{i} *{q}, int which) {{\n{body}\n}}')
    file.write_text('\n'.join(code)+'\n')
    for pol in [['-w'],['-Wall','-Wextra'],['-Weverything'],['-Werror','-Wall','-Wextra']]:
        results=[]
        for mode in [[],['--node-window-assignments']]:
            obj=out/f'unit{len(mode)}.o';obj.unlink(missing_ok=True)
            sr=subprocess.run([str(exe),*mode,*pol,'-std=gnu17','-c',str(file),'-o',str(obj)],capture_output=True)
            results.append((sr.returncode,sr.stdout,sr.stderr,obj.read_bytes() if obj.exists() else None))
        count['pairs']+=1;count['whole objects']+=results[0][3] is not None;count['successful']+=results[0][0]==0
        if results[0]!=results[1]:
            print('DIFFERENCE',unit,pol,flush=True)
            for i,r in enumerate(results):
                (out/f'wrong-{unit}-{i}.stderr').write_bytes(r[2])
            wrong.append((unit,pol))
    g=subprocess.run([str(exe),'--node-window-assignments','--time-stages','-w','-fsyntax-only',str(file)],capture_output=True)
    cnt=re.search(rb'node-window: taken=(\d+)',g.stderr)
    if cnt:count['admitted']+=int(cnt.group(1))
print(count,'differences',wrong[:20]);assert not wrong and count['admitted']>0
