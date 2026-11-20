from pathlib import Path
import json,shlex,subprocess,hashlib,csv
p=Path(__file__).resolve().parent;w=p.parent;d=p/'exact';cc=w/'u32-memory/build/compiler'
ref=p/'tiff/reference';src=w/'independent-corpus/zstd';run=lambda *x,**kw:subprocess.run(list(map(str,x)),check=True,**kw)
cmd=next(t for t in json.loads((ref/'compile_commands.json').read_text()) if t['file'].endswith('/tif_dirread.c'))
a=shlex.split(cmd['command'])[1:];a[a.index('-o')+1]=str(d/'tif_dirread.o');a=['-O2' if x.startswith('-O') else x for x in a];run(cc,'--tier1','--lanes','1','-w','-march=znver5',*a,cwd=cmd['directory'])
flags=['-O2','-std=gnu11','-march=znver5','-DXXH_NAMESPACE=ZSTD_','-DZSTD_LEGACY_SUPPORT=5','-DNDEBUG','-w']+sum((['-I',src/n] for n in ['programs','lib','lib/common','lib/compress','lib/decompress','lib/dictBuilder']),[])
run(cc,'--tier1','--lanes','1',*flags,'-c',src/'tests/decodecorpus.c','-o',d/'decodecorpus.o')
with (d/'apps.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['file','timed_object','committed_object','identical'])
 for a,b in [(p/'tiff/programs/candidate.o',d/'tif_dirread.o'),(p/'zstd/head.o',d/'decodecorpus.o')]:
  s=lambda x:hashlib.file_digest(x.open('rb'),'sha256').hexdigest()
  assert s(a)==s(b);t.writerow([b.name,s(a),s(b),True])
