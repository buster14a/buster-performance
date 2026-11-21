from collections import Counter
from pathlib import Path
import sys,re
linepat=re.compile(r'^([ |\x60-]*)([A-Z]\w*)\s')
refpat=re.compile(r" (Function|ParmVar|Var) (0x[0-9a-f]+) '([^']+)' '([^']+)'")
tree=[];local={};call=None;shapes=Counter();frequent=Counter()
def finish():
 global call
 if call and len(call['arg'])==2:
  callee,arg=call['arg']
  if callee.get('ref',('',''))[0]=='Function' and callee.get('extra',0)==0 and callee['casts']==['FunctionToPointerDecay'] and arg.get('extra',0)==0 and 'ref' in arg:
   kind,id_,name,ty=arg['ref'];origin='parm' if kind=='ParmVar' else 'local' if kind=='Var' and local.get(id_) else 'other'; target=callee['ref'][2]; proto=callee['ref'][3]
   if origin!='other' and proto.startswith('void ('):
    casts=tuple(arg['casts']); target_formal=proto[6:-1].strip(); pointer='*' in ty; simple=pointer and '(*' not in ty and re.search(r'\b(volatile|_Atomic|__attribute__|restrict)\b',ty) is None
    cat='simple-identity-ptr' if simple and casts==('LValueToRValue',) else 'other-ptr' if pointer else 'other'
    shapes[origin,cat,','.join(casts)]+=1;frequent[cat,target,target_formal,ty]+=1
 call=None
for line in sys.stdin:
 m=linepat.match(line)
 if not m:continue
 dep=len(m[1])//2;kind=m[2]; tail=line[m.start(2):].strip()
 if call and dep<=call['depth']:finish()
 if len(tree)>dep: del tree[dep:]
 parent=tree[-1] if tree else '';tree.append(kind)
 if kind=='VarDecl':
  x=re.match(r'VarDecl (0x[0-9a-f]+)',tail)
  if x: local[x[1]]= 'FunctionDecl' in tree and not re.search(r'\b(static|extern)\b',tail)
 if kind=='CallExpr' and parent=='CompoundStmt' and re.search("'void'(?::'void')?(?:$| )",tail):
  call={'depth':dep,'arg':[]}
 elif call:
  if dep==call['depth']+1: call['arg'].append({'casts':[]})
  if not call['arg']:continue
  f=call['arg'][-1]
  if kind=='ImplicitCastExpr':
   x=re.search(r'<([A-Za-z]\w+)>',tail)
   if x:f['casts'].append(x[1])
  elif kind=='DeclRefExpr':
   x=refpat.search(tail)
   if x and 'ref' not in f:f['ref']=x.groups()
   else:f['extra']=1
  elif kind!='ParenExpr':f['extra']=1
finish()
p=Path(sys.argv[1])
for file,rows in ((p,shapes),(Path(str(p)+'.names'),frequent)):
 with file.open('w') as f:
  for keys,count in rows.most_common(): print(count,*keys,sep='\t',file=f)
