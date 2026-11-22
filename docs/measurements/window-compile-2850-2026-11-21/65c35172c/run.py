from pathlib import Path
import collections,hashlib,json,os,re,shlex,subprocess
d=Path(__file__).resolve().parent;w=d.parent;src=w/'live-native-bodies'
prefix=(w/'sizeof-expression-study/source-regions.py').read_text()
exec(prefix[prefix.index('c=next('):prefix.index("ofs=offsets('CheckInput'")].replace('-fdump-record-layouts', '-fdump-record-layouts-complete'),globals())
pp=offsets('Parser',['live_native'])['live_native']
st=offsets('CheckLiveNative',['rows','count'])
fr=offsets('CheckLiveFragment',['count','references','size','instructions','ends','bytes'])
size=int(re.search(r'^\s*0 \| struct CheckLiveFragment\n.*?\[sizeof=(\d+),',layout,re.S|re.M)[1])
form=offsets('X86Instruction',['form'])['form']
srcargs=prefix.split("srcargs='''")[1].split("'''")[0].replace('\\\\0','\\0').replace('$1/pregraph-warning-study', '$1/switch-inputs/../pregraph-warning-study').replace('$1/proof-predefines.h', '$1/switch-inputs/../proof-predefines.h')
args=subprocess.check_output(['bash','-c',srcargs,'_',str(w),'sqlite']).decode().strip('\0').split('\0')
env=os.environ.copy();env.update({n:'1' for n in 'BUSTER_SOURCE_ROOT_CURSOR BUSTER_SOURCE_CONTROL_MASKS BUSTER_SOURCE_DIRTY_DIAGNOSTICS BUSTER_SOURCE_WARNING_INDEX BUSTER_SOURCE_CLOSE_CONTEXTS BUSTER_SOURCE_CLASS_CONSUMER BUSTER_SOURCE_BORROW_CHILDREN BUSTER_SOURCE_FIRST_NODE BUSTER_CONTROL_EARLY_RELEASE BUSTER_CONTROL_EARLY_NATIVE BUSTER_SOURCE_WRITE_COLUMNS BUSTER_SOURCE_FILE_DATA BUSTER_SOURCE_GROW_GRAPH BUSTER_SOURCE_RETIRE_LISTS BUSTER_CONTROL_SOURCE_NATIVE BUSTER_PARSE_LIVE_FOREST BUSTER_LIVE_CHECKED_INPUT BUSTER_PARSE_LIVE_AUDIT'.split()});env['BUSTER_PRE_EOF_NATIVE_WINDOW']='24'
result=[]
for arm in ['observe','instructions','bytes','ends']:
 g=d/(arm+'.gdb');g.write_text(f"""set pagination off
set debuginfod enabled off
set confirm off
python
import gdb
def word(addr,z):return int.from_bytes(gdb.selected_inferior().read_memory(addr,z).tobytes(),'little')
class Returned(gdb.FinishBreakpoint):
 def __init__(self,ptr):
  super().__init__(gdb.newest_frame(),internal=True)
  self.ptr=ptr
 def stop(self):
  inf=gdb.selected_inferior();rows=word(self.ptr+{st['rows']},8);count=word(self.ptr+{st['count']},4);changed=0
  for i in range(count):
   row=rows+{size}*i
   if '{arm}'=='instructions' and word(row+{fr['count']},4):addr=word(row+{fr['instructions']},8)+{form}
   elif '{arm}'=='bytes' and word(row+{fr['size']},4):addr=word(row+{fr['bytes']},8)
   elif '{arm}'=='ends' and word(row+{fr['references']},4):addr=word(row+{fr['ends']},8)
   else:continue
   inf.write_memory(addr,bytes([word(addr,1)^1]));changed+=1
  print('measured-handoff rows=%d changed=%d'%(count,changed))
  return False
class Entry(gdb.Breakpoint):
 def stop(self):
  Returned(word(int(gdb.parse_and_eval('$rdi'))+{pp},8))
  return False
Entry("*'check_driver_live_native_prefix'")
end
run
""");obj=d/(arm+'.o');obj.unlink(missing_ok=True)
 proc=subprocess.run(['gdb','-q','--batch','-x',g,'--args',src/'build/compiler','--lanes','1','-c',*args,'-o',obj],env=env,capture_output=True,timeout=160)
 log=proc.stderr+proc.stdout;(d/(arm+'.log')).write_bytes(log)
 m=re.search(rb'measured-handoff rows=(\d+) changed=(\d+)',log);assert m,log[-600:]
 rows=re.findall(rb'^pre-eof-native-consumed\t(\d+)\t',log,re.M);same=obj.exists() and obj.read_bytes()==(w/'source-typed-study/sqlite.o').read_bytes()
 result.append([arm,int(m[1]),int(m[2]),len(set(rows)),same,hashlib.sha256(obj.read_bytes()).hexdigest() if obj.exists() else 'absent'])
 (d/'interventions.tsv').write_text('arm\trows\tmodified\taccepted_unique\texact_ELF\tobject_sha256\n'+''.join('\t'.join(map(str,r))+'\n' for r in result))
 assert (same==(arm in ('observe','instructions'))) and (int(m[2])>0)==(arm!='observe') and bool(rows)==(arm!='instructions'),result[-1]
