# The cycles #1141 added without instructions (#1233), 2026-11-04

Evidence for buster14a/buster#1233. It asks why #1141's merge (`4670b2eb`) took slightly more user cycles than its
first parent (`754475d4`) while retiring fewer instructions, as
[the #1057 record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/request-preparation-1057-2026-11-03)
found. Everything was measured on the locked 9700X.

**Result.** The excess comes from where the checker's hot code falls, not from the change's own work.

- **What moved.** #1141 changed the order in which clang emits the checker unit's functions. Its hot checker
  functions (`check_input_*`, `check_graph_*`) moved by 55,136 bytes (32 modulo 64), and the lowering's
  (`check_lower_*`, `check_program_emit_*`) by 62,928 bytes (16 modulo 64). Their instructions are the same in both
  executables, apart from addresses (`logs/layout/main-to-merge.txt`).
- **The excess at the merge's own placement.** The merge took more user cycles than main:
  - Lua's 33 units by `--lanes 1 -c`: +0.16% over four holds (+0.22%, +0.30%, −0.14% and +0.26%);
  - `sqlite3.c`'s `-c`: +0.34% over two holds;
  - Lua's units by `--lanes 1 -fsyntax-only`: +0.35% in one hold.

  It is front-end-bound: dispatch slots with no ops from the front end rose 0.8% to 1.1%, while the merge retired
  fewer instructions. Lua's units ran about 19,000 fewer. `sqlite3.c` ran 390 to 1,950 fewer, a number that depends
  on the run's paths (the #1057 record counted 397 more with its own). No single function holds the excess: the extra
  front-end samples spread a few at a time over the checker's hot functions.
- **The isolating control.** Each tree was built with its checker code moved by 16 to 4,032 bytes (main.c's one-line
  variant). Each tree's cycles then spread 0.23% to 0.81% over its eight offsets. In one hold (E3), the merge at
  offsets 16 and 32 was as fast as main as built, and main at offset 32 nearly as slow as the merge.

  Averaged over the same offsets, the merge minus main is:
  - Lua's `-c`: +0.059% ± 0.046% over four holds;
  - `sqlite3.c`'s `-c`: +0.036% ± 0.018% over two holds;
  - Lua's `-fsyntax-only`: −0.094% in one hold.
- **The tiny file.** With each build following each other one equally often (E1), the merge's tiny `-c` is within
  main against itself, and 1.6% faster when each process follows one of its own build. The #1057 record's +2.8%
  (main again +1.7%) came from a fixed order, in which every one of the merge's processes followed one of main's. It
  was also a 1-ms process, whose copies alone differ by 1% to 2%.
- **Why the #1057 record's placements missed it.** `./build.sh shifts` pads a unit's `.text`. The checker's code is
  in `.text.buster_checker`, which starts `.text` on a page, and the shifts don't move it.
  `logs/layout/shift-640-754475d4.txt` shows this: the shift moved 6,056 functions by 640 bytes and left the 1,920 in
  the page-aligned sections where they were. So its six placements sampled none of the checker's hot code.
- **Copies.** Fresh copies of one executable on tmpfs ran up to 0.6% apart from one hold to the next. On the home
  file system (btrfs), one copy of the merge's executable had ten times as many coalesced 4 KiB iTLB entries as
  main's copies, and half their iTLB misses (E1). Each hold's own error bars leave out this per-copy variance, so the
  results above are read over several holds.

## Source revisions and trees

- main: `754475d4cc8f27813cf0b2f029fbae0012ab11fe`, the first parent of #1141's merge.
- the merge: `4670b2ebf5ca104feb5c902015ad6a2179d8c2e7`.

Each tree is `git archive` of its commit, sent to the 9700X by tar. `trees/manifest-*.txt` (made before sending, `LC_ALL=C`
order) equal the host's (`trees/host-manifest-*.txt`, made before building): 1,083 and 1,087 files. Both were built as
the #1057 record built them, `BUSTER_DEBUG_INFO=0 ./build.sh` (`-march=native`, znver5 there), each in its own hold of
the lock (`scripts/build.sh`, `logs/build-*.log`). They reproduce the #1057 record's executables byte for byte:
`6efbc0e3…` and `f965fa35…` (`logs/receipts.txt`).

The variant trees (`var-*`, manifests `trees/host-manifest-var-*.txt`) are the same trees with one line of `main.c` changed
(`scripts/variant-*-main.c.diff`): the asm that starts `.text.buster_checker` on a page also skips
`BUSTER_CHECKER_SKIP_TEXT` bytes of `int3`, a string the build passes through `BUSTER_BUILD_DEFINES`
(`-DBUSTER_CHECKER_SKIP_TEXT="N"`). The line count is unchanged. At N = 0 each variant tree's executable equals its
measured tree's byte for byte (`logs/receipts.txt`). At the other offsets (`logs/layout/variants.txt`):

- the checker unit's `.text.buster_checker` moves by N (1,021 to 1,076 functions);
- the other units' small `.text.buster_checker` sections move by N plus whole pages;
- everything else moves by whole pages only, or not at all.

Each variant was built in its own hold (`scripts/e3-build.sh`, `scripts/e4-build.sh`, `logs/e3-build-*.log`, which
keep only `build.sh`'s own lines).

## Host

Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, transparent huge pages `always`. CPU 2's governor and
EPP are `performance`; CPUs 0, 1 and 3 to 7 run `powersave` with `balance_performance` (`logs/receipts.txt`). The NMI
watchdog holds one core counter, so each process counts at most five core events, none multiplexed (every line's
running share is 100%, which the analyses check). Every timed process ran on CPU 2 (`taskset -c 2`), under `perf
stat` or `perf record` started there.

Each run's first action in its hold was to append the lock's owner line to `logs/holds.txt`: all 29 lines are this
record's (`claude-1233`). Run logs keep only the lines the record's own tools print. The lock's waiting messages,
which name other sessions, are left out.

## Inputs

- the tiny file: `int main(void) { return 0; }` on four lines, as the #1057 record's `inputs/tiny.c`;
- Lua 5.4.8's 33 units except `luac.c`, with `-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w`. The host's copy's
  `sha256sum`s (`logs/receipts.txt`) equal the #1057 record's `logs/lua-sources.txt`;
- the frozen corpus's `sqlite3.c` (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), with its pinned
  predefines and headers, as the #1057 record passed them.

Every build's `-c` objects are the same: Lua's 33 by all three of E1's executables and by all sixteen of E4's
(`logs/receipts.txt`: one digest of the 33 objects per executable, all equal).

## Experiments

All of them use whole processes, interleave the executables run by run, and discard one warm-up per executable
before each series.

- **E1, counters** (`scripts/e1.sh`, `scripts/e1-run.sh`; `logs/e1/*.csv`, `logs/e1/analysis-*.txt`). Three
  executables: main (`M`), the merge (`H`), and main again (`A`), a byte-identical copy at a path of the same length.
  Their order rotates by run over three, so each build follows each other one. Each process counts one group of
  events:
  - group 0: cycles, instructions, the two dispatch-slot events, mispredictions, page faults;
  - group 1: instruction-cache, op-cache and iTLB misses;
  - group 2: taken branches, decoder redirects, coalesced iTLB entries, data TLB misses.

  The series:
  - the tiny file's `-c`, 100 runs per group, from copies on the home file system (btrfs) and from fresh copies on
    tmpfs (`/tmp`);
  - a primed series: each measured process right after an unmeasured one of the same file, of a byte-identical copy,
    or of the other tree, 60 runs per group and kind;
  - Lua's `--lanes 1 -c`, 21 runs per group, from the home copies.

  The tiny hold's first attempt counted nothing (a shell error, `$6` read after `shift`; `logs/holds.txt`'s
  14:38:00 line), and was run again after the fix.
- **E2, samples** (`scripts/e2.sh`, `scripts/e2-run.sh`, `scripts/e2_reduce.py`, `scripts/e2_analyze.py`;
  `logs/e2/`). `perf record` of three sampled events at once, each under the host's rate cap (63,300 a second):
  - cycles, period 200,003;
  - slots with no ops from the front end, period 800,011;
  - op-cache misses, period 40,009.

  It ran over 30 processes per executable of Lua's `--lanes 1 -c`, rotated. `perf script -F event,ip,dso` was run
  where the record was written. Each sample's function comes from each executable's `nm -n -S`, keyed by name and
  occurrence: static copies share names. `logs/e2/functions.csv.gz` holds every process's samples by event and
  function; the `perf.data` files stay on the host.
- **E3, the checker's code at four offsets** (`scripts/e3.sh`, `scripts/e3-run.sh`; `logs/e3/`). Each tree's
  executables at offsets 0, 16, 32 and 48 (`M00` to `H48`), two fresh tmpfs copies each, 16 executables rotated by run.
  `perf stat` counted cycles, instructions, front-end-starved slots, op-cache misses and backend-stalled slots. The
  series: Lua's `-c` (10 runs) and `sqlite3.c`'s `-c` (6 runs), in two holds.
- **E4, eight offsets** (`scripts/e4-build.sh`, `scripts/e4.sh`, `scripts/e4-run.sh`; `logs/e4/lua.csv`,
  `logs/e4/sqlite.csv`). Four more offsets per tree, spread over the page, one in each class modulo 64: 1040, 2080,
  3120 and 4032. Then all sixteen executables (`M0000` to `H4032`), two fresh copies each, measured as E3 measured
  them.
- **E5, repeats** (`scripts/e5-run.sh`; `logs/e4/lua2.csv`, `lua3.csv`, `lua-syntax.csv`). E4's Lua `-c` twice more,
  each hold with fresh copies, and Lua's `--lanes 1 -fsyntax-only` once. `e4.sh` gained the `lua2`, `lua3` and
  `lua-syntax` cases for this after E4 had run; its `lua` and `sqlite` cases are unchanged.

`logs/summary.txt` (`scripts/summary.py`) gives, per hold, the as-built pair (the merge at offset 0 against main at
offset 0, paired by run) and the merge minus main over all the offsets that hold measured (paired by run and copy). It
also gives the mean of the holds with its standard error.

## Results

### Lua's `--lanes 1 -c`, E1 (copies on the home file system)

| event | main (median) | the merge against main | main again against main |
| --- | ---: | --- | --- |
| user cycles | 321.5 M | +0.26%, +0.22%, +0.11% (paired +741 K ± 165 K, +703 K ± 120 K) | +0.05%, −0.02%, −0.02% |
| instructions | 847.81 M | −18,250 | +564 |
| slots with no ops from the front end | 1,035.4 M | +0.79% (+8.40 M ± 0.38 M) | +0.08% |
| backend-stalled slots | 504.8 M | −0.36% | +0.10% |
| op-cache misses | 47.34 M | +0.32% | −0.26% |
| instruction-cache misses | 39.36 M | −0.41% | −0.46% |
| iTLB: L1 miss, L2 hit / L2 miss | 615 K / 39.2 K | −79% / −52% | +0.2% / +0.1% |
| coalesced 4 KiB iTLB entries | 1,912 | 18,600 (×9.7) | −0.5% |
| mispredicted / taken branches | 2.66 M / 68.41 M | −339 / −7,120 | −652 / +43 |

The iTLB rows are the merge's copy's physical pages, not its code. With copies on tmpfs, the tiny file's iTLB misses
and coalesced entries were the same for every build (E1's tmpfs series), and E3 to E5 ran from tmpfs. Without that
advantage, the merge's copy here would likely have been slower still.

### Where the extra front-end slots are, E2

Per process, the samples of slots with no ops from the front end were main 1,393.0, the merge 1,403.1 and main again
1,396.1. Cycles' samples were 1,665.6, 1,668.4 and 1,667.6, and op-cache misses' 1,221.9, 1,227.5 and 1,220.2. The
largest per-function differences are a few samples per process, spread over the checker's hot functions in both
directions:

- `check_input_declarator_step` +4.0 (+6.3%), its start moved from 32 to 0 modulo 64;
- `check_graph_run` +2.6;
- `check_input_run` −2.3, moved from 0 to 48.

The preprocessor's functions moved by a whole number of pages (`pp_*`, 0x4000) and show only main-again-sized
differences. No function holds the excess (`logs/e2/analysis.txt`).

### The checker's code at eight offsets, E3 to E5

User cycles against main at offset 0, paired by run, both copies:

| offset | 0 | 16 | 32 | 48 | 1040 | 2080 | 3120 | 4032 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Lua `-c`, E3: main | 0 | −0.09% | +0.17% | −0.05% | | | | |
| Lua `-c`, E3: the merge | +0.22% | −0.02% | −0.08% | +0.22% | | | | |
| Lua `-c`, E4: main | 0 | +0.23% | +0.48% | +0.11% | +0.41% | +0.54% | +0.08% | −0.01% |
| Lua `-c`, E4: the merge | +0.30% | +0.43% | +0.57% | +0.29% | +0.31% | +0.44% | +0.78% | +0.13% |

The same executables moved by up to 0.6% between E3 and E4: each hold makes fresh copies, so each executable's level
carries its copies' physical pages. Read across holds (`logs/summary.txt`):

| command | holds | the merge as built, against main as built | the merge minus main over the offsets | each tree's offsets spread |
| --- | ---: | --- | --- | --- |
| Lua `--lanes 1 -c` | 4 | +0.157% ± 0.101% (+0.218, +0.295, −0.143, +0.257) | +0.059% ± 0.046% (+0.075, +0.175, +0.030, −0.043) | 0.28% to 0.81% |
| `sqlite3.c` `-c` | 2 | +0.339% ± 0.049% (+0.388, +0.290) | +0.036% ± 0.018% (+0.054, +0.018) | 0.23% to 0.53% |
| Lua `--lanes 1 -fsyntax-only` | 1 | +0.353% ± 0.091% | −0.094% ± 0.021% | 0.53% to 0.76% |

Within a hold, each tree's instructions are the same at every offset. The merge retires 18,950 to 19,900 fewer for
Lua's commands. For `sqlite3.c`'s `-c` it retires 390 fewer in E3 and 1,955 fewer in E4: the difference depends on the
hold's paths. Over the offsets, front-end-starved slots differ by +0.71%, +0.20% and +0.03% in E4 and E5's
two Lua `-c` holds, and the merge's op-cache misses by −0.14% in E4: neither is a consistent excess once the placement varies
(`logs/e4/analysis-*.txt`).

### The tiny file's `-c`, E1

| series | the merge against main, user cycles (median; paired mean) | main again against main |
| --- | --- | --- |
| home copies, groups 0, 1, 2 | +0.11%, +0.19%, +0.32% (−6.4 K ± 8.2 K, −5.1 K ± 9.1 K, +0.8 K ± 9.1 K) | +0.06%, +0.74%, +0.44% |
| tmpfs copies, groups 0, 1, 2 | −0.91%, −1.94%, −1.28% | −0.95%, −1.75%, −0.95% |

The primed series measured against main after main. The merge after itself read −1.60% (paired −21 K ± 12 K), after
its copy −2.03%, and after main −1.92%. Main after its copy read −0.03%, and after the merge +0.20%. Instructions:
the merge −987 (1,531,300 for main).

At about 1.9 M user cycles, the tiny file's processes vary by 1% to 2% between copies of one executable. E1's tmpfs
series shows this: main's copy was the slowest of three, the merge's and main's other copy alike.

## What the #1057 record's method missed

- **The checker's code didn't move.** Its placements shifted `main_unit_checker.c` with `./build.sh shifts`, which pads
  the unit's `.text`. Since #502, the checker's code is in `.text.buster_checker`, which every unit starts on a page,
  and wild places page-aligned sections first. The checker's hot code, and the other page-aligned code at the start
  of `.text`, stayed where it was in all six placements (`logs/layout/shift-640-754475d4.txt`). The placements varied
  only what wild put after the unit's `.text`: the backend, encoder and Tier 0 code, among others.
- **Each process had the same predecessor.** `time-runs` rotates the first slot of each run by one, but runs the slots
  in the same cyclic order every time. In the record's `placements.log`, the merge's processes followed main's 645
  times out of 650, main again's followed the merge's, and main's followed main again's at the previous placement.
  For the tiny file that order read the merge +2.8% and main again +1.7%. With the order rotated over three builds,
  so that each follows each other one, E1 read the merge within main against itself. E1's primed series doesn't single
  out the predecessor's tree as the cause: main after the merge and main after its own copy differ by 0.2% in median.
  The tiny file's copies alone differ by 1% to 2%.
- **Placements were multiples of 64.** Even for the code they moved, the record's shifts (0 to 3,456 in steps of 640
  or so, multiples of 64) left every function at its offset modulo 64. That is where the checker's hot code differed
  between the two builds.

## Not done

Optional item 4 of the issue, the attribution of `benchmark-lowering-source`'s +4,505,849 instructions to its
preparation's selection, wasn't measured.

## Limitations

- One host, one CPU (2). The 9700X was shared through its lock with CI and other sessions between holds, never during
  one.
- Eight offsets sample the checker section's start modulo 64 and modulo the page (two per class modulo 64). They don't
  sample the merge's new order of the checker's functions relative to each other: the section moves as a whole in
  both trees. Over the offsets, the difference that remains is within about one standard error over holds for Lua's
  `-c`, and two for `sqlite3.c`'s.
- Each executable's level carries its copies' physical pages. Two copies per executable and hold, over two to four
  holds, bound the trees' means over offsets to about ±0.05%; a smaller difference isn't resolved.
- Lua's `-fsyntax-only` has one hold.
- The tiny file's E1 used copies at fixed paths and three executables, not placements.
