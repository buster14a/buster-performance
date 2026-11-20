#!/usr/bin/env python3
# derive.py VALUES.json FAULTS.json PROBES_DIR CLOUD_SHADOW_DIR FIXTURE.c [CHECKS_DIR SAN_DIR [OWN_DIR]] > values+derived.json: the numbers the
# write-ups state that are no cell of the readings' table, each computed here from a file a run wrote:
# - the gates' counts (the expressions newly taken against what the specification asked);
# - what the reference's C and X read on the newly taken records (by its averages a record) against what the piece
#   adds over all the records swept, a chunk's first run and its second;
# - the probes' counts (PROBES_DIR: cases21.txt, values/, earlier/, summary21.txt), the fault rounds' (account.py's
#   output), the compiler's own source's (CLOUD_SHADOW_DIR/main--*.out) and the three corpora's in the cloud
#   container, and the fixture's pins (the test's source).
import collections, glob, json, os, re, sys
v = json.load(open(sys.argv[1]))
faults = json.load(open(sys.argv[2]))
probes, cloud, fixture = sys.argv[3], sys.argv[4], sys.argv[5]
t = v['final']
asked = dict(sqlite3=780, lua=355, musl=950)
of = dict(sqlite3=825, lua=387, musl=1033)
simulated = dict(sqlite3=793, lua=366, musl=970)
d = {}
for c in ('sqlite3', 'lua', 'musl'):
    on, before, more, more_before = t[c]['counts on'], t[c]['counts before'], t[c]['more on'], t[c]['more before']
    x = {}
    x['asked'], x['of'], x['simulated'] = asked[c], of[c], simulated[c]
    x['more_taken'] = on['taken'] - before['taken']
    x['more_taken_share_of'] = '%.1f' % (100.0 * x['more_taken'] / of[c])
    x['short_of_asked'] = asked[c] - x['more_taken']
    x['more_decided'] = on['decided'] - before['decided']
    x['more_refused'] = on['refused'] - before['refused']
    x['more_records'] = on['records'] - before['records']
    x['more_records_share'] = '%.1f' % (100.0 * x['more_records'] / before['records'])
    x['more_entries'] = on['entries'] - before['entries']
    assert on['swept'] == before['swept'] and on['chunks'] == before['chunks'] and on['expressions'] == before['expressions'], c
    x['swept'], x['chunks'] = on['swept'], on['chunks']
    x['records_a_chunk'] = round(on['swept'] / on['chunks'])
    x['valued'], x['sunk'], x['commas'] = more['valued'], more['sunk'], more['commas']
    x['valued_one_in'] = round(on['swept'] / more['valued'])
    x['asking_one_in'] = round(on['swept'] / (more['valued'] + more['commas']))
    x['listed_logical_fewer'] = more_before['logical'] - more['logical']
    x['listed_comma_fewer'] = more_before['comma'] - more['comma']
    x['listed_x_more'] = on['listed'][1] - before['listed'][1]
    x['numbered'], x['numbered_before'] = on['numbered'], before['numbered']
    x['numbered_share'] = '%.2f' % (100.0 * on['numbered'] / on['taken'])
    x['numbered_before_share'] = '%.2f' % (100.0 * before['numbered'] / before['taken'])
    f = lambda line, field='d': float(t[c][line][field])
    reference = f("the reference's C, a record of the decided", 'on') + f("the reference's X, a record of the taken", 'on')
    x['reference_a_record'] = '%.2f' % reference
    x['reference_ticks'] = round(x['more_records'] * reference)
    first = f("C's sweeps, a record swept") + f("the rows' sweeps, a record swept")
    second = f("(a second run) C's sweeps, a record swept") + f('(a second run) a record swept')
    x['first_a_record_swept'], x['second_a_record_swept'] = '%+.2f' % first, '%+.2f' % second
    x['first_ticks'], x['second_ticks'] = round(on['swept'] * first), round(on['swept'] * second)
    x['first_share'] = '%.0f' % (100.0 * x['first_ticks'] / x['reference_ticks'])
    x['second_share'] = '%.0f' % (100.0 * x['second_ticks'] / x['reference_ticks'])
    # The same by a chunk: what the two sweeps' first run less their second rose by.
    x['chunk_more'] = round(f("the rows' sweeps: a chunk's first run less its second, ticks a chunk") + f("C's sweeps: a chunk's first run less its second, ticks a chunk"))
    x['taken_a_record'] = '%.2f' % (f('the rows, a record of the taken', 'on') + f('C, a record of the decided', 'on'))
    x['taken_a_record_second'] = '%.2f' % (f('(a second run) a record of the taken', 'on') + f('(a second run) C, a record of the decided', 'on'))
    d[c] = x
