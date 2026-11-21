set debuginfod enabled off
set pagination off
set confirm off
set inferior-tty /dev/null
python
import gdb,os,hashlib
def address(name):
 for suffix in ['', '.buster_split']:
  try: return int(gdb.parse_and_eval("&'"+name+suffix+"'"))
  except gdb.error: pass
 raise RuntimeError("No symbol "+name)
class Settings(gdb.Breakpoint):
 def stop(self):
  gdb.execute('set $r8d = '+os.environ['SIX_MODE'])
  return False
class Capture(gdb.FinishBreakpoint):
 def __init__(self,output):
  super().__init__(gdb.newest_frame(),internal=True);self.output=output;self.silent=True
 def stop(self):
  assert int(gdb.parse_and_eval('$al'))!=0
  typ=gdb.lookup_type('CheckProgramLowered').pointer()
  lowered=gdb.Value(self.output).cast(typ).dereference()
  count=int(lowered['count']); funcs=lowered['functions'];tokens=lowered['entry_tokens']
  assert count and int(tokens)
  read=gdb.selected_inferior().read_memory
  with open(os.environ['SIX_NATIVE_OUT'],'w') as out:
   for i in range(count):
    f=funcs[i];n=int(f['count']);digest=hashlib.sha256()
    if n:
     for a,w in [(f['kinds'],1),(f['classes'],1),(f['values'],8),(tokens[i],4)]:
      digest.update(bytes(read(int(a),n*w)))
    print(i,n,digest.hexdigest(),file=out)
  gdb.execute('quit')
  return False
class Sourced(gdb.Breakpoint):
 def stop(self):
  Capture(int(gdb.parse_and_eval('$rdi')))
  gdb.execute('set $rdx = 1')
  gdb.execute('set $pc = '+str(address('check_program_lower_sources')))
  return False
op=Settings('*'+str(address('lower_source_open')),internal=True)
call=Sourced('*'+str(address('check_program_lower_owners')),internal=True)
end
run
