from pathlib import Path
import csv,hashlib,itertools,os,shlex,statistics,struct,subprocess,sys
p=Path(__file__).resolve().parent;w=p.parents[1];src=w/'independent-corpus/opus-1.5.2';cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang';arch=os.environ.get('OPUS_TEST_ARCH','znver5');d=p/('audio' if arch=='znver5' else 'audio-'+arch);d.mkdir(exist_ok=True);modes=[m if arch=='znver5' else m+'-'+arch for m in ('portable-nosp','dispatch-nosp')];vs=['clang','control','candidate'];pads=[0,16,32,48];os.environ.update(LC_ALL='C')
def run(*a,**kw):return subprocess.run(list(map(str,a)),check=True,**kw)
def sha(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def tab(dest,header,rows):
 with (p/(dest if arch=='znver5' else arch+'-'+dest)).open('w') as f:t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(header);t.writerows(rows)
def compare(a,b):
 import array,math
 x=array.array('h');x.frombytes(a.read_bytes());y=array.array('h');y.frombytes(b.read_bytes());assert len(x)==len(y)
 if x==y:return [len(x),0,0,0.]
 dif=[i-j for i,j in zip(x,y)];return [len(x),sum(i!=0 for i in dif),max(map(abs,dif)),math.sqrt(sum(i*i for i in dif)/len(dif))]
def exe(m,v,pad):return d/f'{m}-{v}-{pad}'
if sys.argv[1]=='build':
 run(cc,'-O2','-I'+str(src/'include'),'-c',p/'audio.c','-o',d/'main.o')
 for pad in pads:run(cc,'-x','assembler','-c','-','-o',d/f'pad{pad}.o',input=f'.text\n.balign 256\n.space {pad},0x90\n.section .note.GNU-stack,"",@progbits\n'.encode())
 rows=[]
 for m,v,pad in itertools.product(modes,vs,pads):
  f=exe(m,v,pad);lib=p/'compiled'/m/v/'libopus.a';run(cc,'-no-pie',d/'main.o',d/f'pad{pad}.o',lib,'-lm','-o',f);nm=run('nm','-S',f,capture_output=True,text=True).stdout;syms={t[3]:(int(t[0],16),int(t[1],16)) for l in nm.splitlines() if len(t:=l.split())==4};rows.append([m,v,pad,sha(lib),sha(f),*[x for n in ['opus_encode','opus_decode','opus_encode_float'] for x in syms[n]]])
 tab('audio-programs.tsv',['mode','compiler','pad','archive_sha256','exe_sha256','encode_address','encode_bytes','decode_address','decode_bytes','encode_float_address','encode_float_bytes'],rows)
elif sys.argv[1]=='check':
 packets=[];decoded=[];comparison=[];enc_checks=[];bad=[]
 for m in modes:
  for profile in range(7):
   for encoder in vs:
    pkt=d/f'{m}-{profile}-{encoder}.packets';run(exe(m,encoder,0),'encode',profile,pkt,'unused',timeout=30);packets.append([m,profile,encoder,pkt.stat().st_size,sha(pkt)])
   for encoder in vs:
    pkt=d/f'{m}-{profile}-{encoder}.packets';ref=d/f'{m}-{profile}-control.packets';enc_checks.append([m,profile,encoder,sha(pkt)==sha(ref)])
    if encoder=='candidate' and sha(pkt)!=sha(ref):bad.append([m,profile,'encode'])
    for loss in ['decode','loss']:
     pcm={}
     for dec in vs:
      path=d/f'{m}-{profile}-{encoder}-{loss}-{dec}.pcm';run(exe(m,dec,0),loss,profile,pkt,path,timeout=30);pcm[dec]=path;decoded.append([m,profile,encoder,dec,loss,path.stat().st_size,sha(path)])
     for a,b in [('control','candidate'),('clang','control'),('clang','candidate')]:
      stats=compare(pcm[a],pcm[b]);comparison.append([m,profile,encoder,loss,a,b,*stats])
      if a=='control' and stats[1]:bad.append([m,profile,'decode'])
 tab('packets.tsv',['mode','profile','encoder','encoded_bytes','sha256'],packets);tab('pcm.tsv',['mode','profile','encoder','decoder','loss_schedule','pcm_bytes','sha256'],decoded);tab('encoders.tsv',['mode','profile','encoder','matches_control'],enc_checks);tab('decoders.tsv',['mode','profile','encoder','loss_schedule','decoder_a','decoder_b','samples','different_samples','peak_lsb','rms_lsb'],comparison);print('parent/candidate differences:',bad)
