from pathlib import Path
import os,subprocess,random,hashlib,csv,sys,resource,re
d=Path(__file__).resolve().parent;rev=sys.argv[1];cc=d/(rev+'-compiler');res=d/rev/'random';res.mkdir(exist_ok=True);src=res/'inputs';src.mkdir(exist_ok=True);rng=random.Random(550883)
resource.setrlimit(resource.RLIMIT_CORE,(0,0))
candidates=['+', '-', '*', '/', '%', '&', '|', '^', '<<','>>','<','>','<=','>=','==','!=','&&','||']
def exp(depth=0,only=False):
 if depth>=3 or rng.random()<.28:return rng.choice(['0','1','2','3','7','8','16','31','32','255','256','0xff','0u','42L','K','23','09' if only else '120']+([] if only else ['x','u','n','read()']))
 key=rng.randrange(9)
 if key<5:return '('+exp(depth+1,only)+' '+rng.choice(candidates)+' '+exp(depth+1,only)+')'
 if key==5:return rng.choice(['-','~','!','+'])+'('+exp(depth+1,only)+')'
 if key==6:return '('+exp(depth+1,only)+' ? '+exp(depth+1,only)+' : '+exp(depth+1,only)+')'
 if key==7:return 'H('+exp(depth+1,only)+','+exp(depth+1,only)+')'
 return '('+rng.choice(['int','unsigned char','_Bool','long','unsigned'])+')('+exp(depth+1,only)+')'
for i in range(96):
 head='#define K 7\n#define H(a,b) ((a) ^ (b))\nextern int read(void);\nextern int take(int);\n'
 body=[]
 for j in range(16):
  e=exp(0,i%8==6); f=exp(1)
  forms=['return '+e+';','if('+e+') return x; return n;','return ('+f+') && ('+e+');','int a[8]; return a[(unsigned)('+e+')&7];','return take('+e+');','_Bool b = ('+e+'); return b;','unsigned char b = '+e+'; return b;','return sizeof('+e+') + (unsigned)('+f+');','return ({int a='+e+'; a;});','switch('+e+'){case 1+2:return 3;default:return 4;}','return __builtin_choose_expr(1+1,'+e+','+f+');','return (u ? ('+e+') : -3) && n;','return (('+e+') << ('+f+')) && n;']
  body.append('int f'+str(j)+'(int n,unsigned u,int x){'+rng.choice(forms)+'}')
 (src/(f'family{i:03}.c')).write_text(head+'\n'.join(body)+'\n')
# Numeric tokens admitted or refused by the source decoder, with their actual original
# language-level diagnostics and parent conversion. Include malformed tokens in separate units.
spellings = ["0","00","07","010","0o17","0b101","0B110","0Xff","0x123456","0x7FFFFFFF","0x80000000","0xffffffff","2147483647","2147483648","9999999999999999","18446744073709551616",
 "0xffu","0x2LU","1ll","42L","2wB","3uwb","3ULL","0x1.fp+2","1e+2","1f","1.0f","3i","0b1'01","12'345","0xF'F","09","0x","0xg","0x7fffffffffffffff","0x1234567890123456789012345678901234567890wb",
 "__LINE__","__COUNTER__","'a'","'\\e'","'ab'","(int)1.0","(int)0x1p0"]
for i,spelling in enumerate(spellings):
 (src/(f'number{i:02}.c')).write_text("#define N "+spelling+"\nextern int use(int);\nstatic int a=(N)+2;\nint f(int x){int v=(N) & 7; return x+use((N)+2)+v+a;}\n")
policies=[[],['-g'],['-Wall','-Wextra'],['-Weverything'],['-std=c23','-pedantic'],['-Werror','-Wall','-Wextra'],['--scalar'],['-g','--poison-arenas'],['-Wconversion','-Wtautological-compare','-Wint-in-bool-context']]
sha=lambda b:hashlib.sha256(b).hexdigest()
outcols=['status','stdout','diagnostics','object','native']
with (res/'results.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['fixture','policy','taken','removed','same',*[m+'_'+k for m in ('plain','source') for k in outcols]])
 for name in sorted(src.glob('*.c')):
  for n,flags in enumerate(policies):
   obs=[];diags=[]
   for mode in ('plain','source'):
    env=os.environ.copy();o=res/(mode+'.o');nat=res/(mode+'.native');o.unlink(missing_ok=True);nat.unlink(missing_ok=True)
    env['NODE_SOURCE_NATIVE_ORACLE']=str(nat)
    if mode=='source':env.update(NODE_PURE_INTERIOR='1',NODE_PURE_INTERIOR_REPORT='1')
    r=subprocess.run([cc,'--lanes','1',*flags,'-c',name,'-o',o],capture_output=True,env=env)
    cases=[q for l in r.stderr.splitlines() if (q:=re.match(rb'interior-taken: .* removed=(\d+)',l))]
    diag=b''.join(l for l in r.stderr.splitlines(keepends=True) if not l.startswith(b'interior-taken:'));diags.append(diag)
    obs.append((r.returncode,sha(r.stdout),sha(diag),sha(o.read_bytes()) if o.exists() else '',sha(nat.read_bytes()) if nat.exists() else ''))
   same=obs[0]==obs[1];w.writerow([name.name,n,len(cases),sum(int(m[1]) for m in cases),same,*obs[0],*obs[1]])
   if not same:
    for mode,diag in zip(('plain','source'),diags):(res/(name.stem+'-'+str(n)+'-'+mode+'.err')).write_bytes(diag)
  f.flush()
