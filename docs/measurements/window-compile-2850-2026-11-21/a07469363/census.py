import struct,collections,pathlib,sys
d=pathlib.Path(__file__).parent
count=collections.Counter; rows=list(struct.iter_unpack('28I',(d/sys.argv[1]).read_bytes()))
print('all rows',len(rows))
for op in (24,32,33):
 r=[v for v in rows if v[0]==op]
 print('op',op,len(r),'discard',sum(v[23] for v in r),'directions',count((v[24],v[25]) for v in r).most_common(7))
 print('from shapes (category flags constant object offset bitwidth fault, overload)',count(v[4:12] for v in r).most_common(10))
 print('out shapes (category flags constant object offset bitwidth fault)',count(v[13:20] for v in r).most_common(6),'const-evaluated',sum(v[22] for v in r))
 print('unique (base type,member)',len(set((v[3],v[2]) for v in r)), 'elg',sum(v[6] in (0,3) and v[9:12]==(0,0,0) and v[22]==0 and v[4]==1 for v in r))
