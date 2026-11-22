from pathlib import Path
import array,csv,hashlib,json,re,shlex,subprocess
st=Path(__file__).resolve().parent;w=st.parent
d=st/'source-depths';d.mkdir(exist_ok=True)
prefix=''.join(f'typedef int Pad{i};\n' for i in range(2060))
sources={'sqlite':None,'main':None}
for n in [249,254,257,2060]:
 f=d/f'paren-{n}.c';f.write_text(prefix+'int f(int x){return '+'('*n+'x'+')'*n+';}\n');sources['paren-'+str(n)]=f
# Each long function ends on a different lane of a 64-row cut block.
parts=[];position=0
for lane in range(64):
 n=1410;pad=(lane-(position+3*n+10))%64
 parts.append(f'int f{lane}(int x){{'+'x++;'*n+';'*pad+'return x;}\n')
 position+=3*n+11+pad
f=d/'all-cut-lanes.c';f.write_text(''.join(parts));sources['all-cut-lanes']=f
program='''set pagination off
set debuginfod enabled off
set confirm off
python
import gdb,os
def present(addr,length):
 page=os.sysconf('SC_PAGE_SIZE');start=(addr+page-1)//page;end=(addr+length)//page;count=max(0,end-start)
 with open('/proc/%d/pagemap'%gdb.selected_inferior().pid,'rb') as pages:
  pages.seek(8*start);data=pages.read(8*count)
  assert len(data)==8*count
 return (sum(data[i+7]>>7 for i in range(0,len(data),8)),count)
def read(p,n):
 return int.from_bytes(gdb.selected_inferior().read_memory(p,n).tobytes(),'little')
class Returned(gdb.FinishBreakpoint):
 def __init__(self,ptr):
  super().__init__(gdb.newest_frame(),internal=True);self.ptr=ptr
 def stop(self):
  p=self.ptr;n=read(p+COUNT,4);q=read(p+DEPTHS,8);b=BYTE
  print('source-depths',n,b)
  if n>=8192 and q:
   for suffix,ptr,size in [('',q,n*(1 if b else 4)),('.roles',read(p+ROLES,8),n),('.parents',read(p+PARENTS,8),n*4)]:
    with open('RAW'+suffix,'wb') as f:f.write(gdb.selected_inferior().read_memory(ptr,size).tobytes())
   try:
    for name,offset,length in [('lefts',LEFTS,4*n),('left_keys',LKEYS,2*n),('works',WORKS,((n+63)//64)*384)]:
     resident,pages=present(read(p+offset,8),length);print('precedence-resident',name,length,resident,pages)
   except OSError as error:
    print('residency-unavailable',error)
   TILES
  return False
class Enter(gdb.Breakpoint):
 def stop(self):
  Returned(int(gdb.parse_and_eval('$rdi')))
  return False
Enter('*parse_translation_unit')
end
run
'''
src_args='''cd "$1/switch-inputs"; source ../switch-local-args.sh; tree="$1/pregraph-warning-study/compiler-source"; main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $1/proof-predefines.h $tree/src/buster/compiler/main.c"; v=${2}_arguments;eval "args=(${!v})"; printf '%s\\0' "${args[@]}"'''
claims={}; page_claims=[]
for label,tree in [('baseline','main-fbef-clean'),('candidate','tile-parser-precedence')]:
 path=w/tree
 c=next(x for x in json.loads((path/'build/compile_commands.json').read_text()) if x['file'].endswith('main_unit_checker.c'))
 args=shlex.split(c['command']);args=[a for a in args[:args.index('-Xclang')] if not a.startswith('-DCMAKE_INTDIR')]
 defs=subprocess.check_output([*args,'-Xclang','-fdump-record-layouts','-fsyntax-only',c['file']],cwd=c['directory'],stderr=subprocess.PIPE,text=True)
 def offs(rec,key):
  match=re.search(r'^\s*0 \| struct '+rec+r'\n(.*?)\[sizeof=',defs,re.S|re.M)[1]
  return int(re.search(r'^\s*(\d+) \|   \S[^\n]*?\b'+key+r'$',match,re.M)[1])
 buf=offs('Parser','buffers');left=buf+offs('ParseVectorBuffers','lefts');keys=buf+offs('ParseVectorBuffers','left_keys');work=buf+offs('ParseVectorBuffers','works')
 t=offs('Parser','tree');ow=t+offs('ParseTree','roles');pw=t+offs('ParseTree','parents');n=offs('Parser','tokens')+offs('ParseTokens','count');dc=t+offs('ParseTree','depths')
 for name,source in sources.items():
  raw=d/(label+'-'+name+'.bin');scr=d/(label+'-'+name+'.gdb')
  tile='pass'
  if label=='candidate' and tree=='tile-parser-precedence':
   k=offs('Parser','kernels');nc=k+offs('ParseKernels','parent_tile_count');qc=k+offs('ParseKernels','waiting_thresholds');ad=k+offs('ParseKernels','absolute_check_depths')
   tile=f"m=read(p+{nc},4);zc=read(p+{qc},8); cuts=[read(zc+i*4,4) for i in range(m)]; print('parent-tiles',m,max(y-(x&~3)+1 for x,y in zip([0]+cuts,cuts+[n-1]))); print('cut-lanes',sorted(set(v%64 for v in cuts))); print('absolute-frames',read(p+{ad},1))"
  scr.write_text(program.replace('LEFTS',str(left)).replace('LKEYS',str(keys)).replace('WORKS',str(work)).replace('TILES',tile).replace('ROLES',str(ow)).replace('PARENTS',str(pw)).replace('COUNT',str(n)).replace('DEPTHS',str(dc)).replace('BYTE',f'read(p+{t+offs("ParseTree","byte_depths")},1)' if label=='candidate' else '0').replace('RAW',str(raw)))
  opts=[source] if source else subprocess.check_output(['bash','-c',src_args,'_',str(w),name]).decode().strip('\x00').split('\x00')
  obj=d/'result.o';obj.unlink(missing_ok=True)
  r=subprocess.run(['gdb','-q','--batch','-x',scr,'--args',path/'build/compiler','--lanes','1','-c',*opts,'-o',d/'result.o'],capture_output=True,timeout=50)
  log=r.stdout+r.stderr;(d/(label+'-'+name+'.log')).write_bytes(log)
  captures=re.findall(rb'^source-depths (\d+) (\d+)$',log,re.M)
  assert captures and raw.exists(),(name,log[-1000:])
  for region,l,present,pages in re.findall(rb'^precedence-resident (\w+) (\d+) (\d+) (\d+)$',log,re.M):
   page_claims.append([name,label,region.decode(),int(l),int(present),int(pages)])
  n0,b=[int(v) for v in captures[-1]];data=raw.read_bytes();v=array.array('I')
  if b:v.extend(data)
  else:v.frombytes(data)
  assert len(v)==n0
  cuts=re.findall(rb'^parent-tiles (\d+) (\d+)$',log,re.M);nc,mx=map(int,cuts[-1]) if cuts else (0,n0)
  if name=='all-cut-lanes' and label=='candidate':
   assert nc==64 and ('cut-lanes '+str(list(range(64)))).encode() in log,(nc,log[-2500:])
  elf=obj.read_bytes() if obj.exists() else b''
  assert elf[:4]==b'\x7fELF',(name,label,log[-800:])
  frames=re.findall(rb'^absolute-frames ([01])$',log,re.M);af=int(frames[-1]) if frames else 0
  claims[name,label]=(n0,b,len(data),max(v),hashlib.sha256(v.tobytes()).hexdigest(),*[hashlib.sha256(Path(str(raw)+ext).read_bytes()).hexdigest() for ext in ['.roles','.parents']],nc,mx,af,len(elf),hashlib.sha256(elf).hexdigest())
with (st/'physical.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','compiler','tokens','packed','token-depth-payload-bytes','max-depth','u32-depth-sha256','roles-sha256','parents-sha256','parent-cuts','largest-parent-tile','absolute-check-frames','object-bytes','object-sha256'])
 for name in sources:
  a,b=claims[name,'baseline'],claims[name,'candidate'];assert a[0]==b[0] and a[3:7]==b[3:7] and a[-2:]==b[-2:],(name,a,b)
  for label in ['baseline','candidate']:t.writerow([name,label,*claims[name,label]])
  print(name,b)

with (st/'precedence-residency.tsv').open('w') as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','compiler','column','nominal-live-column-bytes','resident-interior-pages','whole-interior-pages']);t.writerows(page_claims)
