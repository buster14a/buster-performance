"""Source-order upper bound when completed body rows retire with the following restore."""
import csv
from pathlib import Path
from census import parse

w=Path(__file__).resolve().parent.parent
for corpus in ('sqlite','buster'):
    source=w/'source-use-run-study'/(corpus+'-upstream.events')
    intervals=w/'binding-close-study'/('sqlite.bodies.tsv' if corpus=='sqlite' else 'buster-canonical.bodies.tsv')
    _,columns=parse(source.read_bytes())
    operations=columns[8]
    point=columns[4]
    spans=list(csv.DictReader(intervals.open(),delimiter='\t'))
    persistent=previous=peak=0
    for i,span in enumerate(spans):
        begin,end=int(span['event_first']),int(span['event_end'])
        limit=int(spans[i+1]['event_first']) if i+1<len(spans) else len(operations)
        assert previous<=begin<=end<limit
        assert operations[end]==2 and point[end]>=int(span['end'])
        end+=1
        persistent+=begin-previous
        peak=max(peak,persistent+end-begin)
        previous=end
    persistent+=len(operations)-previous
    peak=max(peak,persistent)
    print(corpus,'whole events',len(operations),'post-restore pulses',len(spans),'file-events',persistent,'peak-live-events',peak)
