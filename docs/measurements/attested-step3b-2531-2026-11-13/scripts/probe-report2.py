# probe-report2.py DIR NAME...: each probe file's reader phases and attested passes, TSC ticks per token of the units.
import sys
S=sys.argv[1]
names={26:'clears: names',27:'clears: tags, builtins',28:'typo..builtin capacity',0:'count_tokens',19:'..sparse reserve',21:'..graph',22:'sparse arena',23:'bindings init',1:'..alloc to clears',24:'clears',2:'none fills',3:'tree columns',4:'commas..pragmas',5:'intrinsic',6:'overload/system/attr/starts',7:'walk',8:'controls..',9:'bindings',17:'..region+sizeof',18:'expressions',10:'..events',11:'events',12:'publish..',13:'..end (probe print)',25:'release'}
order=[0,19,21,22,23,1,24,26,27,2,3,4,5,6,7,8,9,28,17,18,10,11,12,13,25]
an={5:'unit arrays',6:'ids',7:'levels',0:'lists (+hashes)',1:'hashes',2:'literals',3:'chain',4:'reach+marks'}
aorder=[5,6,7,0,1,2,3,4]
files=sys.argv[2:]
data=[]
for f in files:
    t=open(S+'/probe-'+f+'.txt').read().split()[1:]
    data.append({t[i]:int(t[i+1]) for i in range(0,len(t),2)})
print('%-28s'%'TSC ticks per token'+''.join('%11s'%f[:10] for f in files))
for k in order:
    print('%-28s'%names[k]+''.join('%11.2f'%(d.get('p%d'%k,0)/d['tokens']) for d in data))
print('%-28s'%'reader (less the print)'+''.join('%11.2f'%(sum(d.get('p%d'%k,0) for k in order if k!=13)/d['tokens']) for d in data))
for k in aorder:
    print('%-28s'%('pass: '+an[k])+''.join('%11.2f'%(d.get('a%d'%k,0)/d['tokens']) for d in data))
print('%-28s'%'passes all'+''.join('%11.2f'%(sum(d.get('a%d'%k,0) for k in aorder)/d['tokens']) for d in data))
