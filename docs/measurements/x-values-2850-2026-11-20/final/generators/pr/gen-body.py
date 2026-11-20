#!/usr/bin/env python3
# gen-body.py VALUES TEMPLATE OUT KEY=VALUE...: a write-up (the pull request's description, the result note, the
# follow-up issue) from its template: each @@key@@ replaced by gen-docs.py's value of that name (VALUES, its
# values.json), by one computed here from its numbers, or by a KEY=VALUE given.
import json, re, sys
V = json.load(open(sys.argv[1]))
text = open(sys.argv[2]).read()
extra = dict(a.split('=', 1) for a in sys.argv[4:])
def s(x):
    return '%+.2f' % (0.0 if abs(x) < 0.005 else x)
def n(x):
    return '{:,}'.format(x)
F = V['final']; C = V['final_counts']
SUM = "the rows' sweeps, a record swept"; LATER = '(a second run) a record swept'; VAL = 'the values'; LVAL = '(a second run) the values'
computed = {
    'v3': V['verdicts']['v3'], 'v4': V['verdicts']['v4'],
    'e_sqlite3': '%s (%s to %s)' % (s(F['sqlite3'][SUM]['e']), s(F['sqlite3'][SUM]['elo']), s(F['sqlite3'][SUM]['ehi'])),
    'e_lua': '%s (%s to %s)' % (s(F['lua'][SUM]['e']), s(F['lua'][SUM]['elo']), s(F['lua'][SUM]['ehi'])),
    'e_musl': '%s (%s to %s)' % (s(F['musl'][SUM]['e']), s(F['musl'][SUM]['elo']), s(F['musl'][SUM]['ehi'])),
    'later_e_sqlite3': s(F['sqlite3'][LATER]['e']), 'later_e_lua': s(F['lua'][LATER]['e']),
    'numbered_share': '%.2f%%, %.2f%% and %.2f%%' % tuple(100.0 * C[c]['numbered'] / C[c]['taken'] for c in ('sqlite3', 'lua', 'musl')),
    'tests': open(sys.argv[2].rsplit('/', 1)[0] + '/tests.md').read().strip(),
}
for c in ('sqlite3', 'lua', 'musl'):
    per = C[c]['swept'] / C[c]['chunks']
    computed['chunk_%s' % c] = '%.0f' % per
    computed['chunks_%s' % c] = n(C[c]['chunks'])
    for name, key in ((SUM, 'sum'), (VAL, 'values'), ('the reads', 'reads'), ('the shapes', 'shapes'), ('the updates and the branches', 'lists'), ('the rows', 'write'), ("an expression's part", 'part')):
        later = '(a second run) ' + (name if name != SUM else 'a record swept')
        first = F[c][name]['on']; second = F[c][later]['on']
        computed['%s_first_%s' % (key, c)] = '%.2f' % first
        computed['%s_second_%s' % (key, c)] = '%.2f' % second
        computed['%s_chunk_first_%s' % (key, c)] = n(round(first * per))
        computed['%s_chunk_second_%s' % (key, c)] = n(round(second * per))
        computed['%s_cold_%s' % (key, c)] = n(round((first - second) * per))
computed['lines_kb'] = '%.0f' % (C['sqlite3']['swept'] / C['sqlite3']['chunks'] * 64 / 1024)
for key in re.findall(r'@@(\w+)@@', text):
    value = extra.get(key, computed.get(key, V.get(key)))
    assert isinstance(value, str), key
    text = text.replace('@@%s@@' % key, value)
assert '@@' not in text, re.findall(r'@@\w+@@', text)
open(sys.argv[3], 'w').write(text)
