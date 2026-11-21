from pathlib import Path
import re,sys,statistics
for tag in sys.argv[1:]:
 root=Path('work/pp-results')/tag
 for c in ('sqlite','features','shell','all-active'):
  raw,run=[{k:int(v) for k,v in re.findall(r'(\w+)=(\d+)',(root/f'check-{tag}'/f'{c}-E-{v}.counts').read_text())} for v in (0,1)]
  rows=raw['compact_rows']-(run['compact_rows']-run['spans']+run['entered_rows'])
  ids=raw['compact_names']-run['compact_names']-run['entered_names']
  rate=[]
  for v in ('off','on'):
   med=statistics.median(float(re.search(r'run 1 list 1: ([\d.]+) ms wall',f.read_text())[1]) for f in (root/f'timing-{tag}').glob(f'*-{c}-*-{v}.wall'))
   rate.append(raw['bytes']/med/1000)
  print(tag,c,run['spans'],run['entered_spans'],rows,ids,run['planned_bytes']-run['entered_bytes'],*[round(z,2) for z in rate])
