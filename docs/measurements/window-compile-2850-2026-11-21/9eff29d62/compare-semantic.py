from pathlib import Path
import csv,hashlib,json,os,re,shlex,subprocess,tempfile
d=Path(__file__).resolve().parent;w=d.parent;src=w/'live-native-references'
prefix=(w/'sizeof-expression-study/source-regions.py').read_text()
exec(prefix[prefix.index('c=next('):prefix.index("ofs=offsets('CheckInput'")].replace('-fdump-record-layouts','-fdump-record-layouts-complete'),globals())
reader_names={'ignored':1,'initializers':1,'initializer_declarations':4,'selected_tokens':4,'definition_origins':4,'query_types':4,'expression_commas':1,'conditions':1,'constant_contexts':1,'syntax':1,'visits':1}
unit_names={'declarations':4,'declared_types':4,'declaration_kinds':1,'objects':4,'declaration_bits':1,'function_flags':1,'explicit_abis':1,'token_nodes':4,'constant_warnings':1,'constant_warning_ignored':1,'expression_regions':4,'asm_ids':4}
sparse_names='initializer_nodes initializer_begins initializer_ends evaluation_nodes body_declarations declaration_bodies parameters parameter_next control_owners label_targets case_ranges string_ids'.split()
outptr=offsets('CheckInputReader',['output'])['output'];nptr=offsets('CheckInput',['token_count'])['token_count']
fs=[(r,n,z,off) for r,l,typ in [('reader',reader_names,'CheckInputReader'),('output',unit_names,'CheckInput')] for n,off in offsets(typ,l).items() for z in [l[n]]]
sparse=offsets('CheckInput',sparse_names)
srcargs=prefix.split("srcargs='''")[1].split("'''")[0].replace('\\\\0','\\0').replace('$1/pregraph-warning-study','$1/switch-inputs/../pregraph-warning-study').replace('$1/proof-predefines.h','$1/switch-inputs/../proof-predefines.h')
env=os.environ.copy();env.update({n:'1' for n in 'BUSTER_SOURCE_ROOT_CURSOR BUSTER_SOURCE_CONTROL_MASKS BUSTER_SOURCE_DIRTY_DIAGNOSTICS BUSTER_SOURCE_WARNING_INDEX BUSTER_SOURCE_CLOSE_CONTEXTS BUSTER_SOURCE_CLASS_CONSUMER BUSTER_SOURCE_BORROW_CHILDREN BUSTER_SOURCE_FIRST_NODE BUSTER_CONTROL_EARLY_RELEASE BUSTER_CONTROL_EARLY_NATIVE BUSTER_SOURCE_WRITE_COLUMNS BUSTER_SOURCE_FILE_DATA BUSTER_SOURCE_GROW_GRAPH BUSTER_SOURCE_RETIRE_LISTS BUSTER_CONTROL_SOURCE_NATIVE BUSTER_PARSE_LIVE_FOREST BUSTER_LIVE_CHECKED_INPUT BUSTER_PARSE_LIVE_AUDIT BUSTER_LIVE_RESOLVE_WINDOWS'.split()});env['BUSTER_PRE_EOF_NATIVE_WINDOW']='24'
for u,cut in [('sqlite',401852),('main',955032)]:
 with tempfile.TemporaryDirectory(dir=d) as tmp:
  t=Path(tmp)
  args=subprocess.check_output(['bash','-c',srcargs,'_',str(w),u]).decode().strip('\0').split('\0')
  g=t/'observe.gdb';g.write_text(f"""set pagination off
set debuginfod enabled off
set confirm off
python
import gdb,struct
fields={fs!r}
sparse={sparse!r}
cut={cut}
seen=set()
def read(a,n):return gdb.selected_inferior().read_memory(a,n).tobytes()
def word(a,n):return int.from_bytes(read(a,n),'little')
def dump(phase,reader,out):
 if phase in seen:return
 seen.add(phase)
 def save(n,data):
  with open('{t}/'+phase+'-'+n,'wb') as f:f.write(data)
 for side,n,z,off in fields:
  ptr=word((reader if side=='reader' else out)+off,8)
  if ptr:save(n,read(ptr,cut*z))
 for n,off in sparse.items():
  directory=word(out+off,8);base=word(out+off+8,8)
  if not directory:continue
  groups=(cut+15)//16
  idx=struct.unpack('<%dI'%groups,read(directory,groups*4))
  pool=read(base,64*(max(idx)+1))
  save(n,b''.join(pool[i*64:i*64+64] for i in idx)[:cut*4])
class Observe(gdb.Breakpoint):
 def stop(self):
  r=int(gdb.parse_and_eval('$rdi'));out=word(r+{outptr},8);cnt=word(out+{nptr},4)
  if 'controls' in self.location:
   if cnt==cut:dump('prefix',r,out)
   elif cnt>cut:dump('final',r,out)
  elif cnt>cut and int(gdb.parse_and_eval('$esi'))==cut:dump('resumed',r,out)
  return False
Observe("*'check_input_controls.buster_split'");Observe("*'check_input_resolve_window.buster_split'")
end
run
""")
  proc=subprocess.run(['gdb','--batch','-q','-x',g,'--args',src/'build/compiler','--lanes','1','-c',*args,'-o',t/'unit.o'],env=env,capture_output=True,timeout=200);(d/(u+'.log')).write_bytes(proc.stdout+proc.stderr)
  assert (t/'unit.o').read_bytes()==(w/'source-typed-study'/(u+'.o')).read_bytes()
  with (d/(u+'.tsv')).open('w') as out:
   wr=csv.writer(out,delimiter='\t');wr.writerow(['column','stage','rows','width','different','first_difference','prefix_sha256','late_sha256'])
   for n,z in (reader_names|unit_names|dict.fromkeys(sparse_names,4)).items():
    early=t/('prefix-'+n)
    if not early.exists():continue
    data=early.read_bytes()
    for mode in ['resumed','final']:
     cur=t/(mode+'-'+n)
     if not cur.exists():continue
     late=cur.read_bytes();assert len(data)==len(late)==z*cut
     diffs=0;first=-1
     if data!=late:
      a=memoryview(data).cast({1:'B',4:'I'}[z]);b=memoryview(late).cast({1:'B',4:'I'}[z])
      for i,(x,y) in enumerate(zip(a,b)):
       if x!=y:diffs+=1;first=i if first<0 else first
     wr.writerow([n,mode,cut,z,diffs,first,hashlib.sha256(data).hexdigest(),hashlib.sha256(late).hexdigest()])
  assert sum(row['stage']=='resumed' for row in csv.DictReader((d/(u+'.tsv')).open(),delimiter='\t'))>=25
