from pathlib import Path
import csv,collections,hashlib,io,itertools,json,math,os,random,shlex,statistics,struct,subprocess,sys,wave
p=Path(__file__).resolve().parent;w=p.parents[1];src=w/'independent-corpus/vorbis-1.3.7';build=p/'out';build.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
vs={'clang':cc,'main':w/'eighteen-control/build/compiler','factor':w/'fma/build/compiler','addend':w/'fma-addend/build/compiler','first':w/'fma-first/build/compiler','combined18':w/'eighteen-candidate/build/compiler'}
metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock'];pads=[0,16,32,48];os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def write(f,head,rows):
 with f.open('w') as o:t=csv.writer(o,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
def rd(f):
 with f.open() as o:return list(csv.DictReader(o,delimiter='\t'))
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def raw(b):return hashlib.sha256(b).hexdigest()
def text(f):return sum(int(x[1]) for l in run('size','-A',f,capture_output=True,text=True).stdout.splitlines() if len(x:=l.split())>2 and x[0].startswith('.text'))
def app(v,pad,action):return build/v/(action+'-'+str(pad))
def input(g):
 x=io.BytesIO();rng=random.Random(219031);data=bytearray()
 for i in range(32768):
  if g=='tones':a=13000*math.sin(i*.049)+6200*math.sin(i*.013);b=9300*math.sin(i*.083)
  elif g=='noise':a=rng.randrange(-17800,17800);b=rng.randrange(-17800,17800)
  elif g=='transients':a=(24000 if i%847<4 else 0)+6500*math.sin(i*.071)*math.exp(-(i%1393)/600);b=-a*.8
  else:a=b=0
  data.extend(struct.pack('<hh',int(a),int(b)))
 with wave.open(x,'wb') as out:out.setnchannels(2);out.setsampwidth(2);out.setframerate(44100);out.writeframes(data)
 return x.getvalue()
groups=['tones','noise','transients','silence']
if sys.argv[1]=='build':
 v=sys.argv[2];d=build/v;d.mkdir(exist_ok=True);args=['-I'+str(src/'include'),'-O2','-std=gnu99','-march=x86-64-v3'];c=vs[v];units=[];libs=collections.defaultdict(list)
 for r in json.loads((p/'config/compile_commands.json').read_text()):
  name=Path(r['file']);flags=shlex.split(r['command'])[1:];i=flags.index('-o');lib=next(n for n in ['vorbis','vorbisenc','vorbisfile'] if '/'+n+'.dir/' in flags[i+1]);o=d/(name.name+'.o');flags[i+1]=str(o)
  result=subprocess.run(list(map(str,[c,*(['--tier1','--lanes','1','-w'] if v!='clang' else []),*flags])),cwd=r['directory'],capture_output=True)
  (d/(name.name+'.log')).write_bytes(result.stdout+result.stderr)
  if result.returncode:print(name.name,(result.stdout+result.stderr).decode(errors='replace')[:750],flush=True);raise SystemExit(result.returncode)
  libs[lib].append(o);units.append([v,lib,name.name,sha(name),sha(o),text(o)])
 for lib,objects in libs.items():run('ar','rcsD',d/('lib'+lib+'.a'),*objects)
 write(d/'units.tsv',['variant','library','source','source_sha256','object_sha256','text'],units)
 fixed=d/'clock.o';run(cc,*args,'-c','-x','c','-','-o',fixed,input=b'#include <time.h>\ntime_t __wrap_time(time_t *v){time_t n=1792454400;if(v)*v=n;return n;}\n')
 objects=[]
 for name in ['util','write_read','test']:
  o=d/(name+'-test.o');run(cc,*args,'-c',src/'test'/(name+'.c'),'-o',o);objects.append(o)
 local=[d/('lib'+l+'.a') for l in ['vorbisfile','vorbisenc','vorbis']]
 run(cc,'-no-pie',*objects,fixed,'-Wl,--wrap=time',*local,'-logg','-lm','-o',d/'upstream-test')
 rows=[]
 for act,file in [('encode','encoder_example'),('decode','decoder_example')]:
  driver=d/(act+'.o');run(cc,*args,'-c',src/'examples'/(file+'.c'),'-o',driver)
  for pad in pads:
   pad_o=d/f'pad{pad}.o';run(cc,'-c','-x','assembler','-','-o',pad_o,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
   f=app(v,pad,act);mp=d/(f.name+'.map');run(cc,'-no-pie',driver,fixed,pad_o,'-Wl,--wrap=time','-Wl,-Map,'+str(mp),*local,'-logg','-lm','-o',f)
   dep=run('ldd',f,capture_output=True,text=True).stdout;assert 'libvorbis' not in dep and 'libogg' in dep
   syms={z[-1]:(z[0],z[1]) for l in run('nm','-S',f,capture_output=True,text=True).stdout.splitlines() if len(z:=l.split())==4}
   rows.append([v,act,pad,sha(f),text(f),*[','.join(syms.get(s,('-','-'))) for s in ['mdct_forward','mdct_backward','vorbis_analysis','vorbis_synthesis']]])
 write(d/'programs.tsv',['variant','tool','pad','exe_sha256','text_bytes','mdct_forward_addr_size','mdct_backward_addr_size','analysis_addr_size','synthesis_addr_size'],rows)
 print(v,len(units),'objects',flush=True)
elif sys.argv[1]=='official':
 v=sys.argv[2];d=build/v;td=d/'upstream';td.mkdir(exist_ok=True)
 with (d/'upstream.log').open('wb') as h:r=subprocess.run([d/'upstream-test'],cwd=td,stdout=h,stderr=h,timeout=320)
 s=(d/'upstream.log').read_text(errors='replace');print(v,r.returncode,s.count(': ok'),s[-190:]);(d/'official.status').write_text(str(r.returncode)+'\n');sys.exit(r.returncode)
elif sys.argv[1]=='check':
 obs=p/'applications';obs.mkdir(exist_ok=True);variants=[v for v in vs if (build/v/'programs.tsv').exists()];assert all(v in variants for v in ['clang','factor','addend','main'])
 enc=[];dec=[]
 for g in groups:
  wav=input(g);(obs/f'{g}.wav').write_bytes(wav);output={}
  for v in variants:
   for pad in pads:
    audio=run(app(v,pad,'encode'),input=wav,capture_output=True).stdout
    assert audio.startswith(b'OggS');enc.append([g,v,pad,raw(wav),raw(audio),len(audio)])
    if pad==0:output[v]=audio;(obs/f'{g}-{v}.ogg').write_bytes(audio)
    else:assert audio==output[v]
  assert all(output[v]==output['factor'] for v in ('addend','first') if v in vs and v in variants),(g,[(k,raw(val)) for k,val in output.items()])
  for producer,data in output.items():
   cmp={}
   for v in variants:
    pcm=run(app(v,0,'decode'),input=data,capture_output=True).stdout;assert len(pcm)==32768*4,(g,len(pcm))
    dec.append([g,producer,v,raw(data),raw(pcm),len(pcm)]);cmp[v]=pcm
   assert all(cmp[v]==cmp['factor'] for v in ('addend','first') if v in variants)
 write(obs/'encoders.tsv',['audio','variant','pad','input_sha256','ogg_sha256','encoded_bytes'],enc);write(obs/'cross-decoders.tsv',['audio','producer','decoder','ogg_sha256','pcm_sha256','decoded_bytes'],dec)
elif sys.argv[1]=='time':
 obs=p/'applications';variants=['factor','addend','first'];assert all((build/v/'programs.tsv').exists() for v in variants)
 gold_e={(r['audio'],r['variant']):r['ogg_sha256'] for r in rd(obs/'encoders.tsv')}
 gold_d={(r['audio'],r['decoder']):r['pcm_sha256'] for r in rd(obs/'cross-decoders.tsv') if r['producer']=='factor'}
 cells=list(itertools.product(['tones','noise','transients'],['encode','decode'],pads));orders=list(itertools.permutations(variants));res=[];vals={};stat=obs/'last.stat'
 for r in range(8):
  for j in range(len(cells)):
   g,act,pad=cells[(j+7*r)%len(cells)];f=obs/(g+('.wav' if act=='encode' else '-factor.ogg'));payload=f.read_bytes()
   for v in orders[(r+j)%6]:
    x=run('perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',stat,'--',app(v,pad,act),input=payload,capture_output=True);digest=raw(x.stdout)
    assert digest==(gold_e if act=='encode' else gold_d)[g,v]
    u={z[2]:float(z[0]) for l in stat.read_text().splitlines() if len(z:=l.split(';'))>2 and z[2] in metrics};vals[g,act,pad,r,v]=u;res.append([g,act,pad,r,v,digest,*[u[m] for m in metrics]])
  print('round',r,flush=True)
 write(obs/'counters.tsv',['audio','action','pad','round','variant','output_sha256',*metrics],res);summary=[]
 for g,act,pad in cells:
  for a,b in [('factor','addend'),('addend','first'),('factor','first')]:
   for m in metrics:
    base=[vals[g,act,pad,r,a][m] for r in range(1,8)];head=[vals[g,act,pad,r,b][m] for r in range(1,8)];z=[100*(y/x-1) for x,y in zip(base,head) if x]
    if z:summary.append([g,act,pad,a,b,m,len(z),statistics.median(base),statistics.median(head),statistics.median(z),min(z),max(z)])
 write(obs/'paired.tsv',['audio','action','pad','base','candidate','metric','pairs','base_median','candidate_median','paired_percent','min_percent','max_percent'],summary)
