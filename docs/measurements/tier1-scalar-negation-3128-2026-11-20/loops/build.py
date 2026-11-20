from pathlib import Path
import csv,hashlib,os,re,subprocess
here=Path(__file__).resolve().parent;w=here.parents[1];os.chdir(here);out=here/'programs';out.mkdir(exist_ok=True)
cc=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
variants={'control':w/'all-pr-control/build/compiler','legacy':w/'negate-vex/build/compiler','vex':w/'negate-vex-full/build/compiler','clang':cc}
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
with open('cases.tsv','w') as f:
    cases=csv.writer(f,delimiter='\t',lineterminator='\n');cases.writerow(['width','layout','variant','program','address','bytes','sha256','expected'])
    for width,t in [(32,'float'),(64,'double')]:
        src=out/f'flip{width}.c'
        src.write_text('void flip('+t+' *negative, '+t+' *original, const '+t+' *input, unsigned n) {\n    for (unsigned i=0; i<n; i++) {\n        '+t+' x = input[i]; negative[i] = -x; original[i] = x;\n    }\n}\n')
        driver=out/f'driver{width}.o';run(cc,'-O2','-std=gnu11','-march=x86-64','-fno-vectorize','-fno-slp-vectorize',f'-DWIDTH={width}','-c','driver.c','-o',driver)
        expected=None;locations={}
        for v,compiler in variants.items():
            obj=out/f'flip{width}-{v}.o'
            flags=['--tier1','--lanes','1'] if v!='clang' else ['-fno-vectorize','-fno-slp-vectorize']
            run(compiler,*flags,'-O2','-march=znver5','-c',src,'-o',obj)
            (out/f'flip{width}-{v}.asm').write_bytes(run('objdump','-d','-Mintel',obj,stdout=subprocess.PIPE).stdout)
            for pad in [0,16,32,48] if v!='clang' else [0]:
                asm=f'.text\n.balign 64\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'
                run(cc,'-x','assembler','-c','-','-o',out/'pad.o',input=asm.encode())
                exe=out/f'neg{width}-{v}-p{pad}';run(cc,'-no-pie',driver,out/'pad.o',obj,'-o',exe)
                symbol=next(line.split() for line in run('nm','-S','--defined-only',exe,capture_output=True,text=True).stdout.splitlines() if line.split()[-1:] == ['flip'])
                addr,size=int(symbol[0],16),int(symbol[1],16)
                assert addr%64==pad and locations.setdefault(pad,addr)==addr
                a=run(exe,'512','0',stdout=subprocess.PIPE,text=True).stdout.strip()
                b=run(exe,'512','1',stdout=subprocess.PIPE,text=True).stdout.strip()
                if expected is None: expected=a
                assert a==b==expected
                cases.writerow([width,pad,v,exe.name,hex(addr),size,hashlib.file_digest(exe.open('rb'),'sha256').hexdigest(),a])
