from collections import Counter
from pathlib import Path
import struct,sys
kind_count=65
raw_identifier=1
def read(path):
    data=Path(path).read_bytes()
    offset=0
    while offset<len(data):
        kind,flags,location,value=struct.unpack_from('<BBII',data,offset)
        offset+=10
        name=b''
        if kind==raw_identifier or kind_count<=kind<252:
            name=data[offset:offset+value]
            if len(name)!=value: raise ValueError((offset,kind,value))
            offset+=value
        yield (kind,flags,location,value,name)
    assert offset==len(data)
from itertools import zip_longest
counts=Counter()
first={}
size=0
for i,(a,b) in enumerate(zip_longest(read(sys.argv[1]),read(sys.argv[2]))):
    size+=1
    if a==b:continue
    if a is None or b is None: key='row count'
    else: key=' '.join(name for x,y,name in zip(a,b,['kind','flags','location','value','name']) if x!=y)
    first.setdefault(key,(i,a,b));counts[key]+=1
print(f'{size} output rows, differences {sum(counts.values())}')
for key,n in counts.most_common():print(key,n,'first',first[key])
