#!/usr/bin/env python3
# gen-readme.py RECORD TREE: the record's README (RECORD/README.md): its first section, kept as it is, then the builds,
# the faults, the probes, the final readings and the cloud container's checks, with the tables and the gates of
# the design's section in TREE's docs/node-machine.md (gen-docs.py's, put there by apply-docs.py) and counts read from
# the record's own files.
import glob, re, statistics, sys
record, tree = sys.argv[1], sys.argv[2]
readme = open(record + '/README.md').read()
head = readme[:readme.index('\n## 2. ')] if '\n## 2. ' in readme else readme.rstrip('\n') + '\n'
docs = open(tree + '/docs/node-machine.md').read()
section = docs[docs.index("### An update's rows on the window\n"):docs.index('### What it says of step 2\n')]
def between(start, end):
    a = section.index(start); b = section.index(end, a)
    return section[a:b].strip('\n')
builds_table = between('| build |', '\n\n- **A shape chosen')
builds_notes = between('- **A shape chosen', '\n\n**Measured.**')
measured = between('| | `sqlite3.c` | Lua | musl |', '\n\n**Against its gates.**')
gates = between('- **U1, exact', '\n\n**What stays')
def verdicts(path):
    t = open(path).read().splitlines()
    return len([l for l in t if l.startswith('caught ')]), [l.split()[1] for l in t if l.startswith('SURVIVED ')], len(t) - 1
rounds = [verdicts(p) for p in sorted(glob.glob(record + '/faults/round*.txt'))]
syntax = open(record + '/faults/syntax-round1.txt').read().splitlines()
probes = {name: len(open('%s/probes/%s.txt' % (record, name)).read().splitlines()) for name in ('earlier', 'cases9', 'cases10', 'cases11', 'cases12')}
def differing(path):
    return len([l for l in open(path).read().splitlines() if re.search(r'entries \d+ diff [1-9]', l)])
eight = {name: (differing('%s/faults/eight/mutant-%s.txt' % (record, name)), probes[name]) for name in ('cases11', 'cases12')}
assert eight['cases11'][0] == 0 and eight['cases12'][0] > 0, eight

def wall(mode):
    return statistics.median(int(re.search(r'wall-ns (\d+) status 0', open('%s/throughput/%s-%d.txt' % (record, mode, k)).read()).group(1)) for k in (1, 2, 3))
log = open(record + '/throughput/throughput-xr10.log').read()
size = int(re.search(r'bytes (\d+) lines', log).group(1)); pre = int(re.search(r'preprocessed bytes (\d+)', log).group(1))
tokens = int(re.search(r'time-process\ttokens\t(\d+)', open(record + '/throughput/object-2.txt').read()).group(1))
stages = dict(re.findall(r'^time-stage\t([a-z0-9.-]+)\t([\d.]+)', open(record + '/throughput/object-2.txt').read(), re.M))
check = sum(float(stages[k]) for k in ('check-input', 'check-expressions', 'check-declarations', 'check-program'))
total = float(stages['total'])
san = open(record + '/final/cloud-sanitizers/progress.txt').read().splitlines() if glob.glob(record + '/final/cloud-sanitizers/progress.txt') else []
san_final = open(record + '/final/cloud-sanitizers/progress-final.txt').read().splitlines() if glob.glob(record + '/final/cloud-sanitizers/progress-final.txt') else []
def listing(name):
    return [re.sub(r'-?0x[0-9a-f]+\(%rip\)', 'X(%rip)', l) for l in open('%s/final/%s' % (record, name)).read().splitlines() if l]
