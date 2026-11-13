# probe-report.py FILE...: each probe file's phases, ticks per token of the units
import sys
names={0:'count_tokens',19:'..sparse reserve',21:'..graph',22:'sparse arena',23:'bindings init',1:'..clears',2:'clears+none',3:'tree columns',4:'commas..pragmas',5:'intrinsic',6:'overload/system/attr/starts',7:'walk',8:'controls..',9:'bindings',17:'..region+sizeof',18:'expressions',10:'..events',11:'events',12:'publish..end'}
order=[0,19,21,22,23,1,2,3,4,5,6,7,8,9,17,18,10,11,12]
files=sys.argv[1:]
data=[]
for f in files:
    t=open(f).read().split()[1:]
    data.append({t[i]:int(t[i+1]) for i in range(0,len(t),2)})
print('%-28s'%'phase'+''.join('%12s'%f.split('/')[-1][:11] for f in files))
for k in order:
    print('%-28s'%names[k]+''.join('%12.1f'%(d.get('p%d'%k,0)/d['tokens']) for d in data))
print('%-28s'%'all'+''.join('%12.1f'%(sum(d.get('p%d'%k,0) for k in order)/d['tokens']) for d in data))
