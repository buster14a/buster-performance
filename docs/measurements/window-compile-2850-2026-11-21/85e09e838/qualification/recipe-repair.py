from pathlib import Path
import csv,hashlib,json,re,shlex,subprocess
s=Path(__file__).resolve().parent;w=s.parent;d=s/'recipe-repair';d.mkdir(exist_ok=True);src=w/'reader-final-role-blocks'
c=next(x for x in json.loads((src/'build/compile_commands.json').read_text()) if x['file'].endswith('main_unit_checker.c'))
args=shlex.split(c['command']);args=[a for a in args[:args.index('-Xclang')] if not a.startswith('-DCMAKE_INTDIR')]
layout=subprocess.check_output([*args,'-Xclang','-fdump-record-layouts','-fsyntax-only',c['file']],cwd=c['directory'],stderr=subprocess.PIPE,text=True)
fields=re.search(r'^\s*0 \| struct ParseKernels\n(.*?)\[sizeof=',layout,re.S|re.M)[1];role_offset=int(re.search(r'^\s*(\d+) \|   \S[^\n]*?\broles$',fields,re.M)[1])
src_args='''cd "$1/switch-inputs"; source ../switch-local-args.sh; tree="$1/pregraph-warning-study/compiler-source"; main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $1/proof-predefines.h $tree/src/buster/compiler/main.c"; v=${2}_arguments;eval "args=(${!v})"; printf '%s\\0' "${args[@]}"'''
gdb='''set pagination off
set debuginfod enabled off
set confirm off
python
import gdb
def read(o,size):return int.from_bytes(gdb.selected_inferior().read_memory(o,size).tobytes(),'little')
class Kernel(gdb.Breakpoint):
 def stop(self):
  global n,roles
  k=int(gdb.parse_and_eval('$rsi')); inp=int(gdb.parse_and_eval('$rdx'))
  n=read(inp+24,4);roles=read(k+ROLE,8)
  if n>=8192:
   with open('OUT.kinds','wb') as f:f.write(gdb.selected_inferior().read_memory(read(inp,8),n).tobytes())
  return False
class Returned(gdb.FinishBreakpoint):
 def stop(self):
  if n>=8192:
   with open('OUT.raw-roles','wb') as f:f.write(gdb.selected_inferior().read_memory(roles,n).tobytes())
  return False
class Checked(gdb.Breakpoint):
 def stop(self):
  Returned(gdb.newest_frame(),internal=True);return False
class Repair(gdb.Breakpoint):
 def stop(self):
  if n>=8192:print('repair',int(gdb.parse_and_eval('$edx')),int(gdb.parse_and_eval('$ecx')))
  return False
Kernel("*'parse_vector.buster_split'")
Checked("*'parse_check_avx512_period.buster_split'")
Repair("*'parse_fallback_item'")
end
run
'''
defs=(src/'src/buster/compiler/c_parser.c').read_text()
def ids(what):
 body=defs.split('#define BUSTER_PARSE_'+what+'(X)',1)[1].split('\n\n',1)[0]
 return {key:i for i,key in enumerate(re.findall(r'X\((\w+)',body))}
k=ids('KINDS');rl=ids('ROLES')
def recipes(role,kind):
 n=len(kind);out=bytearray(n)
 for i,r in enumerate(role):
  if r!=rl['OPERAND'] or kind[i]!=k['IDENTIFIER'] or i+1>=n:continue
  if kind[i+1] not in (k['SEMI'],k['COMMA'],k['EQUAL'],k['R_PAREN']) and role[i+1]!=rl['OPEN_FUNCTION']:continue
  j=i-1;stars=0
  while j>=0 and kind[j]==k['STAR'] and stars<2:
   stars+=1;j-=1
  for size in range(1,5):
   if j<0 or role[j]!=rl['SPECIFIER']:break
   out[j]=8*stars+size;j-=1
 return out
with (s/'recipe-repairs.tsv').open('w',buffering=1) as f,(s/'scalar-repair-ranges.tsv').open('w') as ranges:
 t=csv.writer(f,delimiter='\t',lineterminator='\n');rt=csv.writer(ranges,delimiter='\t',lineterminator='\n')
 t.writerow(['source','tokens','repaired-declarations','repaired-tokens','blocks-requiring-reclassification','early-nonzero','final-nonzero','changed-role-slots','changed-recipe-slots','changed-outside-dirty-blocks','early-recipe-sha256','final-recipe-sha256']);rt.writerow(['source','begin','end-inclusive'])
 for name in ['sqlite','main']:
  opt=subprocess.check_output(['bash','-c',src_args,'_',str(w),name]).decode().strip('\x00').split('\x00')
  script=d/(name+'.gdb');script.write_text(gdb.replace('ROLE',str(role_offset)).replace('OUT',str(d/name)))
  obj=d/'result.o';obj.unlink(missing_ok=True);z=subprocess.run(['gdb','-q','--batch','-x',script,'--args',src/'build/compiler','--lanes','1','-c',*opt,'-o',obj],capture_output=True,timeout=120)
  log=z.stdout+z.stderr;(d/(name+'.log')).write_bytes(log);assert obj.is_file(),log[-1200:]
  kinds=(d/(name+'.kinds')).read_bytes();early=(d/(name+'.raw-roles')).read_bytes();final=(s/'source-depths'/('candidate-'+name+'.bin.roles')).read_bytes();n=len(kinds);assert n==len(early)==len(final)
  rs=[(int(a),int(b)) for a,b in re.findall(rb'^repair (\d+) (\d+)$',log,re.M)]
  dirty=set()
  for a,b in rs:
   rt.writerow([name,a,b]);dirty.update(range(max(a-7,0)//64,b//64+1))
  before=recipes(early,kinds);after=recipes(final,kinds);diff=[i for i in range(n) if before[i]!=after[i]]
  outside=sum(i//64 not in dirty for i in diff);assert not outside
  t.writerow([name,n,len(rs),sum(b-a+1 for a,b in rs),len(dirty),n-before.count(0),n-after.count(0),sum(a!=b for a,b in zip(early,final)),len(diff),outside,hashlib.sha256(before).hexdigest(),hashlib.sha256(after).hexdigest()])
