from common import *
import csv,gzip,json,re,shlex,subprocess
out=D/'mutation';out.mkdir(exist_ok=True);tree=CC.parent.parent
ccdb=json.loads((tree/'build/cmake/native/compile_commands.json').read_text());entry=next(row for row in ccdb if row['file'].endswith('/main_unit_checker.c') and 'Develop' in row['output']);cmd=shlex.split(entry['command']);cmd=[cmd[0],*[a for a in cmd if a.startswith(('-D','-I','-march'))],'-fsyntax-only','-Xclang','-fdump-record-layouts',entry['file']]
layout=subprocess.run(cmd,cwd=entry['directory'],capture_output=True,check=True).stdout.decode();bl=next(b for b in layout.split('*** Dumping AST Record Layout') if re.search(r'^\s*0 \| struct TypeTable\s*$',b,re.M));mi=re.search(r'^\s*(\d+) \|\s+uint32_t first_counted_pointer\s*$',bl,re.M);assert mi is not None,bl[-800:];offset=int(mi[1]);(out/'TypeTable-layout.txt').write_text(bl)
symbols=subprocess.check_output(['nm','-an',CC],text=True);sym=re.findall(r'^([0-9a-f]+) [tT] check_graph_run(?:\.buster_split)?$',symbols,re.M);assert len(sym)==1,sym
cases=sorted((D/'oracle/cases').glob('*pointee-incomplete.c'));assert cases,cases;source=cases[0]
rows=[]
for mode in ('ordinary','observed','discarded-declaration-fact'):
 cmd=[CC,'--lanes','1','-std=c23','-nostdinc','-fsyntax-only',source]
 if mode!='ordinary':
  mut='set *$slot=0\n' if mode=='discarded-declaration-fact' else ''
  g=out/(mode+'.gdb');g.write_text('set pagination off\nset confirm off\nset debuginfod enabled off\nset $hits=0\nbreak *0x'+sym[0]+'\ncommands\nsilent\nset $slot=(unsigned int*)($rdi+'+str(offset)+')\nif *$slot != 0\nprintf "COUNTED_POINTER member=%u\\n",*$slot\nset $hits=$hits+1\n'+mut+'end\ncontinue\nend\nrun\nprintf "COUNTED_HITS=%u\\n",$hits\n')
  cmd=['gdb','-q','--batch','-x',g,'--args',*cmd]
 r=subprocess.run(cmd,env=env,cwd=ROOT,capture_output=True,timeout=120);(out/(mode+'.stdout')).write_bytes(r.stdout);(out/(mode+'.stderr')).write_bytes(r.stderr)
 hits=re.findall(rb'COUNTED_POINTER member=(\d+)',r.stdout);a=r.stderr.count(b'cannot use');b=r.stderr.count(b'cannot assign');rows.append([mode,r.returncode,len(hits),hits[0].decode() if hits else '-',a,b,r.stderr.count(b'error:'),r.stderr.count(b'note:')])
with (out/'results.tsv').open('w') as fp:t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['mode','driver-or-debugger-status','observed-counted-tables','first-member-index','cannot-use','cannot-assign','errors','notes']);t.writerows(rows)
print(rows);assert rows[0][4:]==rows[1][4:] and sum(rows[1][4:6])>0 and rows[1][2] and rows[2][2] and sum(rows[2][4:6])==0,rows
