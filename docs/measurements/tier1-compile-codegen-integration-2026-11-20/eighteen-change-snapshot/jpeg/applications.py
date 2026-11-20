"""Run cjpeg, djpeg, and jpegtran on fixed RGB, grayscale, high-precision and upstream images."""
from pathlib import Path
import csv, hashlib, itertools, os, random, shlex, statistics, subprocess, sys
p=Path(__file__).resolve().parent
w=p.parents[1];d=p/'applications';d.mkdir(exist_ok=True);up=w/'independent-corpus/libjpeg-turbo-3.1.3/testimages'
cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
os.environ.update(LC_ALL='C',SOURCE_DATE_EPOCH='1792454400')
variants=('clang','control','candidate');pads=(0,16,32,48);metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def save(name,head,rows):
 with (d/name).open('w') as h:t=csv.writer(h,delimiter='\t',lineterminator='\n');t.writerow(head);t.writerows(rows)
def exe(v,tool,pad):return d/f'{v}-{tool}-{pad}'
def prepare():
 rng=random.Random(0x197d03);rw,rh=768,512;pix=bytearray();gray=bytearray()
 for y in range(rh):
  for x in range(rw):
   noise=rng.randrange(32);edge=72*((x//47+y//63)&1)
   rgb=[(x//4+y//3+noise+edge)&255,(y//2+noise+(x*y//203)%103)&255,(x//3-y//5+noise+edge)&255]
   pix.extend(rgb);gray.append((77*rgb[0]+150*rgb[1]+29*rgb[2])>>8)
 (d/'pattern.ppm').write_bytes(f'P6\n{rw} {rh}\n255\n'.encode()+pix)
 (d/'pattern.pgm').write_bytes(f'P5\n{rw} {rh}\n255\n'.encode()+gray)
 build=[]
 for v,tool in itertools.product(variants,['cjpeg','djpeg','jpegtran']):
  dr=p/v;cmd=run('ninja','-C',dr,'-t','commands',tool+'-static',capture_output=True,text=True).stdout.splitlines()[-1]
  objects=[x for x in shlex.split(cmd) if x.endswith('.o')];assert objects and (dr/'libjpeg.a').is_file()
  for pad in pads:
   po=d/f'pad{pad}.o';run(cc,'-c','-x','assembler','-','-o',po,input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
   out=exe(v,tool,pad);run(cc,'-no-pie',*[dr/o for o in objects],po,dr/'libjpeg.a','-o',out)
   syms={z[-1]:(z[0],int(z[1],16)) for line in run('nm','-S',out,capture_output=True,text=True).stdout.splitlines() if len(z:=line.split())==4}
   build.append([v,tool,pad,sha(out),sha(dr/'libjpeg.a'),out.stat().st_size,*['/'.join(map(str,syms.get(n,('','')))) for n in ('jpeg_start_compress','jpeg_start_decompress','jpeg_fdct_islow','jpeg_idct_islow','jpeg_fdct_float','jpeg_idct_float')]])
 save('programs.tsv',['compiler','command','pad','exe_sha256','library_sha256','file_bytes','compress_addr_bytes','decompress_addr_bytes','fdct_islow','idct_islow','fdct_float','idct_float'],build)
def cases():
 a=[
 ('encode-color-islow','cjpeg',['-dct','int','-quality','80'],d/'pattern.ppm'),
 ('encode-color-ifast','cjpeg',['-dct','fast','-quality','80'],d/'pattern.ppm'),
 ('encode-color-float','cjpeg',['-dct','float','-quality','80'],d/'pattern.ppm'),
 ('encode-color-progressive','cjpeg',['-progressive','-optimize','-quality','86'],d/'pattern.ppm'),
 ('encode-gray','cjpeg',['-grayscale','-quality','75'],d/'pattern.pgm'),
 ('encode-upstream-photo','cjpeg',['-quality','91','-sample','1x1'],up/'shira_bird8.bmp'),
 ('encode-lossless16','cjpeg',['-precision','16','-lossless','1'],up/'monkey16.pgm'),
 ('encode-12bit','cjpeg',['-precision','12','-quality','84'],up/'monkey16.ppm')]
 for key,tool,args,src in list(a):
  o=d/(key+'.jpg')
  if not o.exists():run(exe('clang',tool,0),*args,'-outfile',o,src,capture_output=True)
 a+= [
 ('decode-islow','djpeg',['-dct','int'],d/'encode-color-islow.jpg'),
 ('decode-ifast','djpeg',['-dct','fast'],d/'encode-color-islow.jpg'),
 ('decode-float','djpeg',['-dct','float'],d/'encode-color-float.jpg'),
 ('decode-progressive','djpeg',[],d/'encode-color-progressive.jpg'),
 ('decode-scaled','djpeg',['-scale','3/8'],d/'encode-color-islow.jpg'),
 ('decode-lossless16','djpeg',[],d/'encode-lossless16.jpg'),
 ('decode-12bit','djpeg',[],d/'encode-12bit.jpg'),
 ('transform-rotate','jpegtran',['-rotate','90','-perfect'],d/'encode-color-islow.jpg'),
 ('transform-progressive','jpegtran',['-progressive','-optimize'],d/'encode-color-islow.jpg'),
 ('transform-arithmetic','jpegtran',['-arithmetic'],d/'encode-color-progressive.jpg')]
 return a
if sys.argv[1]=='build':prepare()
elif sys.argv[1]=='check':
 rows=[];x=[];allcases=cases()
 for key,tool,args,src in allcases:
  for v,pad in itertools.product(variants,pads):
   out=d/(key+'-'+v+'-'+str(pad)+'.product')
   run(exe(v,tool,pad),*args,'-outfile',out,src,capture_output=True)
   digest=sha(out);rows.append([key,tool,' '.join(args),src.name,sha(src),v,pad,out.stat().st_size,digest])
   if tool!='djpeg' and pad==0:
    for decoder in variants:
     tmp=d/'cross-decoded.tmp';run(exe(decoder,'djpeg',0),'-outfile',tmp,out,capture_output=True);x.append([key,v,decoder,sha(tmp),tmp.stat().st_size])
  vals={v:{r[-1] for r in rows if r[0]==key and r[5]==v} for v in variants}
  assert all(len(y)==1 for y in vals.values()) and vals['control']==vals['candidate'],(key,vals)
 save('checks.tsv',['case','tool','args','input','input_sha256','compiler','pad','size','output_sha256'],rows);save('cross-decodes.tsv',['case','producer','decoder','ppm_sha256','bytes'],x)
elif sys.argv[1]=='time':
 cfg=cases();bycase={r[0]:r[1:] for r in cfg};cells=list(itertools.product(bycase,pads));values={};rows=[];stat=d/'last.stat'
 for r in range(9):
  for j in range(len(cells)):
   key,pad=cells[(j+17*r)%len(cells)];tool,args,src=bycase[key]
   for v in (['control','candidate'] if (r+j)%2 else ['candidate','control']):
    run('perf','stat','-e',','.join(metrics),'-x',';','--no-big-num','-o',stat,'--',exe(v,tool,pad),*args,'-outfile','/dev/null',src,capture_output=True)
    counts={z[2]:float(z[0]) for l in stat.read_text().splitlines() if len(z:=l.split(';'))>2 and z[2] in metrics}
    values[r,key,pad,v]=counts;rows.append([r,key,tool,pad,v,*[counts[m] for m in metrics]])
  save('counters.tsv',['round','case','tool','pad','compiler',*metrics],rows);print(r,flush=True)
 out=[]
 for name,pad in cells:
  for m in metrics:
   a=[values[r,name,pad,'control'][m] for r in range(1,9)];b=[values[r,name,pad,'candidate'][m] for r in range(1,9)];z=[100*(v/u-1) for u,v in zip(a,b) if u]
   if z:out.append([name,pad,m,len(z),statistics.median(a),statistics.median(b),statistics.median(z),min(z),max(z)])
 save('paired.tsv',['case','pad','metric','pairs','control_median','candidate_median','paired_percent','minimum_percent','maximum_percent'],out)
