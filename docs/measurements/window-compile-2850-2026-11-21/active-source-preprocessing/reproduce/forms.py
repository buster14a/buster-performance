from array import array
from collections import Counter
from pathlib import Path
import re,json
d=Path(__file__).resolve().parent
src=(d.parent/'switch-inputs/sqlite/sqlite3.c').read_bytes();t=d/'target'
raw=(t/'primary.raw').read_bytes();out=(t/'output.rows').read_bytes()
nr=len(raw)//9;no=len(out)//10
def words(b):
 a=array('I');a.frombytes(b);return a
kind=raw[:nr];start=words(raw[nr:5*nr]);val=words(raw[5*nr:])
base=int(re.search(r'base (\d+)',(t/'census.err').read_text())[1]);loc=words(out[2*no:6*no]);flags=out[no:no*2]
active={v-base for v,f in zip(loc,flags) if not f&8 and base<=v<base+len(src)}
regex=re.compile(rb'[$a-zA-Z_][$a-zA-Z_0-9]*')
allforms=Counter();directforms=Counter();names=Counter();numbers=Counter()
for k,s,v in zip(kind,start,val):
 k&=127
 if k==1:
  # The frozen primary names are all plain ASCII except spliced tokens; canonical IDs
  # remain the key even if their physical source has more than the displayed prefix.
  key=(k,v)
 else:
  key=(k,src[s:v])
 allforms[key]+=1
 if s in active:
  directforms[key]+=1
  if k==1 and v not in names:
   match=regex.match(src,s);names[v]=match[0].decode() if match else '?'
def show(key):
 k,v=key
 if k==1:return names.get(v,'<name>')
 return v.decode('utf-8',errors='replace')[:65]
def describe(cnt):
 return {'rows':sum(cnt.values()),'distinct_lexical_forms':len(cnt),'repeated_occurrences_after_first':sum(cnt.values())-len(cnt)}
print(json.dumps({'primary':describe(allforms),'active_direct':describe(directforms),'active_top_forms':[[k,show(i),v] for i,v in directforms.most_common(32) for k in [i[0]]],
 'active_top_names':[[names[v],n] for (k,v),n in sorted(((i,n) for i,n in directforms.items() if i[0]==1),key=lambda x:-x[1])[:32]]},indent=2))
