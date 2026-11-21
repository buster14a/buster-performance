from pathlib import Path
from hashlib import sha256
import random,subprocess,sys,os
from collections import Counter
base=Path(__file__).resolve().parent
def invoke(exe,mode,flags,path):
    r=subprocess.run([exe,str(mode),str(flags),path],capture_output=True,check=True)
    return (int.from_bytes(r.stdout[:8],byteorder='little',signed=True),sha256(r.stdout).hexdigest())
def records():
    yield Path('../switch-inputs/sqlite/sqlite3.c'),[0,8,24]
    for p in sorted(Path('../switch-inputs/inputs/lua-5.4.8/src').glob('*.c')):
        yield p,[0,8]
    for p in sorted(Path('../switch-inputs/libc/musl/src/math').glob('*.c'))[::7]:
        yield p,[8]
    for p in sorted(Path('../assignment-opt-in/src/buster/compiler').glob('c_preprocessor*.c')):
        yield p,[0,8]
    p=Path('comment-boundaries.c')
    rnd=random.Random(2850)
    b=bytearray()
    ok=[b'x',b' ',b'\n',b'\r\n',b'*',b'\t',b'\x81',b'?',b'#']
    trouble=[b'//',b'\\\n',b'"',b'R"',b"'a'",b'/x',b'/**',b'*\\\r\n/',b'??/',b'\\ \n',b'\r\n']
    for i in range(750):
        b.extend(b'int p%d = 17;\n#define F%d(x) x+ /*' % (i,i))
        b.extend(b'A'*(508+i%64))
        b.extend(b''.join(rnd.choices(ok,k=rnd.choice((3,500,512,800,2048)))))
        if i%3==0:b.extend(rnd.choice(trouble))
        b.extend(b'Q'*rnd.choice([0,4,64,1024,4095]))
        b.extend(rnd.choice([b'*/\n',b'*/\r\n',b'*/\r',b'*/ 1\n',b'*/\\\n 5\n',b'*/\n/*next*/']))
        b.extend(b'\nint q%d=F%d(7);\n'%(i,i))
    b.extend(b'int z\n/*'+ b'A'*33000+b'*/\nint tail;\n')
    p.write_bytes(b)
    yield p,[0,1,2,4,8,16,24,32,64,96]
os.chdir(base)
parent=base/'parent-raw/columns'; head=base/(sys.argv[1] if len(sys.argv)>1 else 'bulk-raw')/'columns'
stats=Counter()
for p,flags_set in records():
    for flags in flags_set:
        raw=invoke(parent,0,flags,p)
        cand=invoke(head,0,flags,p)
        scalar=invoke(parent,1,flags,p)
        vo=invoke(parent,2,flags,p); vi=invoke(head,2,flags,p)
        if raw!=cand or scalar!=cand or vo!=vi:
            print('mismatch',p,flags,raw,cand,scalar,vo,vi,flush=True);sys.exit(1)
        stats['modes']+=1;stats['tokens']+=raw[0];stats['files']+=flags==flags_set[0]
        print(p,flags,raw[0],raw[1],vo[0],flush=True)
print(stats,flush=True)
