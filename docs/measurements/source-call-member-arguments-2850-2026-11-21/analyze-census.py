import os
"""Classify the failed first reader gate and the full preprocessed argument spelling."""
from pathlib import Path
from collections import Counter
import re,sys,csv
d=Path(os.environ.get("BUSTER_CASE_DIR",Path(__file__).resolve().parent)).resolve()
file=Path(sys.argv[1]) if len(sys.argv)>1 else d/'sqlite-census.txt'
src=(Path(os.environ['BUSTER_SRC'])/'src/buster/compiler/c_parser.c').read_text()
kinds=re.findall(r'X\((\w+)\)',src.split('#define BUSTER_PARSE_KINDS(X)')[1].split('typedef enum ParseKind')[0])
src=(Path(os.environ['BUSTER_SRC'])/'src/buster/compiler/c_check_input.c').read_text()
txt=src.split('    CHECK_INPUT_CODE_LIST,')[0].rsplit('typedef enum',1)[-1]
full=src[src.index(txt):]; codes=re.findall(r'^    CHECK_INPUT_CODE_(\w+)',full.split('} CheckInputCode;')[0].split('}')[0],re.M)
seen={};stat={};types={}
for line in file.open():
 ss=line.split()
 if not ss or not ss[0].startswith('args-'):continue
 key=ss[0]; nums=list(map(int,ss[1:])); close,*rest=nums
 if key=='args-census':
  opening,parent,pk,nxt,before,after,*ks=rest
  seen[close]=(opening,parent,kinds[pk] if pk<len(kinds) else None,codes[nxt] if nxt<len(codes) else str(nxt),kinds[before],kinds[after],[kinds[x] for x in ks])
 elif key=='args-type':types[close]=rest
 else:stat[close]=(key,rest[0] if rest else '')
ctr=Counter();fr=Counter();typesCount=Counter();gram=Counter()
with (d/'sqlite-rejections.tsv').open('w') as out:
 w=csv.writer(out,delimiter='\t',lineterminator='\n')
 w.writerow('close open parent parent_kind next_action callee_kind next_kind result gate kinds'.split())
 for close,(opening,parent,pk,nxt,before,after,ks) in seen.items():
  state,reason=stat.get(close,('not-attempted',''))
  ctr[(state,reason)]+=1
  w.writerow((close,opening,parent,pk,nxt,before,after,state,reason,' '.join(ks)))
  if state not in ('args-syntax','args-refusal'):continue
  if before!='IDENTIFIER' or pk not in ('RETURN','SEMI'):continue
  split=['']; level=0
  for k in ks:
   if k=='COMMA' and level==0:split.append('');continue
   split[-1]=(split[-1]+' '+k).strip()
   level+=int(k in ('L_PAREN','L_SQUARE','L_BRACE'))-int(k in ('R_PAREN','R_SQUARE','R_BRACE'))
  q=tuple(sorted(set(split)-{'','IDENTIFIER','NUMBER'}))
  fr[q]+=1
  gram[(state,q)]+=1
 for k,v in types.items():
  _,_,local,formal,fkind,actual,akind,status,av,flags,obj,decl,lit=v
  source='local-identity' if obj==decl+1 else 'other-reference'
  typesCount[(bool(local),fkind,akind,source if local else 'zero' if lit==0 else 'literal')]+=1
print('read',len(seen),'states',ctr)
print('candidate shapes for rejected direct return/discard spellings',fr.most_common(22))
print('typed first failed argument',typesCount.most_common(22))
