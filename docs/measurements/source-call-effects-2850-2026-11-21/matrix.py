import argparse,csv,hashlib,os,re,subprocess
from pathlib import Path
pa=argparse.ArgumentParser();pa.add_argument('cc');pa.add_argument('out');pa.add_argument('--lanes',default='1');pa.add_argument('--fault');pa.add_argument('--force',action='store_true');pa.add_argument('--raw',action='store_true');a=pa.parse_args()
cc=Path(a.cc).resolve();out=Path(a.out).resolve();out.mkdir(parents=True,exist_ok=True)
decl='extern int called(int);'
flat='__attribute__((flatten))';target='__attribute__((target("no-avx2")))'; both=flat+' '+target
guard='extern int (*used_hint)(int);'
cases={}
def case(n,s):cases[n]=s.replace('@',decl).replace('CALL','called(17)').replace('FLAT',flat).replace('TARGET',target).replace('BOTH',both)
case('plain','@\nint use(void) { return CALL; }')
case('metadata-in-neighbor','@\nBOTH int special(void) { return 0; } int plain(void) { return CALL; }')
case('caller-only','@\nBOTH int use(void) { return CALL; }')
case('caller-only-0','extern int empty(void);\nBOTH int use(void) { return empty(); }')
case('caller-only-discard','@\nBOTH int use(void) { CALL; return 0; }')
case('caller-only-multiple','@\nBOTH int use(void) { CALL; return called(22); }')
case('caller-only-local','@\nBOTH int use(int x) { return called(x); }')
case('caller-only-weak','@\nBOTH __attribute__((weak)) int use(void) { return CALL; }')
case('caller-two-declarations','@\nFLAT int use(void); TARGET int use(void) { return CALL; }')
case('caller-reverse-declarations','@\nTARGET int use(void); FLAT int use(void) { return CALL; }')
case('callee-redeclared','@\nextern int called(int) __attribute__((target("avx512f"), always_inline)); int use(void) {return CALL;}')
case('callee-late','@\nint use(void){return CALL;} extern int called(int) __attribute__((target("avx512f"), always_inline));')
case('callee-prior-definition','__attribute__((target("avx512f"), always_inline)) int called(int x){return x;}\nint use(void){return CALL;}')
case('branch-0','@\nBOTH int use(void){if(0){return CALL;} return 1;}')
case('branch-x','@\nBOTH int use(int x){if(x){return CALL;} return 1;}')
case('unused-physical-body','@\nBOTH static int spare(void){return CALL;} int use(void){return 1;}')
case('caller-source-pragma','@\n#pragma clang attribute push(__attribute__((target("no-avx2"))),apply_to=function)\nFLAT int use(void){return CALL;}\n#pragma clang attribute pop\n')
case('caller-gcc-pragma','@\n#pragma GCC push_options\n#pragma GCC target("no-avx2")\nFLAT int use(void){return CALL;}\n#pragma GCC pop_options\n')
case('callee-source-pragma','#pragma clang attribute push(__attribute__((target("avx512f"))),apply_to=function)\n__attribute__((always_inline)) int called(int);\n#pragma clang attribute pop\nint use(void){return CALL;}')
case('late-rename','@\n#pragma redefine_extname called renamed_call\nint use(void){return CALL;}')
case('hidden','#pragma GCC visibility push(hidden)\n@\n#pragma GCC visibility pop\nint use(void){return CALL;}')
case('local-prototype','int use(void){extern int called(int);return CALL;}')
case('file-typedef','typedef int input; typedef input result; extern result called(input);\nresult use(void){return CALL;}')
case('typedef-block','typedef int input; extern int called(input);\nint use(input x){typedef input other; other i=x;return called(i);}')
case('typedef-ms','typedef int __attribute__((ms_abi)) function(int); extern function called; int use(void){return CALL;}')
case('typedef-noreturn','typedef int __attribute__((noreturn)) function(int); extern function called; int use(void){return CALL;}')
case('call-does-not-return','extern void stop(int) __attribute__((noreturn));int use(void){stop(17);return 0;}')
case('call-scope','typedef int scalar; extern scalar called(scalar);int use(void){{typedef scalar local; local x=17;return called(x);}}')
case('typedef-inline','typedef int scalar;static scalar called(scalar x){return x+1;} scalar use(void){return CALL;}')
case('static-forward','static int called(int);int use(void){return CALL;}static int called(int x){return x+1;}')
case('multiline','@\n#define ARG 17\n#define NAME called\nint use(void){\n  return NAME(\n      ARG\n  );\n}\n')
case('line-map','@\n#line 201 "window.c"\nint use(void) {\n return called(\n  17\n );\n}\n')
case('pragma-message','@\n#pragma GCC diagnostic push\n#pragma GCC diagnostic ignored "-Wunused-result"\nint use(void){CALL;return 0;}\n#pragma GCC diagnostic pop\n')
case('declspec','__declspec(noinline) int called(int x){return x;}int use(void){return CALL;}')
case('nonflat-target','@\nTARGET int use(void){return CALL;}')
case('flatten-plain','@\nFLAT int use(void){return CALL;}')
case('flatten-late','@\nint use(void){return CALL;} BOTH int use(void);')
case('env-strict','@\n#pragma STDC FENV_ACCESS ON\nint use(void){return CALL;}')
case('env-scoped','@\nint use(void) {\n#pragma STDC FENV_ACCESS ON\n return CALL; }')
case('fp-contract','@\n#pragma STDC FP_CONTRACT OFF\nint use(void){return CALL;}')
case('opt-pragma','@\n#pragma clang optimize off\nint use(void){return CALL;}\n#pragma clang optimize on\n')
case('section-pragma','@\n#pragma clang section text=".csec"\nint use(void){return CALL;}\n#pragma clang section text=""\n')
case('caller-preserves','@\n__attribute__((preserve_most)) int use(void){return CALL;}')
case('caller-no-caller-save','@\n__attribute__((no_caller_saved_registers)) int use(void){return CALL;}')
case('callee-plain-inline','inline int called(int x){return x+1;} int use(void){return CALL;}')
case('target-versioned','__attribute__((target_clones("sse4.2","default"))) int called(int x){return x+1;} int use(void){return CALL;}')
case('caller-pragma-flatten','@\n#pragma clang attribute push(__attribute__((flatten)),apply_to=function)\nTARGET int use(void){return CALL;}\n#pragma clang attribute pop\n')
case('split-prototype-after-use','int use(void); @\nFLAT int use(void); TARGET int use(void){return CALL;}')
case('caller-macro','@\n#define DECL BOTH\nDECL int use(void){return CALL;}')
case('older-noreturn','__attribute__((noreturn)) extern int called(int);extern int called(int);int use(void){return CALL;}')
case('typedef-debug-closure','typedef int T0;typedef T0 T1; typedef T1 T2; extern T2 called(T2); T2 use(T2 x){return called(x);}')
case('debug-body-closure','typedef int T0;typedef T0 T1; static T1 called(T1 x){return x;} int use(void){return CALL;}')
case('debug-param-read','typedef int T0;typedef T0 T1; extern int called(T1);int use(T1 x){return called(x);}')
case('inline-locations','typedef long T;static int called(int i){T tmp=i; return (int)tmp+1;} int use(void){return CALL;}')
policies={'default':[],'debug':['-g'],'line':['-gline-tables-only'],'wall':['-Wall','-Wextra'],'debug2':['-g','--tier1']}
def sha(b):return hashlib.sha256(b).hexdigest()
def objhash(o):return sha(o.read_bytes()) if o.exists() else '-'
headers='case policy ordinary_status candidate_status takes same_diagnostics same_elf same_stdout clang_status same_clang_primary same_decl_marks same_decl_ids'.split()
with (out/'matrix.tsv').open('w') as f:
 w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(headers)
 for name,src in cases.items():
  p=out/(name+'.c');p.write_text(src+'\n')
  for policy,args in policies.items():
   vals=[]
   for mode,exe,flags in [('plain',str(cc),[]),('candidate',str(cc),['--node-window-calls']),('clang','clang',[])]:
    if mode=='clang' and policy in ('debug2','line'): vals.append((None,b'',None,[],None,None));continue
    o=out/(name+'-'+policy+'-'+mode+'.o');o.unlink(missing_ok=True)
    e=dict(os.environ,BUSTER_WINDOW_CALL_LOG='1')
    marks=out/(name+'-'+policy+'-'+mode+'.marks')
    marks.unlink(missing_ok=True)
    if mode!='clang' and policy in ('debug','debug2'): e['BUSTER_CALL_MARKS']=str(marks)
    if a.force and mode=='candidate': e['BUSTER_CALL_FORCE_DEBUG']='1'
    if a.fault and mode=='candidate':e['BUSTER_CALL_EFFECT_FAULT']=a.fault
    cmd=[exe,*(['--lanes',a.lanes] if mode!='clang' else ['-fno-caret-diagnostics']),'-mavx2',*args,*flags,'-c',p,'-o',o]
    pr=subprocess.run(cmd,env=e,capture_output=True)
    primary=[l.split(': ',1)[-1].strip() for l in pr.stderr.decode(errors='replace').splitlines() if re.search(r': (?:warning|error|note): ',l)]
    ds=b''.join(line for line in pr.stderr.splitlines(keepends=True) if not line.startswith(b'plain-call:'))
    taken=len(re.findall(rb'^plain-call:',pr.stderr,re.M))
    if a.raw or mode!='clang' and pr.returncode!=0:(out/(name+'-'+policy+'-'+mode+'.err')).write_bytes(pr.stderr)
    vals.append((pr.returncode,ds,objhash(o),primary,(taken,pr.stdout),marks.read_bytes() if marks.exists() else None))
   x,y,z=vals
   def marks(v,ids):
    return b''.join((line if ids else line.rsplit(b' ',1)[0])+b'\n' for line in v.splitlines()) if v!=None else None
   w.writerow([name,policy,x[0],y[0],y[4][0],int(x[1]==y[1]),int(x[2]==y[2]),int(x[4][1]==y[4][1]),z[0],int(x[3]==z[3]) if z[0]!=None else '-',int(marks(x[5],False)==marks(y[5],False)) if x[5]!=None or y[5]!=None else '-',int(x[5]==y[5]) if x[5]!=None or y[5]!=None else '-'])
