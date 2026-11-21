#!/usr/bin/env python3
# values.py BEFORE_DIR AFTER_DIR FUZZ_BEFORE_DIR ROUNDS_DIR READINGS.json OUT.json: the holes' campaign's numbers as one
# file for the write-ups' templates (fill.py): the sweep's counts and kinds on the code before and on the code here, the
# corpora's counts, the generator's, the probes', the triggers', the fault rounds' tallies and the 9700X's readings.
# Every number is read from a run's own file; a file that is missing fails the run.
import ast, collections, glob, json, os, re, sys
before, after, fuzz_before, rounds, readings, out = sys.argv[1:7]
SETS = ('default', 'wall', 'everything')
UNITS = ('sqlite', 'lua', 'musl', 'main')
AGREE = re.compile(r' status 0 .*refused [0-9]+ diff 0 .*entries [0-9]+ diff 0 .*values alone 0 .*compared [0-9]+ program-refs [0-9]+ diff refs 0 facts 0 folds 0 truths 0$')
def sweep(directory):
    r = {}
    for pile in ('tests', 'inline'):
        r[pile] = {}
        for s in SETS:
            d = ast.literal_eval(open('%s/%s-%s.log' % (directory, pile, s)).read().strip().split('\n')[-1])
            r[pile][s] = dict(rejected=d.get('rejected', 0), clean=d.get('clean', 0), found=d.get('found', 0))
    return r
def kinds(directory):
    per = {}
    for s in SETS:
        k = collections.OrderedDict()
        programs = None
        for line in open('%s/classes-%s.txt' % (directory, s)):
            m = re.match(r'^programs (\d+)$', line)
            if m:
                programs = int(m.group(1))
            m = re.match(r'^\s+(\d+) ([a-z-]+)$', line)
            if m:
                k[m.group(2)] = int(m.group(1))
        per[s] = (programs, k)
    return per
CORPUS_KEYS = [
    ('t_taken', r'reader-time T expressions=\d+ records=\d+ typed=\d+ taken=(\d+)'),
    ('t_expressions', r'reader-time T expressions=(\d+)'),
    ('t_refused_callee', r'reader-time T refused=callee expressions=(\d+)'),
    ('tests_taken', r'reader-time tests compared=\d+ never-lowered=\d+ taken-there=(\d+)'),
    ('tests_refused', r'reader-time tests expressions=\d+ refused=(\d+)'),
    ('c_decided', r'window contexts expressions=\d+ records=\d+ decided=(\d+)'),
    ('rows_taken', r'window rows expressions=\d+ records=\d+ taken=(\d+)'),
    ('rows_entries', r'window rows expressions=\d+ records=\d+ taken=\d+ \([^)]*\) their-records=\d+ \([^)]*\) their-entries=(\d+)'),
    ('kernel_made', r'reader-time fact words made=(\d+)'),
    ('kernel_left', r'reader-time fact words made=\d+ \([^)]*\) left=(\d+)'),
    ('lines_again', r"declarations'-lines=\d+ \([^;]*; (\d+) made again"),
    ('summaries_kept', r'window summaries compared=(\d+)'),
    ('nothing_listed', r'own tests expressions-with-nothing-listed=(\d+)'),
    ('orders_left_out', r"pointers'-ordered-comparisons-left-out=(\d+)"),
    ('own_objects', r"the-program's-own-objects=(\d+)"),
    ('pragma_labelled', r'objects-a-pragma-labelled=(\d+)'),
    ('objects', r'reader-time T objects=(\d+)'),
    ('library_calls', r'reader-time T objects=\d+ differences=\d+ library-calls=(\d+)'),
]
ZERO = ('t_refused_callee',)
NEW = ('orders_left_out', 'own_objects', 'pragma_labelled')
def corpora(directory, new):
    r = {}
    status = open(directory + '/status.txt').read()
    for unit in UNITS:
        for tag, label in (('--passes0--window-rows--list20', ''), ('--passes0--window-rows-Wall-Wextra--list20', '-wall')):
            text = open('%s/%s%s.out' % (directory, unit, tag)).read()
            d = {}
            for key, pattern in CORPUS_KEYS:
                m = re.search(pattern, text)
                if m is None and not (key in ZERO or (key in NEW and not new)):
                    raise SystemExit('%s %s: no %s' % (directory, unit + label, key))
                d[key] = int(m.group(1)) if m else 0
            r[unit + label] = d
    assert status.count(' status 0') >= 8 and ' status 1' not in status, status
    return r
