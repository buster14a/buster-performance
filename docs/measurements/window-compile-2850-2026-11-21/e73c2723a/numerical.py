from common import *
from probes import probes
import csv,gzip,hashlib,json,re,shlex,subprocess,sys
smoke='--smoke' in sys.argv
folder=D/('counts-smoke' if smoke else 'counts');folder.mkdir(exist_ok=True)
def layout(cc):
 data=json.loads((cc.parent.parent/'build/cmake/native/compile_commands.json').read_text());row=next(r for r in data if r['file'].endswith('main_unit_checker.c') and 'Release' in r['output'])
 argv=shlex.split(row['command']);cmd=[argv[0],*[a for a in argv if a.startswith(('-D','-I','-march'))],'-fsyntax-only','-Xclang','-fdump-record-layouts',row['file']]
 blocks=subprocess.run(cmd,cwd=row['directory'],capture_output=True,check=True).stdout.decode().split('*** Dumping AST Record Layout')
 def entry(typ):return next(b for b in blocks if re.search(r'^\s*0 \| struct '+typ+r'\s*$',b,re.M))
 def off(b,pattern):return int(re.search(r'^\s*(\d+) \| '+pattern+r'\s*$',b,re.M)[1])
 prog=entry('CheckProgram');tab=entry('TypeColumns');(folder/(cc.parent.parent.name+'-layouts.txt')).write_text(prog+'\n'+tab)
 return off(prog,r'  const TypeTable \* types'),off(tab,r'  uint8_t \* kind'),off(tab,r'  uint32_t count')
all_offsets={c:layout(c) for c in [CC,PRIOR]}
def symbols(cc):
 rows=subprocess.check_output(['nm','-an',cc],text=True)
 def addr(name):
  m={int(v,16) for v in re.findall(r'^([0-9a-f]+) [tT] '+name+r'(?:\.buster_split)?$',rows,re.M)};assert len(m)==1,(cc,name,m);return next(iter(m))
 return addr('check_lower_node_counts'),addr('check_lower_node_counts_scalar')
def run(cc,name,mode,e,flags,replace):
 m=folder/(name+'.'+mode);cmd=[cc,'--lanes','1','-c',*flags,'-o',m.with_suffix('.'+mode+'.o')];entry,scalar=symbols(cc)
 script=m.with_suffix('.'+mode+'.gdb');script.write_text(f'set pagination off\nset confirm off\nset debuginfod enabled off\npython entry_addr={entry}; scalar_addr={scalar};replacement={replace!r};layout={all_offsets[cc]!r}\nsource {D}/reserve-breakpoints.py\nrun\npython print("RESERVE finished",observations,len(pending))\n')
 r=subprocess.run(['gdb','-nx','-q','--batch','-x',script,'--args',*cmd],cwd=ROOT,env=env|e,capture_output=True,timeout=360)
 for k,b in [('stdout',r.stdout),('stderr',r.stderr)]:Path(str(m)+'.'+k+'.gz').write_bytes(gzip.compress(b,mtime=0))
 rows={int(n):[int(x) for x in v.split()] for n,v in re.findall(rb'^RESERVE (\d+) ([\d ]+)$',r.stdout,re.M)};end=re.search(rb'^RESERVE finished (\d+) (\d+)$',r.stdout,re.M);assert end and int(end[1])==len(rows) and int(end[2])==0,(name,mode,r.returncode,r.stderr[-500:],r.stdout[-400:])
 obj=Path(cmd[-1]);digest=hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else '-';obj.unlink(missing_ok=True)
 table={int(seq):list(map(int,(n,a,v,x))) for seq,n,a,v,x in re.findall(rb'^RESERVE_TABLE (\d+) (\d+) (\d+) (\d+) (\d+)$',r.stdout,re.M)};assert rows.keys()==table.keys()
 return rows,digest,table
bad=[]
with (folder/'outcomes.tsv').open('w',buffering=1) as fp,(folder/'tuples.tsv').open('w',buffering=1) as ft,(folder/'type-census.tsv').open('w',buffering=1) as fc:
 t=csv.writer(fp,delimiter='\t',lineterminator='\n');t.writerow(['input','scope','call-count','compared-values','equal-parent','equal-scalar','same-ELF','candidate-ELF'])
 i=csv.writer(ft,delimiter='\t',lineterminator='\n');i.writerow(['input','scope','mode','sequence','builtins','integer-builtins','atomics','lane-calls','lane-arguments','transport-entries','transport-locals'])
 c=csv.writer(fc,delimiter='\t',lineterminator='\n');c.writerow(['input','scope','mode','sequence','types','atomic-types','gnu-vectors','clang-ext-vectors'])
 for name,flags in ([('atomic-read-write',probes['atomic-read-write'])] if smoke else [*probes.items(),*args.items()]):
  for scope,e in [('ordinary',{})]:
   values={};hashes={}
   for mode,cc,scalar in [('prior',PRIOR,False),('candidate',CC,False),('scalar',CC,True)]:
    rows,h,table=run(cc,name,scope+'.'+mode,e,flags,scalar);values[mode]=rows;hashes[mode]=h
    for seq,j in rows.items():i.writerow([name,scope,mode,seq,*j]);c.writerow([name,scope,mode,seq,*table[seq]])
   n=len(values['candidate']);eq=values['candidate']==values['prior'];tw=values['candidate']==values['scalar'];elf=len(set(hashes.values()))==1
   t.writerow([name,scope,n,7*n,int(eq),int(tw),int(elf),hashes['candidate']]);print(name,scope,n,eq,tw,elf,flush=True)
   if not(eq and tw and elf):bad.append([name,scope,eq,tw,elf])
(folder/'differences.json').write_text(json.dumps(bad,indent=2))
