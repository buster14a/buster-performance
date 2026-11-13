import json,re,os,sys,collections
# Usage: parse.py JOBS.json LINES_DIR > shards.txt; writes commands.json (each command's line, job, row and CPU).
jobs_file=sys.argv[1] if len(sys.argv)>1 else 'run-43481767714-jobs.json'
log_dir=sys.argv[2] if len(sys.argv)>2 else 'lines'
d=json.load(open(jobs_file))
jobs={j['id']:j for j in d}
cmd_re=re.compile(r'##\[group\](.*): (passed|failed|skipped)[^,]* in ([0-9.]+) s, ([0-9.]+) s of CPU(?:, ([0-9]+) MiB peak)?')
rows=[]
summary=[]
for f in os.listdir(log_dir):
    if not f[0].isdigit(): continue
    jid=int(f[:-4]); j=jobs.get(jid)
    if not j: continue
    name=j['name']
    m=re.search(r'\((native|x86-64|vector)[^)]*?, (none|address|thread|memory), O3\)',name) or re.search(r'\(Clang 23, (native|x86-64|vector), (none|address|thread|memory)',name)
    row=None
    m2=re.match(r'Tests on Ubuntu 26.04 \((native|x86-64|vector), (none|address|thread|memory), O3\)',name)
    if m2: row=m2.group(1)+'-'+m2.group(2)
    cpu=None
    for line in open(os.path.join(log_dir,f),errors='replace'):
        if 'cpu model:' in line and cpu is None:
            cpu=line.split('cpu model:')[1].strip()
        mm=cmd_re.search(line)
        if mm:
            title=mm.group(1)
            n=re.search(r'\[(\d+) CPUs?\]',title)
            ncpu=min(int(n.group(1)),4) if n else 1
            rows.append(dict(job=jid,row=row,name=name,cpu=cpu,title=title,status=mm.group(2),wall=float(mm.group(3)),cputime=float(mm.group(4)),ncpu=ncpu,peak=int(mm.group(5) or 0)))
        if 'parallel: ' in line and ' commands in ' in line:
            summary.append((row,name,cpu,re.sub(r'^\S+Z ','',line).strip()))
json.dump(rows,open('commands.json','w'))
print(len(rows))
for s in sorted(summary,key=lambda x:str(x[0])): print(s[0], s[2][:30] if s[2] else None, s[3][:110], '|', s[1][-40:])
