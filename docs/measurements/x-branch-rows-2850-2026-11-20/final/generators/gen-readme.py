#!/usr/bin/env python3
# gen-readme.py RECORD TREE: the record's README (RECORD/README.md): its first section, kept as it is, then the builds,
# the faults, the probes, the final readings and the cloud container's checks, with the tables and the gates of the
# design's section in TREE's docs/node-machine.md (gen-docs.py's, put there by apply-docs.py) and counts read from the
# record's own files.
import glob, re, sys
record, tree = sys.argv[1], sys.argv[2]
readme = open(record + '/README.md').read()
head = readme[:readme.index('\n## 2. ')] if '\n## 2. ' in readme else readme.rstrip('\n') + '\n'
docs = open(tree + '/docs/node-machine.md').read()
section = docs[docs.index("### The branches' rows on the window\n"):docs.index('### What it says of step 2\n')]
def between(start, end):
    a = section.index(start); b = section.index(end, a)
    return section[a:b].strip('\n')
builds_table = between('| build |', "\n\n- **A statement's CONDITION needs no turn")
builds_notes = between("- **A statement's CONDITION needs no turn", '\n\n**Measured.**')
measured = between('| | `sqlite3.c` | Lua | musl |', '\n\n**Against its gates.**')
gates = between('- **B1, exact', '\n\n**What stays')
def verdicts(path):
    t = open(path).read().splitlines()
    assert t[0].startswith('control-passes')
    where = {}
    for l in t[1:]:
        w = re.search(r'\[([^\]]+)\]$', l).group(1)
        where[w] = where.get(w, 0) + 1
    return len([l for l in t if l.startswith('caught ')]), [l.split()[1] for l in t if l.startswith('SURVIVED ')], where
rounds = [verdicts(p) for p in sorted(glob.glob(record + '/faults/round[0-9].txt'))]
def lines(path):
    return open(path).read().splitlines()