# The probes.
agree = re.compile(r' status 0 .*refused [0-9]+ diff 0 .*entries [0-9]+ diff 0 .*values alone 0 listed [0-9]+ numbered [0-9]+$')
def lines(pattern):
    out = []
    for path in sorted(glob.glob(os.path.join(probes, pattern))):
        out += [l.rstrip('\n') for l in open(path)]
    return out
new = lines('cases21.txt')
values_ = lines('values/cases*.txt')
earlier = lines('earlier/earlier.txt') + lines('earlier/cases9.txt') + lines('earlier/cases1[0-4].txt')
p = dict(new=len(new), new_cases=len(new) - 1, values=len(values_), earlier=len(earlier), all=len(new) + len(values_) + len(earlier))
p['disagree'] = sum(not agree.search(l) for l in new + values_) + sum(not re.search(r' status 0 .*refused [0-9]+ diff 0 .*entries [0-9]+ diff 0 ', l) for l in earlier)
kinds = collections.Counter()
for line in open(os.path.join(probes, 'summary21.txt')):
    m = re.match(r'(\S+)\s+(whole|listed for C|listed for X|refused)\s+(\d+)$', line)
    if m: kinds[m.group(2)] += int(m.group(3))
p['whole'], p['listed_c'], p['listed_x'], p['refused'] = kinds['whole'], kinds['listed for C'], kinds['listed for X'], kinds['refused']
assert sum(kinds.values()) == p['new_cases'], (kinds, p)
p['numbered'] = sum(bool(re.search(r' numbered [1-9]', l)) for l in new + values_)
d['probes'] = p
d['faults'] = faults
# The cloud container's runs of the frozen build: the three corpora and the compiler's own source.
def shadow(path):
    s = {}
    text = open(path).read()
    m = re.search(r'window contexts expressions=(\d+) records=(\d+) decided=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) of-them-refused=(\d+) differences=(\d+) records-that-differ=(\d+)', text)
    s.update(expressions=int(m.group(1)), decided=int(m.group(3)), decided_share=m.group(4), refused=int(m.group(7)), c_differences=int(m.group(8)), c_record_differences=int(m.group(9)))
    m = re.search(r'window contexts valued=(\d+) \(([\d.]+)% of the records swept\) of-them-listed-for-their-target=(\d+) commas=(\d+)', text)
    if m: s.update(valued=int(m.group(1)), sunk=int(m.group(3)), commas=int(m.group(4)))
    m = re.search(r'window contexts listed, by an expression\'s first record\'s reason: call=(\d+) logical-or-conditional=(\d+) update=(\d+) comma(?:-or-selection)?=(\d+) division-by-a-constant=(\d+) wide-value=(\d+) operator=(\d+)', text)
    s.update(listed_call=int(m.group(1)), listed_logical=int(m.group(2)), listed_comma=int(m.group(4)))
    m = re.search(r'window rows expressions=(\d+) records=(\d+) taken=(\d+) \(([\d.]+)%\) their-records=(\d+) \(([\d.]+)%\) their-entries=(\d+) differences=(\d+) not-kept-by-the-reference=(\d+) second-runs-that-differ=(\d+)', text)
    if m:
        s.update(x_expressions=int(m.group(1)), taken=int(m.group(3)), taken_share=m.group(4), differences=int(m.group(8)), unkept=int(m.group(9)), second=int(m.group(10)))
        s['taken_of_all'] = '%.2f' % (100.0 * s['taken'] / s['expressions'])
        m = re.search(r'window rows listed, by an expression\'s first record\'s reason: update=(\d+) branches=(\d+) refused-conversion=(\d+) constant-to-a-floating-class=(\d+)', text)
        s.update(x_listed_branches=int(m.group(2)))
    return s
d['cloud'] = {}
for unit in ('sqlite', 'lua', 'musl', 'main'):
    for mode, name in (('--window-rows', 'rows'), ('--window-rows-Wall-Wextra', 'rows_wall'), ('--window-contexts', 'contexts'), ('--window-contexts-Wall-Wextra', 'contexts_wall')):
        path = os.path.join(cloud, '%s--passes0%s--list20.out' % (unit, mode))
        if os.path.exists(path):
            d['cloud'].setdefault(unit, {})[name] = shadow(path)
