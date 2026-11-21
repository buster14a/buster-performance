from pathlib import Path
from collections import Counter,defaultdict
import sys,struct,re,os
here=Path(__file__).resolve().parent
sys.path.insert(0,str(here))
from graph import load
rows,args,convs,_=load(sys.argv[1])
accepted={int(w) for w in re.findall(r'plain-call: token=(\d+)',Path(sys.argv[2]).read_text())}
src=(Path(os.environ['BUSTER_SRC'])/'src/buster/compiler/c_check_actions.c').read_text()
names=re.findall(r'^    CHECK_OP_(\w+),',src.split('typedef enum CheckOp\n')[1].split('} CheckOp;')[0],re.M)
counts=Counter(); frontier=Counter(); examples={}
for i,(h,v,c) in enumerate(rows):
 tok,op,child=h[:3]
 if op not in (24,36) or child>=len(rows):continue
 call=rows[child][0]
 if call[1]!=34:continue
 k='existing' if tok in accepted else 'missed'
 counts[k]+=1
 argids=args[call[5]:call[5]+call[6]]
 kinds=tuple(names[rows[child][0][1]] for child in argids)
 if k=='existing':continue
 if len(kinds)>8:counts['over 8']+=1;continue
 if rows[call[2]][0][1]!=0:counts['complex-callee']+=1;continue
 ons=tuple(sorted(set(kinds)-{'VALUE'}))
 frontier[ons]+=1
 if len(ons)==1:examples.setdefault(ons,[]).append((tok,call[0],kinds))
 for pos,child in enumerate(argids):
  v=rows[child][1]
  ty,cat,flags,ckind,num=struct.unpack_from('<4IQ',v,0);formal=struct.unpack_from('<I',convs[call[5]+pos])[0]
  if not ons and ty!=formal:counts[f'VALUE conversion {cat}/{ckind}/{flags:x} {ty if ty<512 else "user"}->{formal if formal<512 else "user"} '+('zero' if not num else 'nonzero')]+=1
print('graph shapes',counts.most_common(26));print('argument op frontier',frontier.most_common(25))
