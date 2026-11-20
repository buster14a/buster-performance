"""Read ELF64 tables and independently resolve each x87 load's signed PC32 relocation."""
from pathlib import Path
import csv,hashlib,itertools,os,struct,subprocess
p=Path(__file__).resolve().parent;w=p.parent;d=p/'elf';d.mkdir(exist_ok=True);cc='/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang'
def table(f):return list(csv.DictReader(f.open(),delimiter='\t'))
def write(f,h,rows):
 with f.open('w') as fh:
  t=csv.writer(fh,delimiter='\t',lineterminator='\n');t.writerow(h);t.writerows(rows)
def h(f):return hashlib.file_digest(f.open('rb'),'sha256').hexdigest()
def run(*args,**kw):return subprocess.run(list(map(str,args)),check=True,**kw)
def string(pool,i):return pool[i:pool.index(0,i)].decode()
class Elf:
 def __init__(self,path):
  b=path.read_bytes();self.data=b;assert b[:6]==b'\x7fELF\x02\x01'
  start=struct.unpack_from('<Q',b,40)[0];stride,n,strings=struct.unpack_from('<HHH',b,58)
  self.sections=[struct.unpack_from('<IIQQQQIIQQ',b,start+stride*i) for i in range(n)]
  names=self.bytes(self.sections[strings]);self.byname={string(names,s[0]):s for s in self.sections}
  sym=self.byname.get('.symtab',None);self.syms=[];self.relocs=[]
  if sym:
   names=self.bytes(self.sections[sym[6]])
   for j in range(sym[4],sym[4]+sym[5],sym[9]):
    name,info,unused,sec,pos,size=struct.unpack_from('<IBBHQQ',b,j);self.syms.append((string(names,name),info&15,sec,pos,size))
  for sec in self.sections:
   if sec[1]==4 and self.sections[sec[7]][2]&4 and self.sections[sec[6]]==sym:
    for pos,info,add in struct.iter_unpack('<QQq',self.bytes(sec)):
     self.relocs.append((sec[7],pos,info&0xffffffff,self.syms[info>>32],add))
 def bytes(self,s):return self.data[s[4]:s[4]+s[5]]
 def totals(self):
  return [len(self.data),sum(s[5] for n,s in self.byname.items() if s[2]&4),sum(s[5] for n,s in self.byname.items() if n.startswith('.rodata')),sum(s[5] for s in self.sections if s[1] in (4,9)),len(self.relocs)]
def payload(row):
 lo=int(row['extended_significand'],16);hi=int(row['extended_sign_exponent'],16);wide=lo.to_bytes(8,'little')+hi.to_bytes(2,'little')
 if row['eligible_binary32']=='0' and row['eligible_binary64']=='0':return bytes([219,45]),wide+bytes(6)
 import math
 if lo==0:value=-0.0 if hi>>15 else 0.0
 else:value=math.ldexp(float(lo),int(hi&32767)-16383-63)*(-1 if hi>>15 else 1)
 if row['eligible_binary32']=='1':return bytes([217,5]),struct.pack('<f',value)+bytes(12)
 return bytes([221,5]),struct.pack('<d',value)+bytes(8)

constants=table(p/'operands/constants.tsv')
also=b'\x01'+b'\0'*6+b'\x80\xff\x3f'+bytes(6)
if __name__=='__main__':
 checks=[];programs=[]
 for arch,mode,pic in itertools.product(['x86-64','znver5'],['default','post'],['plain','debug']):
  tag=f'{arch}-{mode}-{pic}';obj=d/(tag+'.o')
  flags=['--tier1','--tier1-strict','--verify','--lanes','1','-O2','-march='+arch]+(['--tier1-schedule=post'] if mode=='post' else [])+(['-g'] if pic=='debug' else [])
  run(w/'x87-double/build/compiler',*flags,'-c',p/'operands/leaves.c','-o',obj,capture_output=True)
  elf=Elf(obj);pool=elf.byname['.rodata.cst16'];assert pool[2]&18==18 and pool[8]==pool[9]==16
  actual={elf.bytes(pool)[i:i+16] for i in range(0,pool[5],16)};wanted={payload(row)[1] for row in constants}|{also};assert actual==wanted and 16*len(wanted)==pool[5],(tag,len(actual),len(wanted))
  by={name:(sec,pos,sz) for name,kind,sec,pos,sz in elf.syms if kind==2};refs=sorted((sec,pos,typ,target,add) for sec,pos,typ,target,add in elf.relocs if target[0].startswith('.Lbuster_literal'))
  used=0
  for row in constants:
   k=int(row['case']);op,bits=payload(row)
   for fn in ('get','put','arg','plus','minus','less','choose'):
    name=f'{fn}_{k}';sec,start,size=by[name];found=[];offsets=[];data=elf.bytes(elf.sections[sec])
    for section,pos,typ,tgt,add in refs:
     if section==sec and start<=pos<start+size:
      tsec=elf.sections[tgt[2]];assert tsec==pool and typ==2 and add==-4 and data[pos:pos+4]==bytes(4)
      value=elf.bytes(pool)[tgt[3]:tgt[3]+16];assert tgt[3]%16==0
      instr=data[pos-2:pos];assert instr==(op if value==bits else b'\xdb\x2d'),(tag,name,pos,instr,value.hex())
      found.append(value);offsets.append(pos-start)
    expect={bits} if fn!='choose' else {bits,also};assert set(found)==expect,(tag,name,[q.hex() for q in found],[q.hex() for q in expect])
    checks.append([tag,name,size,','.join(map(str,offsets)),','.join(z.hex() for z in found)]);used+=len(found)
  assert used==len(refs)
  main=p/'operands/out/driver.o';gold=p/'operands/out/parent-znver5-default.data'
  for ld,kind in itertools.product(['bfd','lld'],['pie','fixed','symbolic-shared']):
   prefix=tag+'-'+ld+'-'+kind;exe=d/prefix;out=d/(prefix+'.data')
   if kind.endswith('shared'):
    lib=d/(prefix+'.so');run(cc,'-fuse-ld='+ld,'-shared',*(['-Wl,-Bsymbolic'] if kind.startswith('symbolic') else []),'-Wl,-soname,'+lib.name,obj,'-o',lib)
    run(cc,'-fuse-ld='+ld,'-Wl,--gc-sections,-E','-Wl,-rpath,$ORIGIN',main,lib,'-o',exe)
   else:run(cc,'-fuse-ld='+ld,'-no-pie' if kind=='fixed' else '-pie','-Wl,--gc-sections',main,obj,'-o',exe)
   run(exe,out,capture_output=True,timeout=90);assert h(out)==h(gold);programs.append([tag,ld,kind,h(obj),h(exe),h(out),out.stat().st_size//11,len(actual),len(refs)])
  print(tag,len(actual),len(refs),flush=True)
 write(d/'relocated-loads.tsv',['configuration','function','function_bytes','displacement_offsets','referent_bytes'],checks)
 write(d/'linked.tsv',['configuration','linker','kind','object_sha256','executable_sha256','observations_sha256','checks','unique_literals','literal_relocations'],programs)
