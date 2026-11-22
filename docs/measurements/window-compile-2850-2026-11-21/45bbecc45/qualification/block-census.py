from pathlib import Path
import array,collections,csv,hashlib,json,re,shlex,subprocess
s=Path(__file__).resolve().parent;w=s.parent;src=w/'fixed-parser-parents';d=s/'key-blocks';d.mkdir(exist_ok=True)
c=next(x for x in json.loads((src/'build/compile_commands.json').read_text()) if x['file'].endswith('main_unit_checker.c'));args=shlex.split(c['command']);args=[a for a in args[:args.index('-Xclang')] if not a.startswith('-DCMAKE_INTDIR')]
layout=subprocess.check_output([*args,'-Xclang','-fdump-record-layouts','-fsyntax-only',c['file']],cwd=c['directory'],stderr=subprocess.PIPE,text=True)
fields=re.search(r'^\s*0 \| struct ParseKernels\n(.*?)\[sizeof=',layout,re.S|re.M)[1]
def offset(key):return int(re.search(r'^\s*(\d+) \|   \S[^\n]*?\b'+key+r'$',fields,re.M)[1])
src_args='''cd "$1/switch-inputs"; source ../switch-local-args.sh; tree="$1/pregraph-warning-study/compiler-source"; main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $1/proof-predefines.h $tree/src/buster/compiler/main.c"; v=${2}_arguments;eval "args=(${!v})"; printf '%s\\0' "${args[@]}"'''
gdb='''set pagination off
set debuginfod enabled off
set confirm off
python
import gdb
class Observe(gdb.Breakpoint):
 def stop(self):
  k=int(gdb.parse_and_eval('$rdi'));n=int(gdb.parse_and_eval('$esi'))
  def read(o):return int.from_bytes(gdb.selected_inferior().read_memory(k+o,8).tobytes(),'little')
  if n>=8192:
   print('k4-input',n)
   for ext,off in [('roles',ROLES),('depths',DEPTHS)]:
    with open('OUT.'+ext,'wb') as f:f.write(gdb.selected_inferior().read_memory(read(off),n).tobytes())
  return False
Observe("*'parse_parents_vector.buster_split'")
end
run
'''
with (s/'block-census.tsv').open('w',buffering=1) as f:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');t.writerow(['source','tokens','block-width','complete-blocks','distinct-contexts','duplicated-blocks','top16-coverage','top256-coverage','top1024-coverage','roles-sha256','depths-sha256'])
 for name in ['sqlite','main']:
  opts=subprocess.check_output(['bash','-c',src_args,'_',str(w),name]).decode().strip('\x00').split('\x00')
  script=d/(name+'.gdb');script.write_text(gdb.replace('ROLES',str(offset('roles'))).replace('DEPTHS',str(offset('node_depths'))).replace('OUT',str(d/name)))
  o=d/'result.o';o.unlink(missing_ok=True);r=subprocess.run(['gdb','-q','--batch','-x',script,'--args',src/'build/compiler','--lanes','1','-c',*opts,'-o',o],capture_output=True,timeout=50)
  log=r.stdout+r.stderr;(d/(name+'.log')).write_bytes(log);assert b'k4-input' in log and o.is_file(),log[-1400:]
  roles=(d/(name+'.roles')).read_bytes();depth=(d/(name+'.depths')).read_bytes();n=len(roles);assert n==len(depth)
  for k in [8,16,32,64,128,256]:
   hist=collections.Counter()
   for i in range(0,n-k+1,k):
    dep=depth[i:i+k];m=min(dep);hist[(roles[i:i+k],bytes(x-m for x in dep))]+=1
   v=sorted(hist.values(),reverse=True);t.writerow([name,n,k,n//k,len(hist),n//k-len(hist),*[sum(v[:j]) for j in [16,256,1024]],hashlib.sha256(roles).hexdigest(),hashlib.sha256(depth).hexdigest()])
