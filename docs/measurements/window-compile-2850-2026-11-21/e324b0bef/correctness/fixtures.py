from pathlib import Path
import tempfile,csv,subprocess,os,sys
d=Path(__file__).resolve().parent
forms={'add':('static int ca,cb;','ca+cb',''), 'address':('static int ca,cb;','&ca==&cb',''), 'array':('static int ca[3],cb[3];','ca[0]+cb[1]',''), 'function':('static int ca(void),cb(void);','ca()+cb()','static int ca(void){return 2;}static int cb(void){return 1;}'),'repeat':('static int ca,cb;','ca+ca',''), 'conditional':('static int ca,cb;','ca?cb:ca','')}
bodies={'start-return':'{int y=x;kept=y;return kept;}','end':'{int y=x;kept=y;}return kept;','nested':'{int y=x;{int z=y;kept=z;}}return kept;','break':'while(x--){int y=x;kept=y;break;}return kept;','goto':'{int y=x;kept=y;goto end;}end:return kept;','no-block':'kept=x;return kept;'}
with tempfile.TemporaryDirectory() as td,(d/'fixtures.tsv').open('w') as f:
 t=Path(td);w=csv.writer(f,delimiter='\t',lineterminator='\n');w.writerow(['kind','block','mode','status','symbols','relevant_symbols_match_clang'])
 for k,(decl,expr,after) in forms.items():
  for b,stmts in bodies.items():
   src=t/'input.c';src.write_text(f'{decl} static int kept;static int unused(void){{return {expr};}}{after}int live(int x){{{stmts}}}\n');results=[]
   for mode,cc,opts in [('clang','clang',['-O0']),('baseline',d/'main-232da75',['--tier1']),('fixed',d/'fixed-compiler',['--tier1']),('lifetime-off',d/'fixed-compiler',['--tier1','--tier1-no-lifetimes'])]:
    o=t/'o.o';o.unlink(missing_ok=True);p=subprocess.run([cc,*opts,'-c',src,'-o',o],capture_output=True,check=True);symbols=frozenset(line.split()[0] for line in subprocess.check_output(['nm','--format=posix','--defined-only',o],text=True).splitlines() if line.split()[0] in ('ca','cb','unused','kept','live'));results.append(symbols)
    w.writerow([k,b,mode,p.returncode,','.join(sorted(symbols)),int(symbols==results[0])])
   assert results[0]=={'live','kept'} and results[2]==results[3]==results[0],(k,b,results)
