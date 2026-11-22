from common import *
import csv,hashlib,re,subprocess
out=D/'mutation';out.mkdir(exist_ok=True);src=out/'less.c';src.write_text('extern int printf(const char *,...);\nint less(int a,int b){return a<b;}\nint main(int argc,char **argv){int x=less(-argc,2);printf("%d\\n",x);return 0;}\n')
clang='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
symbols=subprocess.check_output(['nm','-an',CC],text=True);entry=re.findall(r'^([0-9a-f]+) [tT] check_source_integer_take(?:\.buster_split)?$',symbols,re.M);assert len(entry)==1,entry
with (out/'proof-layout.txt').open('w') as f:f.write(f'{entry[0]} check_source_integer_take\nAMD64 CheckSourceArithmetic.proofs=8, next=24, proof size=20, fields op=12 result=15 lt=16 rt=17.\n')
rows=[]
for mode in ('ordinary','source-oriented','observed','unsigned','invalid','witness'):
 obj=out/(mode+'.o');obj.unlink(missing_ok=True);extra={} if mode=='ordinary' else (native|producer|audit)
 cmd=[CC,'--lanes','1','-c','-std=c17','-nostdinc',src,'-o',obj]
 if mode not in ('ordinary','source-oriented'):
  action={'observed':'','unsigned':'set *(unsigned char*)($p+16)=9\nset *(unsigned char*)($p+17)=9\n','witness':'set *(unsigned char*)($p+13)=0\n','invalid':'set *(unsigned char*)($p+15)=0\n'}[mode]
  cmdfile=out/(mode+'.gdb')
  cmdfile.write_text('set pagination off\nset confirm off\nset debuginfod enabled off\nset $calls=0\nset $changed=0\nbreak *0x'+entry[0]+'\ncommands\nsilent\nset $calls=$calls+1\nset $p=*(char**)($rdi+8)+20*(*(unsigned int*)($rdi+24))\nif *(unsigned char*)($p+12)==12 && $changed == 0\nset $changed=1\nprintf "CHECKED_LT node=%u result=%u lhs=%u rhs=%u\\n",*(unsigned int*)$p,*(unsigned char*)($p+15),*(unsigned char*)($p+16),*(unsigned char*)($p+17)\n'+action+'end\ncontinue\nend\nrun\nprintf "VISITED %u COMPARES %u\\n",$calls,$changed\n')
  cmd=['gdb','-q','--batch','-x',cmdfile,'--args',*cmd]
 res=subprocess.run(cmd,env=env|extra,cwd=ROOT,capture_output=True,timeout=60);(out/(mode+'.stdout')).write_bytes(res.stdout);(out/(mode+'.stderr')).write_bytes(res.stderr)
 h=answer='-'
 if obj.exists():
  h=hashlib.sha256(obj.read_bytes()).hexdigest();exe=out/(mode+'.exe');build=subprocess.run([clang,obj,'-o',exe],capture_output=True)
  if build.returncode==0:
   run=subprocess.run([exe,'dummy'],capture_output=True);answer=str(run.returncode)+' '+run.stdout.decode().strip()
 if mode not in ('ordinary','source-oriented'):assert b'CHECKED_LT' in res.stdout,mode
 rows.append([mode,res.returncode,h,answer])
with (out/'results.tsv').open('w') as fp:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['mode','driver-or-debugger-status','ELF','runtime']);t.writerows(rows)
assert rows[0][2:]==rows[1][2:]==rows[2][2:] and rows[0][2]!='-'
print(rows)

assert rows[5][2:]==rows[0][2:] and rows[3][2]!=rows[0][2] and rows[3][3]!=rows[0][3],rows
assert b'taken=0' in (out/'witness.stderr').read_bytes(),(out/'witness.stderr').read_text()
