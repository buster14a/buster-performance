from pathlib import Path
from collections import Counter
import runpy,sys
sys.argv=[sys.argv[0],sys.argv[1],"/dev/null"]
d=runpy.run_path(str(Path(__file__).with_name('analyze-shapes.py')))
Root,Tag=d['Root'],d['Tag']
t=Counter();n=Counter();typ=Counter();kind=Counter();root=None;ns={}
def count(r,ns):
    if not r:return
    assn=ns[r.assn]; lhs=ns.get(assn.left);rhs=ns.get(assn.right)
    if assn.op!='=' or not lhs or lhs.op!='->' or not rhs or rhs.op!='value' or rhs.constant!=1 or rhs.type!=64 or lhs.kind!=2:return
    b=ns.get(lhs.left);t['all']+=1
    if not b or b.storage!=1:return
    t['local pointer']+=1;typ[lhs.type]+=1
    tight=(b.token,lhs.token,assn.token,rhs.token)==(r.semi-5,r.semi-4,r.semi-2,r.semi-1)
    if tight:
        t['consecutive']+=1
        n[r.parentrole]+=1;kind[rhs.role]+=1
    if tight and not r.warning and not r.mismatch and all(i.exact for i in ns.values()) and not (lhs.flags&4) and not (lhs.type&7):
        t['consecutive, unqualified no-bitfield checked-exact']+=1
    if tight and (lhs.offset&7)==0:t['consecutive + byte offset']+=1
for l in Path(sys.argv[1]).open():
    w=l.rstrip().split('\t')
    if w[0]=='assignment-shape':
        count(root,ns);root=Root(*map(int,w[1:]));ns={}
    elif w[0]=='assignment-node':
        x=Tag(int(w[2]),int(w[3]),w[4],*map(int,w[5:]));ns[x.node]=x
count(root,ns)
print('field-literal candidates',dict(t),'target types',typ,'immediate block role',n,'rhs token kind',kind)
