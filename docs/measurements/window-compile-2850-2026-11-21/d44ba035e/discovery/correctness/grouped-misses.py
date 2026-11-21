from pathlib import Path
import struct,sys,re,subprocess
s=Path(sys.argv[1]).resolve()
def read(name):return {t for t,*_ in struct.iter_unpack('<III96s',(s/f'values-{name}.bin').read_bytes())}
missing=read('original')-read('plain'); assert len(missing)==15,len(missing)
wanted={n for m in missing for n in range(m-16,m+17)}
stream=subprocess.Popen(sys.argv[2:],stdout=subprocess.PIPE,text=True); tokens={}
for line in stream.stdout:
 match=re.match(r'^\s*(\d+)\s+\d+\s+(.+?)\s+(\w+)\s+\|\s+(\w+)\s+\d+\s+-?\d+\s*$',line)
 if match and int(match[1]) in wanted:tokens[int(match[1])]=(match[2].strip(),match[3],match[4])
assert stream.wait()==0 and missing<=set(tokens)
with (s/'declined-grouped.tsv').open('w') as f:
 print('comparison_token\toperator\topen_to_close',file=f)
 for m in sorted(missing):
  assert tokens[m][2] in ('RELATIONAL','EQUALITY'),(m,tokens[m])
  first=m
  while first>m-16 and tokens[first][2]!='OPEN_CONDITION':first-=1
  last=m
  while last<m+16 and tokens[last][2]!='CLOSE_CONDITION':last+=1
  assert tokens[first][2]=='OPEN_CONDITION' and tokens[last][2]=='CLOSE_CONDITION'
  spell=' '.join(tokens[n][0] for n in range(first,last+1))
  assert any(tokens[n][2]=='OPEN_GROUP' for n in range(first+1,last)),(m,spell)
  print(m,tokens[m][0],spell,sep='\t',file=f)
