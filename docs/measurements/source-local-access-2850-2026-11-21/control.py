"""Pairs a real compile with graph compaction and retains every native consumption receipt."""
import collections, hashlib, json, os, re, subprocess, sys
from pathlib import Path
cc=Path(sys.argv[1]).resolve()
d=Path(sys.argv[2]).resolve()
d.mkdir(exist_ok=True,parents=True)
code='''extern int g, h; extern void die(void) __attribute__((noreturn));
static int unused(int x) { return x + 243; }
static inline int unused_i(int x) { return x + 244; }
static __attribute__((unused)) int unused_a(int x) { return x ^ 245; }
static int unused_const(void) { return 25^8; }
static int unused_global(void) { return h+g; }
int straight(int x) { x=6; return x+1; }
int go(int x) { goto stop; x=1; stop: return x+6; }
int conditional_go(int x) { if(x)goto stop; x=6; stop: return x+2; }
int earlier_return(int x) { return x+1; x=6; return x+4; }
int earlier_if(int x) { if(1) return x+4; x=8; return x+5; }
int earlier_if2(int x) { if(1) { return x+3; } x=9; return x+5; }
int earlier_die(int x) { die(); x=6; return x+7; }
int earlier_loop(int x) { for(;;) g++; x=6; return x+8; }
int earlier_loop2(int x) { while(1) g++; x=6; return x+8; }
int cond0(int x) { if(0) { x=2; return x+3; } return x+5; }
int cond1(int x) { if(1) { x=2; return x+3; } else { x=6; return x+5; } }
int cond_and(int x) { if(0 && x) { x=3;return x+3; } return x+6; }
int cond_or(int x) { if(1 || x) { x=3;return x+3; } else {x=2;return x+5;} }
int nested(int x) { if(x) { if(0 && x) {x=2;} } return x+4; }
int for0(int x) { for(;0;) { x=6; } return x+5; }
int while0(int x) { while(0) { x=6; } return x+5; }
int do0(int x) { do { x=6; } while(0); return x+5; }
int switchx(int x) { switch(1) {case 0: x=4; break; case 1:x=2;break;default:x=8;} return x+6; }
'''
src=d/'reaches.c'
src.write_text(code)
common=dict(NODE_PROOF_NO_FP='1',NODE_PROOF_POINTERS='1',NODE_PROOF_CALLS='1',NODE_SOURCE_ROWS='1',NODE_PROOF_NATIVE='1',NODE_SPLICE_FRONT='1',NODE_SPLICE_ENABLE='1',NODE_SPLICE_REPORT='1')
def result(raw,pattern):
 return set(map(int,re.findall(r'^'+pattern+r': token=(\d+)',raw,re.M)))
def diagnostics(raw):
 return [l for l in raw.splitlines() if re.search(r': (warning|note|error|fatal error): ',l)]
def sha(p):
 return hashlib.sha256(p.read_bytes()).hexdigest() if p.exists() else None
runs={}
for k,ex in [('plain',{}),('source',common),('compact',dict(common,NODE_SOURCE_COMPACT='1',NODE_SOURCE_LOCAL_ACCESS='1',NODE_SOURCE_COMPACT_REPORT='1'))]:
 obj=d/(k+'.o'); e=subprocess.run([cc,'--lanes','1','-c',src,'-o',obj],capture_output=True,env=dict(os.environ,**ex))
 log=e.stderr.decode();(d/(k+'.err')).write_text(log)
 runs[k]=(e.returncode,sha(obj),diagnostics(log),result(log,'compact-taken'),result(log,'compact-consumed'),result(log,'splice-taken'))
data={'status':{k:v[0] for k,v in runs.items()},'elf_equal':len(set(v[1] for v in runs.values()))==1,'diagnostics_equal':len(set(tuple(v[2]) for v in runs.values()))==1,'compactions':len(runs['compact'][3]),'consumptions':len(runs['compact'][4]),'not_requested':sorted(runs['compact'][3]-runs['compact'][4]),'outside_source_native':sorted(runs['compact'][3]-runs['source'][5])}
print(json.dumps(data,indent=2));(d/'result.json').write_text(json.dumps(data,indent=2)+'\n')
