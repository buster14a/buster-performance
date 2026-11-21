from pathlib import Path
import sys
import subprocess
from statistics import median
from collections import defaultdict
root=Path(sys.argv[1])
# Reuse the identical front/stage, wait4 and operand controls from the other spun arms.
meter=Path(__file__).with_name('pp-bounded-front-score.py').read_text()
a=meter.index('for study,arms in [');b=meter.index("    d=root/study",a)
meter=meter[:a]+"""for study,arms in [('scopeadmit-time',[
    ('parent','off'),('off','publish'),('publish','fused'),('off','fused'),('parent','fused'),('off','read'),('parent','read'),('fused','read')])]:
"""+meter[b:meter.index("d=root/'macrobank-kernel-fixed'")]
exec(meter)
by=defaultdict(lambda:defaultdict(lambda:defaultdict(list)))
for p in (root/'scopeadmit-time').glob('*.kernel'):
 for line in p.read_text().splitlines():
  if not line.startswith('scope-kernel '):continue
  _,rep,mode,rows,possible,convert,normalize,checksum,_hash=line.split()
  if int(rep)==0:continue
  for metric,cost in [('conversion',int(convert)),('normalization',int(normalize)),('conversion+normalization',int(convert)+int(normalize)),('separate checksum',int(checksum))]:
   by[metric][p.stem][mode].append(cost/int(rows))
for metric,series in by.items():
 for a,b in [('0','1'),('1','2'),('0','2'),('0','3')]:
  compare('scopeadmit-kernel','sqlite',a,b,metric+' TSC/token',[(median(v[a]),median(v[b])) for v in series.values()])
