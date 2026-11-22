from pathlib import Path
import csv,hashlib,json,re,shlex,shutil,subprocess,tempfile
study=Path(__file__).resolve().parent;w=study.parent;src=w/'sizeof-expression-spans'
observed=study/'source-observations';observed.mkdir(exist_ok=True)
c=next(x for x in json.loads((src/'build/compile_commands.json').read_text()) if x['file'].endswith('main_unit_checker.c'))
args=shlex.split(c['command'])
args=[a for a in args[:args.index('-Xclang')] if not a.startswith('-DCMAKE_INTDIR')]
layout=subprocess.check_output([*args,'-Xclang','-fdump-record-layouts','-fsyntax-only',c['file']],cwd=c['directory'],stderr=subprocess.PIPE,text=True)
def offsets(struct,names):
    desc=re.search(r'^\s*0 \| struct '+struct+r'\n(.*?)\[sizeof=',layout,re.S|re.M)[1]
    return {n:int(re.search(r'^\s*(\d+) \|   \S[^\n]*?\b'+n+r'$',desc,re.M)[1]) for n in names}
ofs=offsets('CheckInput',['token_count','sizeof_span_parser','sizeof_spans','sizeof_span_count'])
tree=offsets('Parser',['tree'])['tree'];roles=offsets('ParseTree',['roles'])['roles']
# Read role values from this exact C source, including explicit assignments where present.
g_enum=(src/'src/buster/compiler/c_parser.c').read_text()
rolelist=g_enum.split('#define BUSTER_PARSE_ROLES(X)',1)[1].split('typedef enum ParseRole',1)[0]
roles_map={ident:i for i,ident in enumerate(re.findall(r'^    X\((\w+),',rolelist,re.M))}
ops={roles_map[n] for n in ['ADDITIVE','ASSIGN','COMMA','SEPARATOR']}
srcargs='''cd "$1/switch-inputs"; source ../switch-local-args.sh; tree="$1/pregraph-warning-study/compiler-source"; main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $1/proof-predefines.h $tree/src/buster/compiler/main.c"; v=${2}_arguments;eval "args=(${!v})"; printf '%s\\0' "${args[@]}"'''
with tempfile.TemporaryDirectory(dir=study) as tmp:
    d=Path(tmp)
    with (study/'source-regions.tsv').open('w') as f:
        wr=csv.writer(f,delimiter='\t',lineterminator='\n');wr.writerow(['source','tokens','coalesced-ranges','covered-tokens','old-operator-lanes','new-operator-lanes','span-bytes-sha256','native-object-sha256'])
        for name in ['sqlite','main']:
            parsed=subprocess.check_output(['bash','-c',srcargs,'_',str(w),name]).decode().strip('\x00').split('\x00')
            dbg=d/'run.gdb';dbg.write_text(f'''set pagination off
set debuginfod enabled off
set confirm off
python
import gdb
def read(ptr,size):
 return int.from_bytes(gdb.selected_inferior().read_memory(ptr,size).tobytes(),'little')
class Worker(gdb.Breakpoint):
 def stop(self):
  parser=int(gdb.parse_and_eval('$rdi'));inp=int(gdb.parse_and_eval('$rdx'));n=read(inp+{ofs["token_count"]},4)
  if n>10000:
   assert parser==read(inp+{ofs["sizeof_span_parser"]},8),(parser,n)
   cnt=read(inp+{ofs["sizeof_span_count"]},4)
   with open('{d}/spans','wb') as fn:fn.write(gdb.selected_inferior().read_memory(read(inp+{ofs["sizeof_spans"]},8),cnt*8).tobytes())
   with open('{d}/roles','wb') as fn:fn.write(gdb.selected_inferior().read_memory(read(parser+{tree+roles},8),n).tobytes())
  return False
Worker("*'check_driver_common_warnings.buster_split'")
end
run
''')
            (d/'roles').unlink(missing_ok=True);(d/'spans').unlink(missing_ok=True)
            result=subprocess.run(['gdb','-q','--batch','-x',dbg,'--args',src/'build/compiler','--lanes','1','-c',*parsed,'-o',d/'unit.o'],capture_output=True,timeout=120)
            (study/(name+'-source-regions.log')).write_bytes(result.stdout+result.stderr)
            rolebytes=(d/'roles').read_bytes();spanbytes=(d/'spans').read_bytes()
            for capture in ['roles','spans','run.gdb']:
                shutil.copy(d/capture,observed/(name+'-'+capture))
            spans=[(int.from_bytes(spanbytes[i:i+4],'little'),int.from_bytes(spanbytes[i+4:i+8],'little')) for i in range(0,len(spanbytes),8)]
            assert all(0<a<b<=len(rolebytes) for a,b in spans) and all(x[1]<y[0] for x,y in zip(spans,spans[1:]))
            count=lambda b:sum(b.count(op) for op in ops)
            wr.writerow([name,len(rolebytes),len(spans),sum(b-a for a,b in spans),count(rolebytes),sum(count(rolebytes[a:b]) for a,b in spans),hashlib.sha256(spanbytes).hexdigest(),hashlib.sha256((d/'unit.o').read_bytes()).hexdigest()]);f.flush()
with tempfile.TemporaryDirectory(dir=study) as tmp,(study/'typed.tsv').open('w') as f:
    d=Path(tmp);wr=csv.writer(f,delimiter='\t',lineterminator='\n')
    wr.writerow(['source','compiler','status','stdout-bytes','stdout-sha256','stderr-bytes','stderr-sha256','object-bytes','object-sha256'])
    def digest(path):
        with path.open('rb') as h: return (path.stat().st_size,hashlib.file_digest(h,'sha256').hexdigest())
    for name in ['sqlite','main']:
        args=subprocess.check_output(['bash','-c',srcargs,'_',str(w),name]).decode().strip('\x00').split('\x00')
        receipts=[]
        for ref,path in [('baseline',w/'default-integer-control/build/compiler'),('candidate',src/'build/compiler')]:
            obj=d/'unit.o';obj.unlink(missing_ok=True)
            with (d/'stdout').open('wb') as so,(d/'stderr').open('wb') as se:
                x=subprocess.run([path,'--lanes','1','--dump-typed','-c',*args,'-o',obj],stdout=so,stderr=se,timeout=90)
            receipt=[x.returncode,*digest(d/'stdout'),*digest(d/'stderr'),*digest(obj)]
            assert x.returncode==0;wr.writerow([name,ref,*receipt]);receipts.append(receipt)
        assert receipts[0]==receipts[1],name;f.flush()