def fuzz(directory):
    programs = found = clean = rejected = 0
    seeds = {}
    for k in range(61, 67):
        last = open('%s/run-%d.log' % (directory, k)).read().strip().split('\n')[-1]
        m = re.match(r'seed (\d+): (\d+) programs, (\d+) rejected, (\d+) clean, (\d+) found', last)
        programs += int(m.group(2)); rejected += int(m.group(3)); clean += int(m.group(4)); found += int(m.group(5))
        seeds[m.group(1)] = int(m.group(5))
    return dict(programs=programs, rejected=rejected, clean=clean, found=found, found_all=found, seeds=seeds)
def probes(directory, cases):
    lines = disagree = 0
    for k in cases:
        for line in open('%s/cases%d.txt' % (directory, k)):
            lines += 1
            disagree += AGREE.search(line.rstrip('\n')) is None
    return dict(lines=lines, disagree=disagree)
def triggers(path):
    text = open(path).read()
    m = re.search(r'triggers: (\d+) warnings; (\d+) written, (\d+) of them warn; (\d+) from the piles; (\d+) with none; (\d+) with a run that differs', text)
    rows = len(re.findall(r'^\s*\d+ [A-Z_0-9]+ ', text, re.M))
    return dict(tested=int(m.group(1)), written=int(m.group(2)), warn=int(m.group(3)), from_piles=int(m.group(4)), none=int(m.group(5)), differ=int(m.group(6)),
                runs=3 * (int(m.group(2)) + int(m.group(4))))
def tally(paths):
    verdicts, names = {}, {}
    for path in paths:
        for line in open(path):
            w = line.split()
            if len(w) < 3 or not w[1].isdigit():
                continue
            names[int(w[1])] = w[2]
            verdicts.setdefault(int(w[1]), set()).add(w[0])
    assert all(len(v) == 1 for v in verdicts.values()), [names[i] for i, v in verdicts.items() if len(v) > 1]
    count = collections.Counter(next(iter(v)) for v in verdicts.values())
    return dict(total=len(verdicts), caught=count.get('caught', 0), survived=sorted(names[i] for i, v in verdicts.items() if 'SURVIVED' in v),
                not_built=sorted(names[i] for i, v in verdicts.items() if 'not-built' in v), killed=count.get('KILLED', 0))
v = {}
v['before'] = dict(sweep=sweep(before))
v['after'] = dict(sweep=sweep(after))
k = kinds(before)
v['before']['programs'] = k['default'][0]
v['before']['kinds'] = k['default'][1]
v['before']['same_in_every_set'] = all(k[s] == k['default'] for s in SETS)
for s in SETS:
    assert v['before']['sweep']['inline'][s]['found'] + v['before']['sweep']['tests'][s]['found'] == k[s][0], s
first = v['after']['sweep']
v['programs'] = dict(inline=sum(first['inline']['default'].values()), inline_accepted=first['inline']['default']['clean'] + first['inline']['default']['found'],
                     tests=sum(first['tests']['default'].values()), tests_accepted=first['tests']['default']['clean'] + first['tests']['default']['found'])
v['sweep_seconds'] = int(open(after + '/sweep-seconds.txt').read())
v['corpora_before'] = corpora(before + '/shadow', False)
v['corpora'] = corpora(after + '/shadow', True)
v['fuzz_before'] = fuzz(fuzz_before)
v['fuzz'] = fuzz(after + '/fuzz')
v['probes'] = probes(after + '/probes', range(1, 27))
v['probes_new'] = probes(after + '/probes', [26])
v['probes_before'] = probes(before + '/probes', [26])
v['triggers'] = triggers(after + '/triggers.txt')
v['triggers_before'] = triggers(before + '/triggers.txt')
v['fixtures'] = {}
for line in open(after + '/fixtures/summary.txt'):
    m = re.match(r'(\S+) (before|after): annotated (\d+) not-holding (\d+) status (\d+)', line)
    v['fixtures'].setdefault(m.group(1), {})[m.group(2)] = dict(annotated=int(m.group(3)), bad=int(m.group(4)), status=int(m.group(5)))
v['faults'] = {}
for name in sorted(os.listdir(rounds)):
    files = sorted(glob.glob('%s/%s/*.txt' % (rounds, name)))
    if files:
        v['faults'][name] = tally(files)
v['x'] = json.load(open(readings)) if os.path.exists(readings) else None
v['before_revision'] = os.environ.get('BEFORE_REVISION', '')
v['code_revision'] = os.environ.get('CODE_REVISION', '')
v['code_note'] = os.environ.get('CODE_NOTE', '')
json.dump(v, open(out, 'w'), indent=1, sort_keys=True)
print('written', out)
