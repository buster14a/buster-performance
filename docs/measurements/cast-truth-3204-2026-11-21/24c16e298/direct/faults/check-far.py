"""Run normal, poisoned and intentionally incomplete far-row writers through the full C shadow."""
from pathlib import Path
import argparse,csv,os,re,subprocess,sys
ap=argparse.ArgumentParser();ap.add_argument('compiler',type=Path);ap.add_argument('fixtures',type=Path);arg=ap.parse_args()
out=csv.writer(sys.stdout,delimiter='\t',lineterminator='\n');out.writerow(('case','mode','exit','far-operands','context-differences','row-differences'))
results={}
for p in sorted(arg.fixtures.glob('*.c')):
    for mode in ('control','poison','omit-up','omit-left'):
        env=dict(os.environ);env.pop('BUSTER_QA_FAR',None)
        if mode!='control':env['BUSTER_QA_FAR']=mode
        proc=subprocess.run([arg.compiler.resolve(),'measure-node-machine','--shadow','--window-rows','--passes','0','--list','1',p],capture_output=True,text=True,env=env)
        ctxt=re.search(r'window contexts expressions=.*? differences=(\d+).*?out-of-a-block\'s-reach=(\d+)',proc.stdout)
        rows=re.search(r'window rows expressions=.*? differences=(\d+)',proc.stdout)
        if not ctxt or not rows:raise RuntimeError((p.name,mode,proc.returncode,proc.stderr[-300:]))
        row=(proc.returncode,int(ctxt[2]),int(ctxt[1]),int(rows[1]))
        results[p.name,mode]=row
        out.writerow((p.name,mode,*row))
for name in {n for n,_ in results}:
    assert results[name,'control']==results[name,'poison'], name
    assert results[name,'control'][0]==0 and results[name,'control'][1]>0,(name,results[name,'control'])
for negative in ['omit-up','omit-left']:
    assert any(mode==negative and row[0]==1 and row[2]+row[3]>0 for (_,mode),row in results.items()),negative