assert listing('rows-functions-baa0d0e26.s') == listing('rows-functions-9efc8650b.s')
listing_lines = len(listing('rows-functions-9efc8650b.s'))
checks = open(record + '/final/cloud-checks/progress.txt').read()
text = head.rstrip('\n') + '''

## 2. The builds, and how it came to its cost (`builds/`)

Six builds before the fault rounds and one beside the first (`builds/9700x/xuN/`, each with its patch on main
`903bf7ef4`, `xuNx.patch`: the piece's source at that point and an experiment's switch, `BUSTER_TESTS_SKIP=1`, with
which an update's template lists its expression as the piece before had it). `builds/job-xu.sh` builds one and reads
it: in each reading that executable with the update's rows on, off, the piece before's executable (`xr10`, the record
before this one) twice, then off and on, on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of the lock.
`builds/xu-table.py` makes a build's table (`builds/xuN-table.txt`), `builds/builds.py` a line a build and
`builds/builds-detail.py` each part's (`builds/builds-detail.txt`); `builds/make-switch-patch.sh` made the patches.
TSC ticks a record swept, three readings a build (seven for the last line, section 5):

''' + builds_table + '''

`xu7` is the last line's code read while the first fault round ran on the 9700X: its runs came between that round's
builds, and Lua's read +1.46 for it; it is no line of the table.

''' + builds_notes + '''

## 3. The faults (`faults/`)

Each term of the updates' loop's bits and shapes, each of its stores, the list's sweep, the rows' write's new
resolutions and marks, and each new row of the tables, changed alone (`faults/make-faults-round1.py` makes
`faults-update-round1.py`, the first round's list; `faults/make-faults.py` makes `faults-update.py`, the later
rounds'). Each fault was compiled first with `-fsyntax-only` (`faults/syntax-check.sh`,
`faults/syntax-round1.txt`: %d of %d built, and the three that did not, for a variable left without a use, were
rewritten). Then on the 9700X (`faults/job-faults-update.sh`, and `job-faults-update2.sh` from the second round, which
restores C's loop's file too): a tree of its own with the round's patch on main `903bf7ef4` (`faults/xufN.patch`), the
tree as it is first, which must pass, then a Develop build and `test-checker --seed 133 --part 5/8` a fault, each its
own hold of the lock. A line a fault in `faults/roundN.txt`.

| round | faults | caught | survived |
| --- | ---: | ---: | --- |
''' % (len([l for l in syntax if l.startswith('ok ')]), len(syntax))
for i, (caught, survived, lines) in enumerate(rounds):
    text += '| %d | %d | %d | %s |\n' % (i + 1, caught + len(survived), caught, ', '.join('`%s`' % x for x in survived) if survived else 'none')
