from pathlib import Path
import os,sys,hashlib,subprocess
d=Path(os.environ.get('BUSTER_EVIDENCE_OUT',Path(__file__).resolve().parent)).resolve()/'runtime';d.mkdir(parents=True,exist_ok=True)
cc=Path(sys.argv[1]).resolve()
(d/'calls.c').write_text('''struct V {unsigned long a, b;};
extern void visit(struct V*),mark_safe(struct V*); static void mark(struct V*p){mark_safe(p);}
void from_parameter(struct V*p){visit(p);mark(p);}
void from_local(struct V*p){struct V*q=p;visit(q);}
void from_address_taken(struct V*p){struct V**q=&p;visit(p);(*q)->b+=5;}
void from_conditional(struct V*p, int b){if(b){visit(p);}}
''')
(d/'foreign.c').write_text('''#include <stdio.h>
struct V {unsigned long a,b;}; static struct V* want;
void mark_safe(struct V*p){if(p==want){p->a+=19;}else{printf("pointer identity lost\\n");}}
void visit(struct V*p){if(p==want){p->a+=3;p->b+=7;}else{printf("pointer identity lost\\n");}}
extern void from_parameter(struct V*),from_local(struct V*),from_address_taken(struct V*),from_conditional(struct V*,int);
int main(void){struct V s={7,11};want=&s;from_parameter(&s);from_local(&s);from_address_taken(&s);from_conditional(&s,1);from_conditional(&s,0); printf("%lu %lu\\n",s.a,s.b);return s.a==38&&s.b==44?0:1;}
''')
for mode in ('gcc','off','on','narrow','omit-ref'):
 env=os.environ.copy();obj=d/(mode+'.o'); exe=d/(mode+'.exe')
 flags=['--node-window'] if mode!='gcc' else []
 if mode in ('on','narrow','omit-ref'):env.update(BUSTER_DISCARD_PTR='1',BUSTER_CALL_LOG='1')
 if mode=='narrow':env['BUSTER_PTR_NARROW']='1'
 if mode=='omit-ref':env['BUSTER_CALL_OMIT_REFERENCE']='1'
 p=subprocess.run([cc if mode!='gcc' else 'gcc',*flags,'-c',d/'calls.c','-o',obj],env=env,capture_output=True,text=True)
 if p.returncode:print(mode,'compile',p.returncode);continue
 subprocess.run(['gcc',obj,d/'foreign.c','-o',exe],check=True)
 p2=subprocess.run([exe],stdout=subprocess.PIPE,text=True)
 print(mode,'object',hashlib.sha256(obj.read_bytes()).hexdigest(),'rows',sum(l.startswith('ptr-row:') for l in p.stderr.splitlines()),'runtime',p2.returncode, p2.stdout.strip().replace('\n',' | '))
 assert mode not in ('gcc','off','on') or p2.returncode==0
