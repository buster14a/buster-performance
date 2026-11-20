#!/usr/bin/env python3
# gen-readme.py RECORD VALUES: the record's README (RECORD/README.md): its first section, kept as it is, then the
# builds, the experiments, the fault rounds, the probes, the final readings and the cloud container's checks, with the
# tables and the gates gen-docs.py made (VALUES, its values.json) and counts read from the record's own files.
import glob, json, re, sys
record, values_path = sys.argv[1], sys.argv[2]
V = json.load(open(values_path))
readme = open(record + '/README.md').read()
head = readme[:readme.index('\n## 2. ')] if '\n## 2. ' in readme else readme.rstrip('\n') + '\n'
def lines(path):
    return open(path).read().splitlines()
def n(x):
    return '{:,}'.format(x)
r1 = V['rounds']['round1']; r2 = V['rounds']['round2']
raw = {name: len([l for l in lines('%s/faults/raw/%s.txt' % (record, name)) if re.match(r'(caught|SURVIVED) ', l)])
       for name in ('round1-9700x', 'round1-cloud-from-the-end', 'round1-cloud-from-260', 'round1-cloud-from-170')}
syntax2 = lines(record + '/faults/syntax-round2.txt')
checks = {q: lines('%s/faults/checks/check%d.txt' % (record, q)) for q in (2, 3, 4, 5, 6)}
check_caught = sum(len([l for l in checks[q] if l.startswith('caught ')]) for q in checks)
check_survived = [l.split()[2] for q in checks for l in checks[q] if l.startswith('SURVIVED ')]
progress = lines(record + '/final/cloud-checks/progress.txt')
status = lines(record + '/final/cloud-checks/shadow/status.txt')
items = lines(record + '/final/cloud-checks/complete-light-items.txt') + lines(record + '/final/cloud-checks/complete-heavy-items.txt')
passed = len([l for l in items if l.startswith('== ') and ': passed' in l]); failed = len([l for l in items if l.startswith('== ') and ': failed' in l])
against = open(record + '/final/cloud-checks/complete-light-the-preprocessor-against-clang.txt').read()
against_differ = re.search(r'^files: (\d+) of (\d+) differ', against, re.M)
assert failed == 1 and len(re.findall(r'the line markers place token \d+ \(of (\d+), clang \1\) differently', against)) == int(against_differ.group(1))
before_against = open(record + '/../x-branch-rows-2850-2026-11-20/final/cloud-checks/complete-light-the-preprocessor-against-clang.txt').read()
assert re.search(r'^files: (\d+) of (\d+) differ', before_against, re.M).groups() == against_differ.groups()
checker = lines(record + '/final/cloud-checks/test-checker-status.txt')
modes = lines(record + '/final/cloud-checks/modes-status.txt')
san = lines(record + '/final/cloud-sanitizers/progress.txt') if glob.glob(record + '/final/cloud-sanitizers/progress.txt') else []
revision = lines(record + '/final/cloud-checks/revision.txt')[0][:9]
kinds = {c: open('%s/experiments/object-kinds/%s.txt' % (record, c)).read() for c in ('sqlite', 'lua', 'musl')}
placed = sum(int(re.search(r'placed=(\d+)', kinds[c]).group(1)) for c in kinds)
both = sum(int(re.search(r'object-and-other-constant=(\d+)', kinds[c]).group(1)) for c in kinds)
calls = {c: open('%s/experiments/number-calls/%s.txt' % (record, c)).read() for c in ('sqlite', 'lua', 'musl', 'fixtures')}
calls_all = sum(int(re.search(r'two or more=(\d+)', calls[c]).group(1)) for c in calls)
calls_fewer = sum(int(re.search(r'operand=(\d+) with one=(\d+)', calls[c]).group(i)) for c in calls for i in (1, 2))
starts = {c: open('%s/experiments/start-two-after/%s--passes0--window-rows.txt' % (record, c)).read() for c in ('sqlite', 'lua', 'musl')}
differ = [int(re.search(r'experiment-starts: blocks=\d+ differ=(\d+)', starts[c]).group(1)) for c in ('sqlite', 'lua', 'musl')]
final_label = V['final_label']; base_label = V['base_label']
out = head
out += '''
## 2. The builds (`builds/`)

**What was run.** Each build is a patch on [buster14a/buster#3191](https://github.com/buster14a/buster/pull/3191)'s
head `5ee22d6a5` (`builds/9700x/LABEL/LABEL.patch`, `revision.txt`, `build.log`), built Release on the 9700X by
`builds/build-label.sh` and read by `builds/turns.sh`: `measure-node-machine --shadow --passes 0 --window-rows` on
`sqlite3.c` and Lua, CPU 2, each run its own hold of the lock, two or three readings (`on-CORPUS-N.txt`), with the
branches' piece's executable beside it (`xb6/base-CORPUS-N.txt`). Each job wrote the base's readings under one name,
so the ones in the record are those taken beside the last build (`xv6`): the base's beside the earlier builds are
gone, and the table has each build's own readings. `builds/xv-table.py` makes `builds/xv-table.txt` from the runs.

''' + V['builds_table'] + '''

''' + V['builds_notes'] + '''

- **The builds between.** `xv1s` and `xv3s` are the first and the third with a clock's read around each loop of the
  sweep (`split-CORPUS-N.txt`): the reads cost more than the loops, and their totals are not the builds'. `xv5`'s
  `again-CORPUS-N.txt` are three more readings of the same executable.
- **The counters** (`builds/counters.py`, `builds/counters.txt`): `xv4p` is the fourth build and `xv7p` the code as
  the fault rounds found it, each with an experiment's patch that opens seven or eight counters with
  `perf_event_open` (user mode) and reads each before and after the sweep, summed for a chunk's first run and its
  second (`pmu-CORPUS-N.txt`; `xv7p` reads them around the rows' write too). The reads are instructions of the
  region themselves, more of them with eight counters than with seven. `LL-read-misses` and
  `stalled-cycles-backend` do not count on this processor and read zero.
- `builds/functions.txt`: the sizes of the rows' functions in each build's executable (`nm -S`).

## 3. Three counts for terms the first fault round found implied (`experiments/`)

Each is an edit of the tree in place, made by its script, never committed, a Develop build in the cloud container,
and the shadow on the three corpora (counts, no times).

- `object-kinds.py`, `object-kinds/`: the window's placed records by whether they have an object and what their
  constant's kind is. ''' + n(placed) + ''' placed records of the three corpora, ''' + n(both) + ''' with an object and a constant that is no
  address's; and of the records each of the values' loops reads a value of, none has both either (the loops' counts
  are of a chunk's two runs). Four records of `sqlite3.c`'s first list have an object and no constant: members, whose
  value the reads' loop overwrites with the offset. So a record's value is its object's number where it has one,
  with no test of its constant's kind.
- `start-two-after.py`, `start-two-after/`: a block's first marked records with an expression's start two records
  after the end before it, beside the code's own. The two differ in ''' + ', '.join(n(d) for d in differ[:2]) + ' and ' + n(differ[2]) + ''' blocks of the three corpora: a
  call with no argument right after a condition. The fixture has those lines now.
- `number-calls.py`, `number-calls/`: the numbering's calls by its expression's marked records: ''' + n(calls_all) + ''' calls on the
  three corpora and the fixtures, ''' + n(calls_fewer) + ''' for an expression with fewer than two. So the routine has no test for it.

## 4. The fault rounds (`faults/`)

**What was run.** `make-faults-values.py` makes a round's list (`faults-values-round1.py`: ''' + n(r1['faults']) + ''' faults on the code
`xvf1.patch` has, on main `3e6f78b67`): each fault alone, a Develop build and `test-checker --seed 133 --part 5/8`.
The first round ran from the list's two ends at once: on the 9700X from the first fault up
(`job-faults-values.sh`, `raw/round1-9700x.txt`, ''' + n(raw['round1-9700x']) + ''' verdicts) and in the cloud container's mutation trees from
the last down (`local-round.sh`; `raw/round1-cloud-*.txt`, ''' + n(raw['round1-cloud-from-the-end'] + raw['round1-cloud-from-260'] + raw['round1-cloud-from-170']) + ''' verdicts).
`join-round.py` joins them by name (`round1-joined.txt`): every fault has a verdict, ''' + n(r1['twice']) + ''' have two, and no two
differ. ''' + n(r1['caught']) + ''' caught, ''' + n(len(r1['survived'])) + ''' survived.

As a survivor came up its change was made and its fault's build run against the changed code before the next round
(`checks/check2.txt` to `check6.txt`, in the cloud container, each on the tree as it was then: ''' + n(check_caught) + ''' caught; ''' + (', '.join(sorted(set(check_survived))) if check_survived else 'none') + '''
survived a check and was caught by a later one, once the fixture had its line).

`make-faults-values2.py` makes the second round's list from the code as it is (`faults-values-round2.py`, 349
faults; `faults-values-round2.py.no-faults.txt` has the five left out and why). The second round ran the faults whose
text changed, the new ones and the first round's survivors (`round2-indices.txt`, ''' + n(r2['faults']) + ''' faults; each compiled alone
first, `syntax-check.sh`, `syntax-round2.txt`: ''' + n(len([l for l in syntax2 if l.startswith('ok ')])) + ''' ok and one that left a variable unused, rewritten) on the
9700X, on the pull request's code (`xvf2.patch` on main `4acd0645e`; `round2.txt`): ''' + n(r2['caught']) + ''' caught, ''' + n(len(r2['survived'])) + ''' survived. The
other faults' lines are the first round's, and the tests have every check they had then.

## 5. The probes (`probes/`)

`probe.py` runs each case as a file of its own through `measure-node-machine --shadow --window-rows --passes 0`
and prints a line a case. `cases15.py` to `cases19.py` are the values' (a constant's, an address's, a member's and a
stride's; a store's and an update's; a call's row; a branch's label; a temporary's number), and `cases20.py` what a
surviving fault's fixture line was probed with. The outputs on the pull request's code are in
`final/cloud-checks/probes/`: ''' + V['probes_new'] + ''' of the values' and the ''' + V['probes_old'] + ''' of the pieces before, every tape made the
reference's, in a value too.

## 6. The final readings, and the checks (`final/`)

**What was run.** `final/job-xv.sh`: a Release build of the pull request's code with an experiment's switch
(`final/9700x/''' + final_label + '/' + final_label + '''.patch` on main `4acd0645e`; `BUSTER_TESTS_SKIP=1` turns the values off: no record's
value's column, no list, loop or numbering, and no value compared) and one of main as it is (`''' + base_label + '''`, the piece
before's); ''' + V['readings'] + ''' readings on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of the lock: in each
reading the first with the values on, off, the piece before's twice, then off and on again.
`final/xv-final-table.py` makes `final/''' + final_label + '''-table.txt`.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
''' + V['measured_table'] + '''

**Against the specification's gates.**

''' + V['gates'] + '''

**The cloud container's checks** on the code's commit `''' + revision + '''` (`final/cloud-checks/`, `checks-rows.sh`,
`progress.txt`): a native Release build; the whole `test-checker` (''' + n(len([l for l in checker if 'status 0' in l])) + ''' of ''' + n(len([l for l in checker if 'status' in l])) + ''' parts with status 0); the shadow with
`--window-rows` and with `--window-contexts` on the three corpora and with `--window-rows` on the compiler's own
source, with the default warnings and with `-Wall -Wextra` (''' + n(len([l for l in status if 'status 0' in l])) + ''' of ''' + n(len([l for l in status if 'status' in l])) + ''' runs with status 0; `shadow/` has their rows' lines); the shadow's
other modes on `sqlite3.c` and Lua (''' + n(len([l for l in modes if 'status 0' in l])) + ''' of ''' + n(len([l for l in modes if 'status' in l])) + '''); the self-check, the self-parse, the call graph and the
ownership check; and the complete driver's lists, ''' + n(passed) + ''' of whose ''' + n(passed + failed) + ''' items pass. The one that does not is the preprocessor's comparison
with clang: ''' + against_differ.group(1) + ''' of its ''' + against_differ.group(2) + ''' units differ, each by where the line markers place a token and by no token
(`complete-light-the-preprocessor-against-clang.txt`; each one's count is clang's), as they did on the piece
before's commit in this container (its record's `final/cloud-checks/`, the same ''' + against_differ.group(1) + ''' of ''' + against_differ.group(2) + '''). `final/pins.txt` has the
fixtures' pins (`final/pins.py`).
'''
if san:
    out += '''
**The sanitizers** (`final/cloud-sanitizers/progress.txt`, `sanitizers-parts.sh`): the native memory, address and
thread rows, each a Release build, `test-checker`'s part 5 and, for memory and address, the shadow with
`--window-rows` on `sqlite3.c`, Lua and the compiler's own source: ''' + n(len([l for l in san if ' status 0' in l])) + ''' of ''' + n(len([l for l in san if ' status ' in l])) + ''' steps with status 0, no report.
'''
out += '''
## 7. The generators (`final/generators/`)

`gen-docs.py` makes the design's two sections from their templates and this record's files (`values.json` has every
number it read or computed), `gen-readme.py` this file's sections 2 to 7, and `assemble.sh` copied the evidence
here.
'''
open(record + '/README.md', 'w').write(out)