syntax1 = [l for p in sorted(glob.glob(record + '/faults/syntax-round1/shard-*.txt')) for l in lines(p)]
syntax2 = [l for p in sorted(glob.glob(record + '/faults/syntax-round2/shard-*.txt')) for l in lines(p)]
probes = {name: len(lines('%s/probes/%s.txt' % (record, name))) for name in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12', 'cases13', 'cases14')}
agree = re.compile(r' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 ')
assert all(agree.search(l) for name in probes for l in lines('%s/probes/%s.txt' % (record, name)))
again_lines = [l for name in probes for l in lines('%s/final/cloud-checks/probes/%s.txt' % (record, name))]
assert all(agree.search(l) for l in again_lines)
again = len(again_lines)
listed14 = len([l for l in lines(record + '/probes/cases14.txt') if re.search(r'listed upd \d+ br [1-9]', l)])
def pins(path):
    m = re.search(r"listed: update=(\d+) \((\d+)\) branches=(\d+) \((\d+)\)", open(path, errors='replace').read())
    return tuple(int(x) for x in m.groups()) if m else None
tie = pins(record + '/faults/mutants/reason-mark-other-way-with-the-line.err')
assert tie and tie[0] != tie[1] and tie[2] != tie[3], tie
two = re.search(r"made (\d+) tapes \((\d+)\) of (\d+) entries \((\d+)\)", open(record + '/faults/mutants/list-branching-with-two-on-the-turns-count.err', errors='replace').read())
assert two and two.group(3) != two.group(4), two
san = lines(record + '/final/cloud-sanitizers/progress-73b723aa9.txt') if glob.glob(record + '/final/cloud-sanitizers/progress-73b723aa9.txt') else []
checks = open(record + '/final/cloud-checks/progress.txt').read()
clang = lines(record + '/final/cloud-checks/complete-light-the-preprocessor-against-clang.txt')
m = re.search(r'files: (\d+) of (\d+) differ', '\n'.join(clang))
differing, units = int(m.group(1)), int(m.group(2))
marked = [l for l in clang if 'the line markers place token' in l]
assert len(marked) == differing and all(re.search(r'\(of (\d+), clang \1\)', l) for l in marked)
HANDOFF = '''
## 7. Who did what

The session that specified, built and measured the piece (the specification, the five builds, the three fault
rounds, the probes, its own checks and sanitizer pass, and [buster14a/buster#3190](https://github.com/buster14a/buster/pull/3190))
handed it off at its user's request before the final readings
([the hand-off](https://github.com/buster14a/buster/issues/2850#issuecomment-7042274752)), with their job running on
the 9700X. The session that took #2850 over ([its claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7042574537))
read that job's results (sections 5 and its gates), ran the generators on them, checked the code's commit again on
the main of that hour (section 6) and opened [buster14a/buster#3191](https://github.com/buster14a/buster/pull/3191),
which has #3190's one commit, cherry-picked unchanged, and the design's two sections as a second: it pushes to its
own branch alone, so #3190 was closed for it.
'''
functions = {}
for l in lines(record + '/builds/functions.txt'):
    label, name, size = l.split()
    functions.setdefault(label, {})[name] = int(size)
labels = sorted(k for k in functions if k.startswith('xb'))
text = head.rstrip('\n') + '''

## 2. The builds, and how it came to its cost (`builds/`)

Five builds before the fault rounds (`builds/9700x/xbN/`, each with its patch on main `00faef7dd`'s lineage,
`xbNx.patch`: the piece's source at that point and an experiment's switch, `BUSTER_TESTS_SKIP=1`, with which the
branches' template lists its expression and the sweep makes no second list, as the piece before had it).
`builds/job-xb.sh` builds one and reads it: in each reading that executable with the branches' rows on, off, the
piece before's executable (`xu8`, the record before this one) twice, then off and on, on `sqlite3.c`, Lua and musl,
CPU 2, each run its own hold of the lock. `builds/xb-table.py` makes a build's table (`builds/xbN-table.txt`);
`builds/make-patch.sh` made the patches; `builds/functions.sh` read the rows' functions' sizes off each build's
executable (`builds/functions.txt`). TSC ticks a record swept, three readings a build (seven for the last line,
section 5):

''' + builds_table + '''

''' + builds_notes + '''

## 3. The faults (`faults/`)

Each term of an operand's rule and of an operator's turn, each of their stores, the second list's sweep, the chunk's
guard, the reader's sense, each new row of the tables and the listed expression's reason, changed alone
(`faults/make-faults-round1.py` makes the first round's list, `faults-branch-round1.py`; `faults/make-faults.py` the
later rounds', `faults-branch-round2.py` and `faults-branch-round3.py`, and has a line for each fault that left the
list and why). Each fault was compiled first with `-fsyntax-only` (`faults/syntax-check.sh`: `faults/syntax-round1/`,
%d of %d built, and the four that did not, for a variable left without a use, were rewritten; `faults/syntax-round2/`,
the %d that were new or changed in the second round's list). A round ran on two machines at once, from the list's two
ends until they met: on the 9700X (`faults/job-faults-branch.sh`: a tree of its own with the round's patch on main
`00faef7dd`'s lineage, `faults/xbfN.patch`; the tree as it is first, which must pass, then a Develop build and
`test-checker --seed 133 --part 5/8` a fault, each its own hold of the lock) and in the cloud container
(`faults/local-round.sh`, the same a fault in a tree at the round's commit). `faults/roundN.txt` has a line a fault
with the machine that ran it (the faults both ran agree); `faults/raw/` has each machine's own lines.

| round | faults | caught | survived | on the 9700X; in the cloud container |
| --- | ---: | ---: | --- | --- |
''' % (len([l for l in syntax1 if l.startswith('ok ')]), len(syntax1), len(syntax2))
for i, (caught, survived, where) in enumerate(rounds):
    text += '| %d | %d | %d | %s | %d; %d |\n' % (i + 1, caught + len(survived), caught, ', '.join('`%s`' % x for x in survived) if survived else 'none',
                                              where.get('the 9700X', 0), where.get('the cloud container', 0))
text += '''
The first round's seven:

- `list-count-not-ended` set the second list's count to the lesser of itself and its block's end. The turns' loop
  before it leaves the count no less than the end, so the fault changes nothing a program reaches; it is not in the
  later lists.
- `loop-before-the-updates` ran the branches' loop before the updates'. An update that is a tested value takes its
  own part from the one and its conversion's from the other, and each adds its entries to the row's length: the two
  orders write the same. The specification had the updates' first for that case; the comment says now that the
  order is no one's.
- `turn-second-before-first` gave an operator's second operand its sense before the first: two records, but a
  `!`'s one operand, whose two senses are the same.
- `operand-narrow-with-void` took void's class for a narrow one. No tested value has it (the checker takes only a
  scalar for a logical operator's operand), so the lower bound was a term no byte asked: the test is by its upper
  bound alone now.
- `list-branching-with-two` made the second list in a chunk with two records evaluated as branches or more, and
  `window-branches-count-of-roots` took the CONDITIONs out of that count. Both passed for one reason: the count had
  the CONDITIONs, which take no turn, and a chunk with a turn has a CONDITION and an operator below it. The count is
  the operators' with a turn now, and the unit of one chunk with one such operator fails the first fault
  (`faults/mutants/list-branching-with-two-on-the-turns-count.err`: its build's run of the fixture, %s entries for
  the unit's %s).
- `reason-a-root-tested` removed, from the listed expression's reason, the test that its record has a consumer
  before the read of that consumer's template. Nothing failed. A build of the round's code with a line for each
  listed record with no consumer (`faults/reason-probe/`: its patch, the three corpora's runs and the fixture's)
  printed none: every record that lists its expression there has a consumer (an initializer's value among them:
  `double d = 1;` prints none), so the test was a term no record asked. The front writes a record's consumer's
  distance only when the consumer's record is made, so a read without the test would lean on that. The reason reads
  no consumer now: an
  update by its template, an update's destination with no room by its own shape's mark, and any other record a
  tested value's.

The second round's two, both in the reason as rewritten:

- `reason-mark-of-its-conversion` read the mark in the record's conversion's part. The tables give a destination
  with no room the mark in both parts (`kept_owns` and `kept_conversions`, set together), so the fault changes
  nothing; it is not in the third list.
- `reason-mark-other-way` swapped the two reasons a record with the bit alone can have. It is a real fault, and the
  fixture hid it by a coincidence: it listed 67 expressions for an update's destination and 67 for a tested value,
  so the two counts swapped were the same two. The fixture got one more of the second (a `const` bool's read under a
  `do`), and that fault's build fails on it (`faults/mutants/reason-mark-other-way-with-the-line.err`: update=%d
  for %d, branches=%d for %d). The line was run against the fault's build before the third round.
''' % (two.group(3), two.group(4), tie[0], tie[1], tie[2], tie[3])
text += '''
## 4. The probes (`probes/`)

One-statement programs, each a file of its own through `measure-node-machine --shadow --window-rows --passes 0`
(`probes/probe-again.py COMPILER CASES`, which also asks that no chunk's second run differ from its first), on the
checks' build in the cloud container: %d conditions (`probes/cases13.py`: `&&`, `||` and `!` under an `if`, a
`while`, a `do` and a `for`; each nested in either operand of each, three deep; a tested value of each class and
kind; conditions C lists) and %d tested values that might have a conversion of their own (`probes/cases14.py`: a
decayed array's and function's, a qualified, an atomic and a bit-field's read, a cast's, a class past double's; %d of
them list their expression for branches, each a qualified `_Bool`'s read). And the pieces' before, %d
(`probes/earlier.txt`, `cases9` to `cases12`; their cases are in the records before this one). Every one reads as X
on T's columns does: no tape differs, and no answer of C's. The pull request's commit's build read them again
(`final/cloud-checks/probes/`, `final/cloud-checks/run-probes.sh`): %d lines, none that does not agree.

## 5. The final readings (`final/9700x/`)

`final/9700x/FINAL/` (its patch on main `00faef7dd`'s lineage beside it, its build's log and its executable's hash)
and the piece before's executable's runs (`final/9700x/xu8/`): `builds/job-xb.sh`'s seven readings, the job the
session before started as it handed the work off (`final/9700x/job-FINAL.log`); `final/FINAL-table.txt` by
`builds/xb-table.py`. The patch's sources are the pull request's code's commit's with the experiment's switch and
three comments' wording apart: main `00faef7dd` with the patch, compared file by file with the commit. TSC ticks.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
''' % (probes['cases13'], probes['cases14'], listed14, sum(probes[k] for k in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12')), again)
text += measured.split('\n', 2)[2] + '''

**Against its gates** ([the specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405)):

''' + gates + '''

`final/generators/gen-docs.py` made the design's two sections of these files (`node-machine-section.md` and
`one-core-path-section.md` beside it are its templates; `values.json` its values), and `apply-docs.py` put them in
the docs. `gen-readme.py` made this file from its second section on, and `gen-body.py` the pull request's body and
the issue's note (`body-template.md`, `result-note-template.md`, `tests.md`); `assemble.sh` copied this session's
files here. The session before wrote the generators and their templates against the fifth build's readings; this
session ran them on the final ones, with the fault rounds' paragraph as the rounds went, the final build's line and
Lua's two runs' note added (the record's history has them as handed off, at `0c2e9decc`).

## 6. The cloud container's checks (`final/cloud-*`)

`final/cloud-checks/` (`checks-rows.sh`, on the commit in `revision.txt`: the pull request's code's commit, on the
main it was opened on, in the container of the session that took the work over; the session before ran the same on
its own commit, whose files are in this record's history at `0c2e9decc`): a native Release build; `test-checker`, its eight parts; the shadow with `--window-rows` and with
`--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the
default warnings and with `-Wall -Wextra` (`rows-counts.txt`); the shadow's other modes on `sqlite3.c` and Lua; the
self-check, the self-parse, the call graph's two; the ownership check; and the complete driver's lists and parse.
`progress.txt` has each one's status. All pass but the preprocessor's comparison with clang in the complete driver's
light list: %d of its %d units differ, each by where its line markers place a token and none by a token's count
(`complete-light-the-preprocessor-against-clang.txt`). The container's clang (23.1.6) names its resource directory
otherwise; the session before read the same of main in its own container.

`final/cloud-sanitizers/` (`sanitizers-parts.sh`, on the same commit, `progress-73b723aa9.txt`; and the session
before's pass on `9eb233772`, that code but for three comments, `progress-9eb233772.txt`): native memory, address and thread builds;
`test-checker` part 5 under each, and under memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua
and the compiler's own source. %s
''' % (differing, units, ('No report in either: ' + '; '.join(l for l in san if 'part5' in l).replace('test-checker: ', '') + '.') if san and all('reports 0' in l for l in san if 'status' in l and 'build' not in l) and any(l.startswith('all done') for l in san) else 'PENDING')
text += HANDOFF
#
final_label = sorted(k for k in functions if k not in ('xu8', 'xb1', 'xb2', 'xb3', 'xb4', 'xb5'))
assert len(final_label) == 1, final_label
text = text.replace('FINAL', final_label[0])
assert 'checker done: 8 of 8 parts with status 0' in checks and 'all done' in checks
open(record + '/README.md', 'w').write(text)
print('rounds', rounds, 'probes', probes, 'listed14', listed14, 'left', sorted(set(re.findall(r'@@(\w+)@@', text))), 'PENDING' in text)
