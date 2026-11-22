import struct, pathlib, collections, sys
for name in ['sqlite','main']:
 rows=struct.iter_unpack('28I',pathlib.Path(__file__).with_name(name+'.rows').read_bytes()); slots={k:[None]*k for k in (256,1024,4096,8192)};hits=collections.Counter();eligible=0
 for r in rows:
  op,_,m,t,cat,flags,ck=r[:7]
  if op not in (32,33) or cat!=1 or flags!=8388608 or ck not in ((0,3) if op==33 else (0,)) or any(r[8:12]) or r[22]: continue
  key=(op,m,t);eligible+=1
  for k,table in slots.items():
   j=((m*0x85ebca6b+t*0x9e3779b9)&0xffffffff)>>(32-(k.bit_length()-1))
   if table[j]==key: hits[k]+=1
   table[j]=key
 print(name,eligible,hits)