runs = [l for l in open(os.path.join(cloud, 'status.txt')) if ' status ' in l]
d['cloud']['runs'] = len(runs)
d['cloud']['runs_failed'] = sum(not l.rstrip().endswith('status 0') for l in runs)
# The fixture's pins.
source = open(fixture).read()
m = re.search(r'\.valued = (\d+),\s*\n\s*\.sunk = (\d+),\s*\n\s*\.commas = (\d+),', source)
d['fixture'] = dict(valued=int(m.group(1)), sunk=int(m.group(2)), commas=int(m.group(3)))
# The cloud container's other checks (CHECKS_DIR) and the sanitizers' rows (SAN_DIR).
if len(sys.argv) > 7:
    checks, san = sys.argv[6], sys.argv[7]
    k = {}
    k['revision'] = open(os.path.join(checks, 'revision.txt')).read().strip()[:9]
    progress = open(os.path.join(checks, 'progress.txt')).read()
    k['progress'] = progress
    m = re.search(r'checker done: (\d+) of (\d+) parts with status 0', progress)
    k['checker_parts'], k['checker_parts_ok'] = int(m.group(2)), int(m.group(1))
    m = re.search(r'modes done: (\d+) of (\d+) runs with status 0', progress)
    k['mode_runs'], k['mode_runs_ok'] = int(m.group(2)), int(m.group(1))
    passed = failed = 0
    for name in ('complete-light.log', 'complete-heavy.log'):
        m = re.findall(r'parallel: \d+ commands in .*: (\d+) passed, (\d+) failed, (\d+) skipped, (\d+) not started', open(os.path.join(checks, name)).read())
        assert len(m) == 1 and m[0][2] == '0' and m[0][3] == '0', (name, m)
        passed += int(m[0][0]); failed += int(m[0][1])
    k['complete_passed'], k['complete_items'] = passed, passed + failed
    light = open(os.path.join(checks, 'complete-light.log')).read()
    failed_names = re.findall(r'^== (.*?)(?: \[\d+ CPUs\])?: failed', light, re.M)
    assert failed_names == ['Test the preprocessor on the repository\'s translation units against clang'], failed_names
    m = re.search(r'files: (\d+) of (\d+) differ', light)
    k['preprocessor_differ'], k['preprocessor_units'] = int(m.group(1)), int(m.group(2))
    markers = re.findall(r'^\S+: the line markers place token \d+ \(of (\d+), clang (\d+)\) differently', light, re.M)
    assert len(markers) == k['preprocessor_differ'] and all(a == b for a, b in markers), (len(markers), k['preprocessor_differ'])
    assert 'complete-parse: exit 0' in progress
    for name in ('self-check', 'self-parse', 'test-call-graph', 'check-call-graph', 'ownership', 'build'):
        assert re.search(r'^%s status 0$' % name, progress, re.M), name
    steps = [l for l in open(os.path.join(san, 'progress.txt')) if ' status ' in l]
    k['sanitizer_steps'] = len(steps)
    k['sanitizer_ok'] = sum(bool(re.search(r' status 0( |;|$)', l)) for l in steps)
    last = {}
    for l in steps:
        m = re.search(r'^(\S+) .*reports (\d+)', l)
        if m: last[m.group(1)] = int(m.group(2))
    k['sanitizer_reports'] = sum(last.values())
    k['sanitizer_rows'] = sorted(last)
    k['sanitizer_done'] = 'all done' in open(os.path.join(san, 'progress.txt')).read()
    k['sanitizer_checks'] = sorted(set(re.findall(r'test-checker: (\d+) checks, 0 failures', ''.join(steps))))
    d['checks'] = k
# The compiler's own source through the piece before's build and the piece's (OWN_DIR: before-*.out, after-*.out).
if len(sys.argv) > 8:
    own = sys.argv[8]
    o = {name: shadow(os.path.join(own, name + '-default.out')) for name in ('before', 'after')}
    for name in ('before', 'after'):
        wall = shadow(os.path.join(own, name + '-wall.out'))
        assert all(wall[key] == o[name][key] for key in ('decided', 'taken', 'refused', 'differences', 'c_differences', 'x_listed_branches')), name
        assert o[name]['differences'] == 0 and o[name]['c_differences'] == 0 and o[name]['second'] == 0
    assert o['after']['taken'] == d['cloud']['main']['rows']['taken'] and o['after']['decided'] == d['cloud']['main']['rows']['decided']
    o['more_taken'] = o['after']['taken'] - o['before']['taken']
    o['more_decided'] = o['after']['decided'] - o['before']['decided']
    o['more_taken_share'] = '%.2f' % (100.0 * o['more_taken'] / o['after']['expressions'])
    o['before_revision'] = open(os.path.join(own, 'before-revision.txt')).read().strip()[:9]
    d['own'] = o
v['derived'] = d
json.dump(v, sys.stdout, indent=1)
