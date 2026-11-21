from pathlib import Path
import hashlib,os,subprocess,sys,collections
d=Path(__file__).resolve().parent
os.chdir(d)
prefix=os.environ.get('PP_LEXER_PAIR','compiler-')
par=d/(prefix+'parent')
can=d/(prefix+sys.argv[1])
record=d/('campaign-'+prefix+sys.argv[1]+'.log')
os.environ['SOURCE_DATE_EPOCH']='1748774400'
sql=Path('../switch-inputs/sqlite/sqlite3.c')
sqlopt=['-DSQLITE_OMIT_LOAD_EXTENSION','-DSQLITE_THREADSAFE=0','-DSQLITE_ENABLE_MEMSYS5','-DSQLITE_ENABLE_RTREE','-I../switch-inputs/sqlite']
lua=Path('../switch-inputs/inputs/lua-5.4.8/src')
musl=Path('../switch-inputs/libc/musl')
muslopt=['-std=c99','-nostdinc','-ffreestanding','-D_XOPEN_SOURCE=700','-I'+str(musl/'arch/x86_64'),'-I'+str(musl/'arch/generic'),'-I../switch-inputs/musl-generated/obj/src/internal','-I'+str(musl/'src/include'),'-I'+str(musl/'src/internal'),'-I../switch-inputs/musl-generated/obj/include','-I'+str(musl/'include')]
data=Path('macro-source')
data.mkdir(exist_ok=True)
hdr=data/'small.h'
hdr.write_text('#ifndef QA\n#define QA 1\n#define GLUE(a,b) a##b\n#define VAL 7\n#define STR(x) #x\n#endif\n')
good=data/'positive.c'
good.write_text('#include "small.h"\n#include "small.h"\n#define CALC(x) ((x) /*'+ ('words\n'*3000)+'*/ + VAL)\n#define ALT 19\nint GLUE(v,ar)=CALC(3);\nstatic const char *s=STR(CALC(alt));\n#undef ALT\n#define ALT 3\nint func(int x){ /*'+(' z\n'*3000)+'*/\n return CALC(x)+ALT+(int)s[0]; }\n')
bad=data/'diagnostics.c'
bad.write_text('#include "small.h"\n#line 349 "source-origin.c"\nint f(void){ /*'+(' x\n'*5000)+'*/\n return missing; }\n')
diag=data/'invalid.c'
diag.write_text('#define X(a) a\nint x = X(2);\n/*'+ ('words\n'*200)+'*/\n#error macro_location\n')
def cases():
    for p in [good,bad,diag,sql]:
        args=sqlopt if p==sql else []
        for switch in [['-E','-P'],['-E','-dM'],['-fsyntax-only'],['-c'],['-Wall','-Wextra','-c'],['-Wall','-Wextra','-Werror','-c'],['-g','-c']]:
            yield p,args+switch
    for p in sorted(lua.glob('*.c')):
        yield p,['-c']
        yield p,['-Wall','-Wextra','-c']
    for sub in ['string','ctype','math','stdio']:
        for p in sorted((musl/'src'/sub).glob('*.c'))[::7]:
            yield p,muslopt+['-c']
    for i in range(16):
        p=data/f'boundary-{i}.c'
        p.write_bytes((b' '*((i*63)%512))+b'#define F(n) (n /*'+(b'AbQ / xx '*((1+i)*62))+b'*/ +12)\nint f%d(int n){return F(n);}\n'%i)
        yield p,['-E','-P']
        yield p,['-c']
counts=collections.Counter()
def run(exe,args,path):
    out=d/('campaign-'+prefix+sys.argv[1]+'.o')
    out.unlink(missing_ok=True)
    cmd=[str(exe),*args,str(path)]
    if '-c' in args: cmd+=['-o',str(out)]
    r=subprocess.run(cmd,capture_output=True)
    return (r.returncode,r.stdout,r.stderr,out.read_bytes() if out.exists() else b'')
with record.open('w') as stream:
    for path,args in cases():
        a=run(par,args,path); b=run(can,args,path)
        if a!=b:
            print('mismatch',path,args,[(v if isinstance(v,int) else hashlib.sha256(v).hexdigest()) for v in a],[(v if isinstance(v,int) else hashlib.sha256(v).hexdigest()) for v in b],flush=True)
            sys.exit(1)
        if (path==good or path.parent==lua or path.name.startswith('boundary-')) and '-Werror' not in args and a[0]!=0:
            print('unexpected baseline failure',path,args,a[2][:200],flush=True);sys.exit(1)
        counts['commands']+=1
        counts['equal_ELF']+=bool(a[3]);counts['equal_rejections']+=a[0]!=0
        counts['preprocessor_bytes']+=len(a[1]);counts['diagnostic_bytes']+=len(a[2])
        print(path,' '.join(args),a[0],*(hashlib.sha256(v).hexdigest() for v in a[1:]),file=stream,flush=True)
print(dict(counts),flush=True)
