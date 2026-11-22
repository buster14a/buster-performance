from pathlib import Path
import subprocess,hashlib,csv,os,re
d=Path(__file__).resolve().parent;out=d/'mutation';out.mkdir(exist_ok=True);cc=d.parent/'default-ordered-integers/build/compiler';clang=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang')
symbols=subprocess.check_output(['nm','-an',cc],text=True)
entry=re.findall(r'^([0-9a-f]+) [tT] check_graph_integer_row(?:\.buster_split)?$',symbols,re.M)
assert len(entry)==1,entry
(out/'entry.txt').write_text(next(l for l in symbols.splitlines() if l.startswith(entry[0]+' '))+'\n')
source=out/'read.c';source.write_text('extern int printf(const char*,...);\nint f(int a,int b){return (a+b) ^ (b*3);}\nint main(int argc,char**v){int r=f(argc+13,argc+5);printf("%d\\n",r);return 0;}\n')
def sha(data):return hashlib.sha256(data).hexdigest()
rows=[]
for mode in ('plain','observed','skip-publish'):
 obj=out/(mode+'.o');obj.unlink(missing_ok=True);cmd=[cc,'--lanes','1','-std=c17','-nostdinc','-c',source,'-o',obj]
 if mode!='plain':
  action='if $seen == 1\nreturn (unsigned char)1\nend\n' if mode=='skip-publish' else ''
  gdb=out/(mode+'.gdb');gdb.write_text('set pagination off\nset confirm off\nset debuginfod enabled off\nset $seen=0\nbreak *0x'+entry[0]+'\ncommands\nsilent\nset $seen=$seen+1\nif $seen == 1\nprintf "FIRST_ROW %u STORE %u\\n", $ecx, $r8d\nend\n'+action+'continue\nend\nrun\nprintf "ROW_CALLS %u\\n", $seen\n')
  cmd=['gdb','-q','--batch','-x',gdb,'--args',*cmd]
 result=subprocess.run(cmd,capture_output=True,timeout=45);(out/(mode+'.stdout')).write_bytes(result.stdout);(out/(mode+'.stderr')).write_bytes(result.stderr)
 h='-';answer='-'
 if obj.exists():
  h=sha(obj.read_bytes());exe=out/(mode+'.exe');link=subprocess.run([clang,obj,'-o',exe],capture_output=True);(out/(mode+'.link.stderr')).write_bytes(link.stderr)
  if link.returncode==0:
   run=subprocess.run([exe,'one','two'],capture_output=True,timeout=10);answer=str(run.returncode)+' '+run.stdout.decode().strip()
 rows.append([mode,result.returncode,h,answer])
with (out/'outcomes.tsv').open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['mode','driver-or-debugger-exit','ELF','runtime']);t.writerows(rows)
assert rows[0][2:]==rows[1][2:] and rows[0][2]!='-'
assert b'ROW_CALLS 0' not in (out/'observed.stdout').read_bytes() and b'FIRST_ROW ' in (out/'skip-publish.stdout').read_bytes()
assert rows[0][2:]!=rows[2][2:],rows
