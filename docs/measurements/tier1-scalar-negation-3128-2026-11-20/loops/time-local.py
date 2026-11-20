from pathlib import Path
import csv,os,statistics,subprocess,time
root=Path(__file__).resolve().parent
cases=list(csv.DictReader((root/'cases.tsv').open(),delimiter='\t'))
table={(int(r['width']),int(r['layout']),r['variant']):r for r in cases}
outdir=root/'local';outdir.mkdir(exist_ok=True)
rows=[];metrics=['cycles:u','instructions:u','branches:u','branch-misses:u','task-clock']
variants=['control','legacy','vex']
for r in range(7):
    settings=[(bits,pad,dirty) for dirty in [0,1] for pad in [0,16,32,48] for bits in [32,64]]
    for p in range(len(settings)):
        bits,pad,dirty=settings[(p+5*r)%len(settings)]
        for k in range(3):
            index=(k+r+p)%3 if r%2==0 else (r+p-k)%3
            v=variants[index];case=table[bits,pad,v];exe=root/'programs'/case['program']
            stat=outdir/f'neg-{r}-{bits}-p{pad}-dirty{dirty}-{v}.stat'
            result=subprocess.run(['perf','stat','--no-big-num','-x',';','-e',','.join(metrics),'-o',str(stat),'--',exe,'512',str(dirty)],check=True,capture_output=True,text=True,env=dict(os.environ,LC_ALL='C'))
            assert result.stdout.strip()==case['expected']
            vals={z[2]:float(z[0]) for l in stat.read_text().splitlines() if len(z:=l.split(';'))>2}
            rows.append([r,bits,pad,dirty,v,case['address'],case['sha256'],result.stdout.strip(),*[vals[x] for x in metrics]])
with (root/'local.tsv').open('w') as f:
    out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(['round','width','pad','dirty','variant','address','binary_sha','output',*metrics]);out.writerows(rows)
with (root/'local-summary.tsv').open('w') as f:
    out=csv.writer(f,delimiter='\t',lineterminator='\n');out.writerow(['width','dirty','layout','base','head','metric','pairs','base_per_element','head_per_element','paired_pct','paired_min','paired_max'])
    for bits in [32,64]:
        for dirty in [0,1]:
            for pad in [0,16,32,48]:
                for a,b in [('control','legacy'),('legacy','vex'),('control','vex')]:
                    for index,metric in enumerate(metrics[:2]):
                        data={v:[line[8+index] for line in rows if line[0]!=0 and line[1:5]==[bits,pad,dirty,v]] for v in (a,b)}
                        assert len(data[a])==len(data[b])==6
                        delta=[100*(y/x-1) for x,y in zip(data[a],data[b])]
                        out.writerow([bits,dirty,pad,a,b,metric,6,round(statistics.median(data[a])/(4096*512),5),round(statistics.median(data[b])/(4096*512),5),round(statistics.median(delta),3),round(min(delta),3),round(max(delta),3)])
