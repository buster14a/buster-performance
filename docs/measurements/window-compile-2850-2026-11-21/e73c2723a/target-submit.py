from pathlib import Path
import json,shlex,subprocess,time
d=Path(__file__).resolve().parent;meta=json.loads((d/'identity.json').read_text());repo=meta['repository'];head=meta['candidate'];pr=meta['pull_request'];rd=f'/home/david/buster-fast-bench/2850-typed-reserve-{head[:9]}'
def gh(path):
 for attempt in range(4):
  q=subprocess.run(['gh','api',path],capture_output=True,text=True)
  if q.returncode==0:return json.loads(q.stdout)
  if attempt<3:time.sleep(10)
 raise RuntimeError(q.stderr)
while True:
 p=gh(f'repos/{repo}/pulls/{pr}');assert p['head']['sha']==head,p['head']['sha']
 rows=gh(f'repos/{repo}/commits/{head}/check-runs?per_page=100')['check_runs']
 gates=[r for r in rows if r['name']=='Integration qualification'];fail=[r['name'] for r in rows if r['conclusion']=='failure']
 if fail:raise RuntimeError(fail)
 if any(r['status']=='completed' and r['conclusion']=='success' for r in gates):break
 time.sleep(30)
(d/'target-admission.json').write_text(json.dumps({'revision':head,'accepted-at':time.strftime('%FT%TZ',time.gmtime()),'gate':[{k:r[k] for k in ['id','name','status','conclusion','html_url','completed_at']} for r in gates],'measurement-storage':[{k:r[k] for k in ['id','name','status','conclusion']} for r in rows if r['name']=='Measurement storage policy']},indent=2))
job='bash target-build.sh '+shlex.join([meta['parent'],head,str(pr)])+'; rc=$?; printf "%s\\n" "$rc" > target.status'
cmd='cd '+shlex.quote(rd)+' && if ! test -s job.pid; then (setsid nohup bash -c '+shlex.quote(job)+' >target.log 2>&1 </dev/null & echo $! >job.pid); fi && cat job.pid'
subprocess.run(['tailscale','ssh','david@benchpress',cmd],check=True)
