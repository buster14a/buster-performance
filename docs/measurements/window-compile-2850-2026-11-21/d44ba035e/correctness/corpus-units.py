import sys, subprocess, re, pathlib, json
cc, out, policy, *args=sys.argv[1:]
paths=[x for x in args if x.endswith('.c')]
options=[x for x in args if not x.endswith('.c')]
if policy=='wall':options.extend(['-Wall','-Wextra'])
sums=[0]*4
warnings=failed=differ=units=0
file=pathlib.Path(out)
with file.open('w') as f:
 for name in paths:
  results=[]
  for opt in ['--node-window','--node-window-conditions']:
   p=subprocess.run([cc,opt,'--lanes','1','--time-stages','-fsyntax-only',*options,name],capture_output=True)
   report=p.stderr.partition(b'time-stage\t')[0]
   diag=b'\n'.join(x for x in report.splitlines() if not x.startswith(b'node-window'))
   results.append((p.returncode,p.stdout,diag))
  count=re.search(rb'node-window-conditions: controls=(\d+) bounded=(\d+) taken=(\d+) native-rows=(\d+)',report)
  cnt=list(map(int,count.groups())) if count else [0]*4
  sums=[a+b for a,b in zip(sums,cnt)]
  diff=results[0]!=results[1]
  warnings+=results[1][2].count(b'warning:')
  units+=1; failed+=results[1][0]!=0;differ+=int(diff)
  print(json.dumps([name,*cnt,results[1][0],int(diff)]),file=f)
  if diff:
   for i,row in enumerate(results): file.with_name(file.stem+'-'+str(units)+'-'+str(i)+'.log').write_bytes(row[1]+row[2])
print(policy,units,sums,'rejected',failed,'warnings',warnings,'differences',differ,file=sys.stdout,flush=True)
sys.exit(differ>0)
