from pathlib import Path
import re,sys
text=Path(sys.argv[1]).read_text()
patt=re.compile(r'^(\w+) (AA|AB) processes (\d+) inclusive medians ([\d.]+) ([\d.]+) paired delta ([+\-\d.]+) \[([+\-\d.]+),([+\-\d.]+)\] second faster (\d+) / (\d+)')
rows={}
for l in text.splitlines():
 m=patt.match(l);assert m,l
 rows[m[1],m[2]]=[int(m[3]),*map(float,m.groups()[3:8]),int(m[9]),int(m[10])]
print('### Identical inputs and the cost of their producer\n')
print('Each process charges its measured producer to both labels and times complete adjacent sweeps of identical inputs, including the given records. It warms each label twice and alternates the order across nine measured pairs. The next process reverses the starting order. Seven processes per corpus and label give 63 paired sweeps. The table reports the median of the seven process medians in TSC ticks per original window record.\n')
print('| Corpus | A/A median | A/B median | A/B process range | Candidate faster | A/B change as a share of the producer-inclusive control |')
print('| --- | ---: | ---: | ---: | ---: | ---: |')
for c in ('sqlite','lua','musl'):
 z=rows[c,'AA']; a=rows[c,'AB'];assert z[0]==a[0]==7 and a[7]==63
 print('| %s | %+.4f | %+.4f | [%+.4f, %+.4f] | %d/63 | %+.4f%% |'%(c,z[3],a[3],a[4],a[5],a[6],a[3]/a[1]*100))
