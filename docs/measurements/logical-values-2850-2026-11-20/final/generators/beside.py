#!/usr/bin/env python3
# beside.py ALL.json: the table the specification asked beside its gates: what the reference's C and X read on the
# newly taken records (by its averages a record) against what the piece adds over all the records swept.
import json, sys
d = json.load(open(sys.argv[1]))['derived']
C = ('sqlite3', 'lua', 'musl')
def n(x): return format(int(x), ',')
def row(label, cell): print('| %s | %s |' % (label, ' | '.join(cell(d[c]) for c in C)))
print('| | `sqlite3.c` | Lua | musl |')
print('| --- | ---: | ---: | ---: |')
row('records newly taken; of those taken before', lambda x: '%s; %s%%' % (n(x['more_records']), x['more_records_share']))
row('the reference\'s C and X, ticks a record of theirs', lambda x: x['reference_a_record'])
row('**the reference on the newly taken records, ticks**', lambda x: '**%s**' % n(x['reference_ticks']))
row('the piece, C\'s sweeps and the rows\', more a record swept: a chunk\'s first run; its second', lambda x: '%s; %s' % (x['first_a_record_swept'], x['second_a_record_swept']))
row('records swept', lambda x: n(x['swept']))
row('**the piece over all the records swept, a first run: ticks; of the reference\'s**', lambda x: '**%s; %s%%**' % (n(x['first_ticks']), x['first_share']))
row('the same, a second run', lambda x: '%s; %s%%' % (n(x['second_ticks']), x['second_share']))