text += '''
- `loop-own-pointer-converted` gives a pointer's own row a CONVERT. No pointer's update has one (its computation is
  its own class's, by C's masks), so the fault changes nothing a program reaches; it is not in the later lists.
- `loop-first-length-swapped` swapped a row's two parts' lengths. No one read them apart: the write and the comparison
  read their sum. They became a row's entries' number, one byte.
- `list-not-evaluated` let the list take records that are not evaluated. The three corpora and the compiler's own
  source read the same with it (`faults/unevaluated/*.lines`), and so did 30 one-statement programs
  (`faults/unevaluated/cases10.py`, `base.txt` and `mutant.txt`). The case exists all the same: a folded `&&`'s dead
  operand has the update's template and is not evaluated, and C lists its expression, so no tape is compared; the
  mutant writes 6 entries for `return 0 && a++;`'s records where the code writes 1. The fixture got two such lines,
  and its pin of the entries written catches the fault.
- `length-low-bits` read a row's entries' number by its low three bits: a row of eight reads as none. It survived
  the second round and the third. The line the fixture got after the second
  (`_Bool told = (char)(long)&global_outer.inner.second;`; `probes/cases11.py` has its kind) was written from the
  tables, an address constant's own four entries and a narrow class's conversion to bool's four, and was not run
  against the fault. Run against it (`faults/eight/`: the fault's build, `mutant-cases11.txt`), none of the %d
  cases differs: no expression there has a row of eight at its last record. By the tables the address constant is the
  cast to `long`'s record, of four entries, and the cast to `char` a record of its own, its CONVERT and the
  conversion's four; the cases' entries' numbers agree with that. An update's row does have eight
  (`probes/cases12.py`, `faults/eight/mutant-cases12.txt`): a narrow destination's `++` or `--` (its CONST, the
  operation, the CONVERT back and the store) whose value is converted to bool, four more, where that record is an
  expression's last (an initialization's, a `return`'s). %d of the %d cases differ under the fault; the others have a
  last record of six or seven entries, or the eight at a record that is not the last. The fixture's line is
  `_Bool told = ++c;` now, in place of the other (`faults/eight/fixture-eight.py`; `part5-mutant.err` is the fault
  caught by it in the cloud container), and the fourth round ran on that.
- `chunk-updates-of-two` and `chunk-updates-count-of-the-asked` skip the updates' sweep in a chunk with one update:
  the fixture got a unit of one chunk with one update.
''' % (eight['cases11'][1], eight['cases12'][0], eight['cases12'][1])
text += '''
## 4. The probes (`probes/`)

One-statement programs, each a file of its own through `measure-node-machine --shadow --window-rows --passes 0`
(`probes/probe.py COMPILER CASES`), on the final build in the cloud container: %d of the first piece's
(`probes/earlier.txt`; their cases are in the record before this one), %d of an update's cases (`probes/cases9.py`),
%d of updates that are not evaluated (`cases10.py`), %d of an address constant's cast converted to bool (`cases11.py`)
and %d of an update's value converted to bool (`cases12.py`: a row of eight entries at an expression's last record).
Every one reads as X on T's columns does: no tape differs, and no answer of C's.

## 5. The final readings (`final/9700x/`)

`final/9700x/xu8/` (its patch `xu8x.patch` on main `903bf7ef4`) and the piece before's executable's runs beside it
(`final/9700x/xr10/`), `builds/job-xu.sh`'s seven readings with no other job of this session's on the 9700X;
`final/xu8-table.txt` by `builds/xu-table.py`, `final/xu8-numbers.txt` by `builds/piece-numbers.py`. TSC ticks.

''' % (probes['earlier'], probes['cases9'], probes['cases10'], probes['cases11'], probes['cases12']) + measured + '''

**Against its gates** ([the specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7030649938)):

''' + gates + '''

`final/gen-docs.py` made the design's two sections of these files (`final/node-machine-section.md` and
`final/one-core-path-section.md` are its templates), and `final/apply-docs.py` put them in the docs.
`final/gen-readme.py` made this file from its second section on, and `final/gen-notes.py` and `final/gen-body.py` the
pull request's body and the issue's note of the docs' sections (`final/body-template.md`,
`final/result-note-template.md`).

## 6. The cloud container's checks (`final/cloud-*`)

'''
text += '''`final/cloud-checks/` (`checks-rows.sh`, on the commit in `revision.txt`: the pull request's sources, on the main it
was opened on): a native Release build; `test-checker`, its eight parts; the shadow with `--window-rows` and with
`--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the
default warnings and with `-Wall -Wextra` (`rows-counts.txt`); the shadow's other modes on `sqlite3.c` and Lua; the
self-check, the self-parse, the call graph's two; the ownership check; and the complete driver's lists and parse.
`progress.txt` has each one's status. All pass but the preprocessor's comparison with clang in the complete driver's
light list, which fails in this container on main too (its system clang is 23.1.6).

`final/cloud-sanitizers/` (`sanitizers-parts.sh`): native memory, address and thread builds. On the commit before the
fixture's last line (`progress.txt`): `test-checker` part 5 under each, and under memory and address the shadow with
`--window-rows`, `--window-contexts` and `--window-tests` on `sqlite3.c`, Lua and the compiler's own source. On the
pull request's sources (`progress-final.txt`): `test-checker` part 5 under each, and under memory and address the
shadow with `--window-rows` on the three. %s

The 9700X's readings (section 5) and the first sanitizer pass are of the piece before the fixture's last line. The
readings' executable has the pull request's sweeps' source with the experiment's switch in three places (its patch is
in `final/9700x/xu8/`), and the first pass's commit has that source as it is.
`final/rows-functions.sh` lists a build's rows' functions' instructions without their addresses: that commit's native
Release build's (`final/rows-functions-baa0d0e26.s`) and the pull request's sources' (`final/rows-functions-9efc8650b.s`)
are the same line for line, but for the displacements of their RIP-relative operands (%d lines each; the check's command is in the
script).

## 7. The compile's speed, asked while this ran (`throughput/`)

`throughput/throughput.sh xr10`: the piece before's executable (main `903bf7ef4`'s compile, which takes none of the
window's work) on `sqlite3.c`, CPU 2, each run its own hold of the lock, three runs each of `-fsyntax-only` and `-c`
with `--time-stages`. The file is %s bytes (%s preprocessed, %s tokens).

| | median | of the file | 1 GB/s of the file is %.1f ms |
| --- | ---: | ---: | ---: |
| `-c` | %.1f ms | %.1f MB/s | %.1f times away |
| `-fsyntax-only` | %.1f ms | %.1f MB/s | %.1f times away |

`-c`'s stages in its second run, of %.1f ms: checking %.1f (%.0f%%), lowering %.1f (%.0f%%), preprocessing and parsing
%.1f (%.0f%%), Tier 0 %.1f.
''' % ((('No report in either: ' + '; '.join(l for l in san_final if 'part5' in l).replace('test-checker: ', '') + '.') if san and san_final and all('reports 0' in l for l in san + san_final if 'status' in l and 'build' not in l) else 'PENDING'), listing_lines,
       '{:,}'.format(size), '{:,}'.format(pre), '{:,}'.format(tokens), size / 1e9 * 1e3,
       wall('object') / 1e6, size / (wall('object') / 1e9) / 1e6, (wall('object') / 1e9) / (size / 1e9),
       wall('syntax') / 1e6, size / (wall('syntax') / 1e9) / 1e6, (wall('syntax') / 1e9) / (size / 1e9),
       total, check, 100 * check / total, float(stages['lower']), 100 * float(stages['lower']) / total,
       float(stages['preprocess']) + float(stages['parse']), 100 * (float(stages['preprocess']) + float(stages['parse'])) / total, float(stages['tier0']))
open(record + '/README.md', 'w').write(text)
print('rounds', rounds, 'probes', probes, 'left', sorted(set(re.findall(r'@@(\w+)@@', text))), 'PENDING' in text)
