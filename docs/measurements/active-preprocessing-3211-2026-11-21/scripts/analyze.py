from pathlib import Path
import sys,re,statistics,collections
p=Path(sys.argv[1])
rows=collections.defaultdict(list)
for f in sorted(p.glob('*.stat')):
    stem=f.stem
    order,corpus,position,variant=re.match(r'^(\d+)-(.+)-(\d+)-(base|off|on)$',stem).groups()
    s={m[1]:float(m[2]) for m in re.finditer(r'^time-stage\t([^\t]+)\t([0-9.]+)\t',f.with_suffix('.err').read_text(),re.M)}
    events={a[2]:float(a[0]) for line in f.read_text().splitlines() if (a:=line.split(';'))[0].isdigit()}
    wall=re.search(r'^run 1 list 1: ([\d.]+) ms wall',f.with_suffix('.wall').read_text(),re.M)
    rows[corpus,variant].append(dict(**s,**events,wall=float(wall[1]),order=int(order)))
for c in ('sqlite','features','shell','all-active'):
 print(c)
 for k in ('preprocess','preprocess.lex','preprocess.refine','preprocess.directives','preprocess.main-loop','parse','total','wall','instructions:u','cycles:u','cycles:k','minor-faults'):
  groups=[[r[k] for r in sorted(rows[c,x],key=lambda r:r['order'])] for x in ('base','off','on')]
  if not all(groups):continue
  med=[statistics.median(z) for z in groups]
  d=[100*(o/b-1) for b,o in zip(groups[1],groups[2])]
  print(f'{k:24s} {med[0]:12.3f} {med[1]:12.3f} {med[2]:12.3f} paired {statistics.median(d):+7.3f}% [{min(d):+.2f},{max(d):+.2f}]')
