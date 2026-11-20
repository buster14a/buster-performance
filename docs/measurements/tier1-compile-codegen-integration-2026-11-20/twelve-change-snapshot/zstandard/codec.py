from pathlib import Path
import csv,hashlib,json,os,random,statistics,struct,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];repo=w/'independent-corpus/zstd';cc=Path('/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang');data=p/'streams';out=p/'programs';raw=p/'counters';[f.mkdir(exist_ok=True) for f in (data,out,raw)];vs=['clang','control','candidate'];pads=[0,16,32,48];cases=['sqlite','records','noise','mixed'];levels=[1,3,9,15];metrics=['instructions:u','cycles:u','branches:u','branch-misses:u','task-clock'];os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*cmd,**kw):return subprocess.run(list(map(str,cmd)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def tab(name,cols,rows):
 with (p/name).open('w') as f:wri=csv.writer(f,delimiter='\t',lineterminator='\n');wri.writerow(cols);wri.writerows(rows)
def names(case,level):return data/(case+'.bin'),data/f'{case}-{level}.zst'
def iterations(case,level,mode):return 18 if mode=='decompress' else 2 if level>=9 and case!='noise' else 8
if sys.argv[1]=='build':
 assert all((p/(v+'-mt.status')).read_text().strip()=='0' for v in vs);libs={v:p/(v+'-mt/lib/libzstd.a') for v in vs};items=[];stored={};inputs={};size=768*1024;rng=random.Random(302835)
 inputs['sqlite']=(w/'compile-evidence/inputs/sqlite3.c').read_bytes()[400000:400000+size];buf=bytearray()
 for i in range(18000):buf.extend(f'{i//29:08d}Z sensor {i%119:03d} controller {(i*5953)%527:05d} {(i*i)%193} {"open" if i%9==0 else "ready"}\n'.encode())
 inputs['records']=(buf+buf)[:size];inputs['noise']=rng.randbytes(size);mix=bytearray()
 while len(mix)<size:mix.extend(inputs['records'][8192:24576]);mix.extend(rng.randbytes(4096));mix.extend(inputs['sqlite'][32768:65536])
 inputs['mixed']=mix[:size]
 for key,value in inputs.items():assert len(value)==size;(data/(key+'.bin')).write_bytes(value)
 run(cc,'-O2','-I',repo/'lib','-c',p/'codec.c','-o',out/'driver.o');run(cc,'-O2','-I',repo/'lib','-c',p/'gold.c','-o',out/'gold.o');run(cc,'-no-pie',out/'gold.o',libs['clang'],'-pthread','-o',out/'gold')
 for v in vs:
  for pad in pads:
   po=out/f'pad{pad}.o';run(cc,'-x','assembler','-c','-','-o',po,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode());exe=out/f'codec-{v}-{pad}';run(cc,'-no-pie',out/'driver.o',po,libs[v],'-pthread','-o',exe);nm=[l.split() for l in run('nm','-S','--defined-only',exe,capture_output=True,text=True).stdout.splitlines()];sy={c[3]:c[:2] for c in nm if len(c)==4};items.append([v,pad,sha(libs[v]),sha(exe),*[int(x,16) for f in ['ZSTD_compressCCtx','ZSTD_decompressDCtx'] for x in sy[f]]])
 tab('programs.tsv',['compiler','layout','library_sha256','runner_sha256','compress_address','compress_bytes','decompress_address','decompress_bytes'],items)
 for case in cases:
  for level in levels:
   src,frame=names(case,level);run(out/'gold',src,frame,str(level));stored[case,level]=[src.stat().st_size,sha(src),frame.stat().st_size,sha(frame)];
   for v in vs:
    for pad in pads:
     for mode in ['compress','decompress']:
      result=run(out/f'codec-{v}-{pad}',mode,src,frame,str(level),'1',capture_output=True,text=True).stdout.strip();assert result==stored.setdefault((case,level,mode),result)
 tab('streams.tsv',['case','level','input_size','input_sha256','frame_size','clang_frame_sha256','compressed_check','decoded_check'],[[case,level,*stored[case,level],stored[case,level,'compress'],stored[case,level,'decompress']] for case in cases for level in levels])
elif sys.argv[1]=='time':
 records={(r['case'],int(r['level'])):r for r in csv.DictReader((p/'streams.tsv').open(),delimiter='\t')};settings=[(case,level,pad,mode) for case in cases for level in levels for pad in pads for mode in ['compress','decompress']];rows=[]
 for rep in range(7):
  for i in range(len(settings)):
   case,level,pad,mode=settings[(i+13*rep)%len(settings)];a=['control','candidate'] if (rep+i)%2==0 else ['candidate','control'];src,frame=names(case,level);expected=records[case,level]['decoded_check' if mode=='decompress' else 'compressed_check']
   for v in a:
    name=f'{rep}-{case}-{level}-{pad}-{mode}-{v}';f=raw/(name+'.stat');ok=f.with_suffix('.ok');n=iterations(case,level,mode)
    if not ok.exists():
     z=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',f,'--',out/f'codec-{v}-{pad}',mode,src,frame,str(level),str(n),capture_output=True,text=True,timeout=100);assert z.stdout.strip()==expected;ok.write_text(z.stdout.strip()+'\n')
    assert ok.read_text().strip()==expected;vals={z[2]:float(z[0]) for l in f.read_text().splitlines() if len(z:=l.split(';'))>=3};rows.append([rep,case,level,pad,mode,v,n,*[vals[x] for x in metrics],expected])
  print('round',rep,'complete',flush=True)
 tab('counters.tsv',['round','input','level','layout','mode','compiler','loops',*metrics,'expected'],rows);ss=[]
 for setting in settings:
  for j,metric in enumerate(metrics):
   a={v:[r[7+j] for r in rows if r[0] and r[1:5]==list(setting) and r[5]==v] for v in ['control','candidate']};ds=[100*(b/c-1) for c,b in zip(a['control'],a['candidate'])];assert len(ds)==6;ss.append([*setting,metric,6,statistics.median(a['control']),statistics.median(a['candidate']),statistics.median(ds),min(ds),max(ds)])
 tab('paired.tsv',['input','level','layout','mode','metric','pairs','base_median','candidate_median','paired_pct','min_pct','max_pct'],ss)
