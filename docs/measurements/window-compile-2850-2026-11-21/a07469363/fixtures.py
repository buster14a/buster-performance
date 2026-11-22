from pathlib import Path
import subprocess,os,hashlib,csv
p=Path(__file__).resolve().parent;o=p/'fixtures';o.mkdir(exist_ok=True)
prefix='struct rec{int x; unsigned flags:3; struct {int y;}; int array[2];};\n'
cases={'ordinary':prefix+''.join(f'int f{i}(struct rec*r){{return r->x+r->flags+r->y+r->array[1];}}\n' for i in range(12))+'''int main(void){struct rec t={.x=11,.flags=5,.y=13,.array={2,7}};return f0(&t)+f11(&t)!=72;}''',
 'qualified':prefix+''.join(f'int f{i}(volatile struct rec*r,const struct rec*s,struct rec t){{return r->x+s->flags+t.y;}}\n' for i in range(9))+'''int main(void){struct rec t={.x=5,.flags=3,.y=2};return f8(&t,&t,t)!=10;}''',
 'shadows':prefix+''.join(f'int f{i}(struct rec *r){{struct rec{{char pad[16]; long x;}};struct rec t={{.x=13}};return r->x+t.x;}}\n' for i in range(9))+'''int main(void){struct rec t={.x=5};return f4(&t)!=18;}''',
 'before_complete':'''struct r; int early(struct r*p){return p->x;} struct r{int x;};int later(struct r*p){return p->x;}''',
 'missing_field':prefix+'''int good(struct rec *r){return r->x;}int bad(struct rec*r){return r->xx;}''',
 'vector':'''typedef int V __attribute__((ext_vector_type(4)));struct r{int x;};int a(struct r*p){return p->x;}int b(V*p){return p->x;}int c(struct r*p){return p->x;}int main(void){struct r r={3};V v={5,6,7,8};return a(&r)+b(&v)+c(&r)!=11;}'''}
cases['vector_arrow_unsupported']=cases['vector'];cases['vector']=cases['vector'].replace('int b(V*p){return p->x;}','int b(V*p){return (*p)[0];}')
head=['case','mode','Clang','native','cached','object','stdout','stderr','executable_result'];records=[]
for n,s in cases.items():
 f=o/(n+'.c');f.write_text(s)
 for mode,flags in [('default',[]),('wall',['-Wall','-Wextra']),('strict',['-Wall','-Wextra','-Werror']),('quiet',['-w']),('everything',['-Weverything'])]:
  result=[]
  for arm,cc,env in [('clang','clang',{}),('native',p/'compiler',{}),('cached',p/'compiler',{'BUSTER_CONTROL_MEMBER_RULES':'1'})]:
   obj=o/(n+'-'+arm+'.o');obj.unlink(missing_ok=True)
   r=subprocess.run([cc,*flags,'-c',f,'-o',obj],capture_output=True,env=os.environ|{'BUSTER_CONTROL_SOURCE_NATIVE':'1','BUSTER_CONTROL_EARLY_NATIVE':'1','BUSTER_CONTROL_EARLY_RELEASE':'1'}|env)
   exe_result=-1
   if r.returncode==0 and 'int main(' in s:
    exe=o/(n+'-'+arm);subprocess.run(['clang',obj,'-o',exe],check=True);exe_result=subprocess.run([exe]).returncode
   result.append((r.returncode,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '',r.stdout,r.stderr,exe_result))
  clang,ref,cached=result;ok=[int(ref[j]==cached[j]) for j in (1,2,3)]
  records.append((n,mode,clang[0],ref[0],cached[0],*ok,ref[4]));assert ref==cached,(n,mode,ref,cached)
  if n=='vector_arrow_unsupported':
   base=subprocess.run([p.parent/'main-fbef-clean/build/compiler',*flags,'-c',f,'-o',o/'baseline.o'],capture_output=True);assert base.returncode==ref[0] and base.stderr==ref[3] and base.stdout==ref[2],(n,mode)
  else: assert clang[0]==ref[0] and clang[4]==ref[4] and clang[4] in (0,-1),(n,mode,clang,ref)
with (p/'fixtures.tsv').open('w') as out:
 w=csv.writer(out,delimiter='\t');w.writerow(head);w.writerows(records)
print(len(records),'qualified Clang/native status, executions and exact native output')
