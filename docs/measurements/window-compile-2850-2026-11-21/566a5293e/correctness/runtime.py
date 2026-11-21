from pathlib import Path
import subprocess,os,sys,hashlib
d=Path(os.environ.get('BUSTER_EVIDENCE_OUT',Path(__file__).resolve().parent)).resolve()/'runtime';d.mkdir(parents=True,exist_ok=True)
cc=Path(sys.argv[1]).resolve()
(d/'calls.c').write_text('''extern int external(int); static int inner(int x){return external(x+13);}
int from_static(void){return inner(7);} int from_external(void){return external(83);}
extern int zero(void); int from_zero(void){return zero();}
extern int adapted(int) __asm__("real_symbol"); int from_alias(void){return adapted(4);}
int from_local(int x){if(x){return external(12);}else{return external(19);}}
''')
(d/'other.c').write_text('''#include <stdio.h>
int external(int x){return x*3-4;} int zero(void){return 96;} int real_symbol(int x){return x-29;}
int from_static(void),from_external(void),from_zero(void),from_alias(void),from_local(int);
int main(void){int v[]={from_static(),from_external(),from_zero(),from_alias(),from_local(0),from_local(1)};
for(unsigned i=0;i<6;++i) printf("%d\\n",v[i]); return 0;}
''')
for mode in ('gcc','off','on','missing-ref'):
 obj=d/(mode+'.o');exe=d/(mode+'.exe');env=os.environ.copy()
 flags=[]
 if mode!='gcc': flags=['--node-window']
 if mode in ('on','missing-ref'):env.update(BUSTER_CALL_PROTO='1',BUSTER_CALL_LOG='1')
 if mode=='missing-ref':env['BUSTER_CALL_OMIT_REFERENCE']='1'
 r=subprocess.run([cc if mode!='gcc' else 'gcc',*flags,'-c',d/'calls.c','-o',obj],env=env,capture_output=True,text=True)
 if r.returncode:print(mode,'compile',r.returncode,r.stderr.splitlines()[-2:]);continue
 subprocess.run(['gcc','-no-pie',obj,d/'other.c','-o',exe],check=True)
 out=subprocess.check_output([exe],text=True)
 print(mode,hashlib.sha256(obj.read_bytes()).hexdigest(),len([l for l in r.stderr.splitlines() if l.startswith('call-row:')]),out.splitlines())
 assert out=='56\n245\n96\n-25\n53\n32\n'
