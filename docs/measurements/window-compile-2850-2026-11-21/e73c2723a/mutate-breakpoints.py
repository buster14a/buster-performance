import gdb
def load(addr,n):return int.from_bytes(bytes(gdb.selected_inferior().read_memory(addr,n)),'little')
def put(addr,val):gdb.selected_inferior().write_memory(addr,int(val).to_bytes(4,'little'))
def reg(s):return int(gdb.parse_and_eval('$'+s))
class Ret(gdb.Breakpoint):
 def stop(self):
  if perturb:put(slot,old)
  for addr,value in saved:put(addr,value)
  values=[load(sret+n,w) for n,w in [(0,4),(4,4),(8,4),(16,8),(24,8),(32,8),(40,8)]]
  gdb.write('CAPACITY '+' '.join(str(i) for i in values)+'\n');self.enabled=False;return False
hits=0
class Entry(gdb.Breakpoint):
 def stop(self):
  global hits,slot,old,sret,saved
  prog=reg('rsi');sret=reg('rdi');graph=load(prog+cfg['CheckProgram.input'],8)+cfg['CheckInput.graph'];stream=load(prog+cfg['CheckProgram.stream'],8);types=load(prog+cfg['CheckProgram.types'],8);count=load(graph+cfg['CheckGraph.count'],4);ops=load(graph+cfg['CheckGraph.ops'],8)
  op=cfg['add'] if which=='conversion' else cfg['subscript'];nodes=[i for i in range(count) if load(ops+4*i,4)==op];assert len(nodes)==1,nodes;node=nodes[0]
  saved=[]
  if which=='left-isolated':
   conv=load(stream+cfg['CheckStream.conversions'],8)+cfg['stride']*node
   for offset in (0,cfg['conversion_size']):
    a=conv+offset;oldvalue=load(a,4);saved.append((a,oldvalue));put(a,0)
   gdb.write('ISOLATED checked subscript conversion types %d %d\n'%(saved[0][1],saved[1][1]))
  if which=='conversion':
   k=load(types+cfg['TypeColumns.kind'],8);sz=load(types+cfg['TypeColumns.size'],8);n=load(types+cfg['TypeColumns.count'],4);wid=next(i for i in range(n) if load(k+i,1) in (12,13) and load(sz+8*i,8)==128);new=wid<<3;slot=load(stream+cfg['CheckStream.conversions'],8)+cfg['stride']*node
  else:
   slot=load(graph+cfg['CheckGraph.operand0'],8)+4*node;new=0xffffffff
  old=load(slot,4);hits+=1;gdb.write('INPUT node=%d old=%d proposed=%d changed=%d\n'%(node,old,new,perturb))
  if perturb:put(slot,new)
  Ret('*0x%x'%load(reg('rsp'),8),internal=True)
  if scalar:gdb.execute('set $pc=0x%x'%cfg['scalar'])
  return False
Entry('*0x%x'%cfg['entry'],internal=True)
