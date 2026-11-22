# Loaded by GDB after entry_addr, scalar_addr, and replacement have been supplied.
import gdb
pending={}
returns={}
observations=0
def reg(name):
 return int(gdb.parse_and_eval('$'+name))
def word(address):
 return int.from_bytes(bytes(gdb.selected_inferior().read_memory(address,8)),'little')
class Returned(gdb.Breakpoint):
 def stop(self):
  global observations
  key=(gdb.selected_thread().global_num,reg('rsp'))
  if key in pending:
   n,slot=pending.pop(key)
   buf=bytes(gdb.selected_inferior().read_memory(slot,48))
   values=[int.from_bytes(buf[n:n+k],'little') for n,k in [(0,4),(4,4),(8,4),(16,8),(24,8),(32,8),(40,8)]]
   gdb.write('RESERVE %d %s\n'%(n,' '.join(str(x) for x in values)))
   observations+=1
  return False
class Entry(gdb.Breakpoint):
 def stop(self):
  sp=reg('rsp');ret=word(sp);key=(gdb.selected_thread().global_num,sp+8)
  if ret not in returns:returns[ret]=Returned('*0x%x'%ret,internal=True)
  prog=reg('rsi');table=word(prog+layout[0]);atomic=vec=ext=n=0
  if table:
   n=int.from_bytes(bytes(gdb.selected_inferior().read_memory(table+layout[2],4)),'little');kind=word(table+layout[1]);codes=bytes(gdb.selected_inferior().read_memory(kind,n)) if n else b''
   atomic=codes.count(14);vec=codes.count(12);ext=codes.count(13)
  gdb.write('RESERVE_TABLE %d %d %d %d %d\n'%(observations,n,atomic,vec,ext))
  pending[key]=(observations,reg('rdi'))
  if replacement:gdb.execute('set $pc=0x%x'%scalar_addr)
  return False
Entry('*0x%x'%entry_addr,internal=True)
