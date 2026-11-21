"""Classify complete direct CallExpr roots by the callee and the ordinary AST of each argument."""
import collections,re,sys
from pathlib import Path
linepat=re.compile(r'^([\x20|\x60-]*)([A-Z][A-Za-z0-9_]*)\s')
refpat=re.compile(r" (Function|ParmVar|Var|EnumConstant) (0x[0-9a-f]+) '([^']+)' '([^']+)'")
declpat=re.compile(r'^VarDecl (0x[0-9a-f]+)')
tree=[];call=None;counts=collections.Counter();names=collections.Counter()
def last():
 global call
 if call:
  fields=call['fields']
  if fields and fields[0]==['function'] and call['function']:
   name,proto=call['function']
   arity=len(fields)-1;args=tuple(','.join(x) for x in fields[1:]);result=proto.split(' (',1)[0]
   counts[(call['parent'],result,arity,'ALL')]+=1
   counts[(call['parent'],result,arity,'ARGS='+'/'.join(args))]+=1
   if all(x.startswith(('param','local','literal')) for x in args):names[(call['parent'],result,arity,name)]+=1
 call=None
variables={}
for line in sys.stdin:
 m=linepat.match(line)
 if not m:continue
 depth=len(m[1])//2;kind=m[2];tail=line[m.start(2):].rstrip()
 if call and depth<=call['depth']:last()
 if len(tree)>depth: del tree[depth:]
 parent=tree[-1] if tree else ''
 tree.append(kind)
 if kind=='VarDecl':
  v=declpat.match(tail)
  if v:variables[v[1]]=('local' if 'FunctionDecl' in tree and not re.search(r'\b(static|extern)\b',tail) else 'global')
 if kind=='CallExpr' and parent in ('CompoundStmt','ReturnStmt'):
  call={'depth':depth,'parent':parent,'fields':[],'function':None}
 elif call:
  fields=call['fields']
  if depth==call['depth']+1:fields.append([])
  if not fields:continue
  f=fields[-1]
  if kind in ('ImplicitCastExpr','ParenExpr'):continue
  if kind=='DeclRefExpr':
   ref=refpat.search(tail)
   if ref:
    k,ID,name,ty=ref.groups()
    if k=='Function':
     f.append('function')
     if len(fields)==1 and len(f)==1:call['function']=(name,ty)
    elif k=='ParmVar':f.append('param')
    elif k=='Var':f.append(variables.get(ID,'unknown'))
    else:f.append('enum')
   else:f.append('other-ref')
  elif kind=='IntegerLiteral':f.append('literal')
  elif len(f)<4:f.append(kind)
last()
p=Path(sys.argv[1])
for path, counter in [(p,counts),(Path(str(p)+'.names'),names)]:
 with path.open('w') as o:
  for k,v in counter.most_common():print(v,*k,sep='\t',file=o)
