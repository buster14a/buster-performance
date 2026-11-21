from pathlib import Path
from statistics import median
from sys import argv
import re
b,a,suf=argv[1:4]
rounds=int(argv[4]) if len(argv)>4 else 7
first=re.compile(r'^node-shadow: window contexts ticks=[^\n]*?: the loop=(\d+)',re.M)
second=re.compile(r'^node-shadow: window contexts a second run over the same chunk, not counted: ticks=[^\n]*?: the loop=(\d+)',re.M)
swept=re.compile(r'^node-shadow: window contexts expressions=.*?records-swept=(\d+)',re.M)
rows=re.compile(r'^node-shadow: window rows expressions=.*?records-swept=(\d+)',re.M)
for corpus in ['sqlite3','lua','musl']:
    diffs=[[] for _ in range(2)]; control=[[] for _ in range(2)]
    for n in range(1,rounds+1):
        sides=[]
        for directory,tag in [(b,'before'),(a,'after')]:
            pair=[]
            for i in [1,2]:
                text=(Path(directory)/f'{tag}{i}-{corpus}{suf}-{n}.txt').read_text()
                assert len(re.findall('^status 0$',text,re.M))==1
                assert not re.search(r'(?:differences|that-differ|failures)=[1-9]',text)
                denom=int(swept.search(text)[1]); assert denom==int(rows.search(text)[1])
                pair.append([int(pat.search(text)[1])/denom for pat in [first,second]])
            sides.append(pair)
        for j in [0,1]:
            diffs[j].append(sum(r[j] for r in sides[1])/2-sum(r[j] for r in sides[0])/2)
            control[j].append(sides[0][1][j]-sides[0][0][j])
    def stat(nums):return [round(x,5) for x in (median(nums),min(nums),max(nums))]
    print(corpus,'initial',stat(diffs[0]),'repeat',stat(diffs[1]),'control A2-A1',stat(control[0]),stat(control[1]),'denom',denom)
