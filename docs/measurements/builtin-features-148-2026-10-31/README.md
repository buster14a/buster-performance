# The builtins' required target features, Buster #148 and #775

Compiler branch: `claude/148-builtin-target-features` of buster14a/buster, for
[this claim on #775](https://github.com/buster14a/buster/issues/775#issuecomment-6541522441), part of
[the #148 claim](https://github.com/buster14a/buster/issues/148#issuecomment-6525264816).

Clang's code generation refuses a call of an x86 builtin whose required features the calling function lacks, at `-c`
and when it links (`'__builtin_ia32_palignr128' needs target feature ssse3`), and refuses SSE's compares
(`__builtin_ia32_cmpps`, `cmpss`, `cmppd` and `cmpsd`) of a predicate past 7 in a function without AVX the same way.
The branch makes `-c` and the direct path make that check after selection, in the check of target features that #775
added. This record keeps:

1. the cost on the 9700X: `-c` of the frozen `sqlite3.c`, a unit without a target attribute or an x86 builtin's call,
   which the check skips, and of stb_image at `-march=native`, whose `<emmintrin.h>` intrinsics call x86 builtins,
   which the check now reads: main against the head by instructions and with one executable per tree (`first/`), and
   by time over six placements of the checker's unit (`placements/`);
2. the mutation check of the new rules' tests (`mutants/`).

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **base:** `e52d16c1ccc350d2f8da55e6aa1e8b361f398b43`, main, the branch's base;
- **head:** `c1167e17108562fd41c4a12adb96dc30f8dd69c7`, the branch's one commit.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path in the C
locale), and `manifests/compare.txt` the comparison with the trees on the 9700X: the same 836 files and bytes, but for
`build/`, `COMMIT` and `build.log`. stb_image is the unit of [buster#759's record's survey](../sse-builtins-148-2026-10-28/survey/)
and [#775's record](../target-features-775-2026-10-29/README.md): `stb/stb_image.c` (SHA-256 `40bcca3e…`) includes
`stb_image.h` (`594c2fe3…`, stb_image 2.30) with `STB_IMAGE_IMPLEMENTATION`, copied from #775's directory on the
9700X; `first/measure.log` has both files' SHA-256.

## Method

As in [#775's record](../target-features-775-2026-10-29/README.md): `scripts/queue.sh` built each tree
(`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds) and ran `scripts/measure.sh`, each
in a hold of the host's lock of its own. `measure.sh` takes two trees and, in one hold, logs the receipts (the date,
`uname -a`, the CPU, CPU 2's governor, clang's and perf's versions, the lock's owner line, the trees' commits, and the
SHA-256 of both executables and of the inputs), compiles each unit with each tree once (its status, and the two objects
compared), then runs 8 rounds in which each tree, in an order alternated by round, compiles each unit 3 times under
`perf stat -e instructions:u,cycles:u,task-clock`, pinned to CPU 2, each run's exit status beside its counters. The
units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is `first/analysis-*.txt`.

Then `scripts/placements.sh`, the comparison over placements and copies of buster's `docs/profiling.md` ("Comparing
two versions", #509): each tree built with its checker's unit (`main_unit_checker.c`) shifted by 0, 688, 1,376, 2,064,
2,752 and 3,440 bytes (`./build.sh shifts`, each build in a hold of its own; `placements/shifts-*.log` has each status
and executable's SHA-256), then `ab --rounds 3` running `time-runs --runs 3 --copies 3`, each process in a hold of its
own: every placement of base, head and base again (the comparison's floor), each from three fresh copies, for each
unit, into `placements/placements-*.log`.

The lock's waiting messages went to separate `.stderr` files, which this record leaves out, as they name other jobs.
`ab` printed one waiting line into `placements-sqlite.log`, without a holder's details: the placement logs keep only the
lines the tools print (`run N list`, `list N`, the builds' summary lines, `time-runs:`, `== round`, `memory:`,
`placements` and `ab:`), 683 of its 684 lines.

## Results

Every build exits 0 (`first/build-*.log`, with each executable's SHA-256), every timed run and process exits 0, and
both trees write the same objects, byte for byte, for both units (`first/measure.log`).

With one executable per tree: the medians of the rounds' means' differences, and for the times the per-round ratios'
median and range:

| `-c` of | instructions | cycles | task clock |
|---|---:|---:|---:|
| `sqlite3.c` | −44,393 (−0.0033%) | +0.29% (−0.08% to +0.64%) | +0.32% (+0.07% to +0.89%) |
| stb_image `-march=native` | +43,021 (+0.023%) | +0.35% (−0.38% to +0.97%) | +0.22% (−0.85% to +0.84%) |

Main's medians are 1,340,188,443 instructions, 603.2 M cycles and 128.10 ms for `sqlite3.c`, and 188,979,748
instructions, 70.9 M cycles and 18.65 ms for stb_image. A tree's instructions vary by at most 23 (`sqlite3.c`) and
2,878 (stb_image) within a round.

Over the placements, user cycles, each round's median against base's, with its range over the placements:

| `-c` of | round | head | base again |
|---|---|---:|---:|
| `sqlite3.c` | 1 | +0.41% (−0.00% to +0.73%) | −0.03% (−0.42% to +0.41%) |
| | 2 | +0.33% (−0.14% to +0.59%) | −0.01% (−0.52% to +0.35%) |
| | 3 | +0.28% (−0.06% to +0.63%) | −0.01% (−0.48% to +0.26%) |
| stb_image `-march=native` | 1 | +0.67% (+0.07% to +1.17%) | +0.18% (−0.43% to +0.56%) |
| | 2 | +0.39% (−0.09% to +1.01%) | −0.05% (−0.60% to +0.32%) |
| | 3 | +0.25% (−0.09% to +0.90%) | −0.13% (−0.54% to +0.56%) |

and wall time: `sqlite3.c` +0.26%, +0.26% and +0.20% (base again −0.06%, +0.02% and −0.04%), stb_image +0.40%, +0.45%
and +0.21% (base again +0.09%, −0.14% and +0.21%).

## Reading

`sqlite3.c` has neither a target attribute nor an x86 builtin's call, so the check doesn't run on it: the head runs
44,393 fewer instructions, from code generation's choices around the changed functions, and writes the same object.
Its +0.3% cycles in every round, at every placement, isn't work. These placements don't vary where its checker code
lands: the checker's sources are in a section that starts on a page (buster #502), which the shifts' padding doesn't
move, and the new code sits in that section before the lowering and the emission. Those moved by 8,320 bytes, two pages
and 128 bytes (`check_program_emit` from `0x952720` to `0x9547a0`), while the lexer, the preprocessor and Tier 0 moved by
whole pages (12,288 bytes: `c_tokenize` from `0xb2c1c0` to `0xb2f1c0`). Another compile of the same work costs up to 0.7%
more cycles by where its code lands:
[#136's switch tables record](https://github.com/buster14a/buster-performance/tree/6328c2664043f54076850f6c03c5a580ab5bfeb2/docs/measurements/switch-tables-136-2026-10-26)'s
executable doing main's work in 530,922 fewer instructions took 0.73% more cycles in every round. This record didn't
build a control of the same layout without the change, so the 0.3% is attributed to layout by the instructions and the
addresses, not measured apart.

stb_image's +43,021 instructions (+0.023%) are the check's work: its pre-pass reads each x86 builtin's call of the unit
(clang's headers' inline functions hold one each), whose feature expressions' answers it keeps per expression and map.
Its cycles are that work and the same layout.

## Mutation check

`mutants/run.sh` applied each mutant of `mutants/apply.py` to the head's `c_check_target_feature.c` and
`c_checker_driver.c` (SHA-256 `db2625bd…` and `87d98ae8…`, `git show c1167e17:` of each), built, and ran
`test-checker-driver --executable ./build/compiler`, on the 7940HS (Zen 4, clang 23.1.4), restoring the files after
each. The first run (`mutants/run-first.log`), with the test file before the head's last fixture:

| mutant | what it breaks | failures |
|---|---|---:|
| `no-predicate` | no compare error | 16 |
| `prepass` | the pre-pass doesn't count a compare's error, so the body isn't walked | 14 |
| `one-error` | one error per call | 1 |
| `order` | the builtin's own features before the compare's | 1 |
| `boundary` | `>= 7` | 1 |
| `unit-map` | the compare's check by the unit's features, not the function's | 0 |
| `names` | `__builtin_ia32_cmpsd` not one of the compares | 5 |
| `message` | the builtin's own expression printed for the compare's error | 16 |

`unit-map` survived: no fixture made the check walk a function whose attribute adds AVX and whose compare is past 7,
as the pre-pass walks a body only for a call that fails. The head adds "a compare of a predicate past 7 in a function
whose attribute adds AVX, which another builtin's error walks", which fails it (`mutants/run-unit-map-rerun.log`).

## Limitations

- The time differences are of one layout of each tree's checker section; the instructions are the precise comparison.
- The mutants and the head's tests ran on the 7940HS (Zen 4), not the 9700X; the 9700X ran the builds and the timings.
- `perf stat` counted user-mode events of the whole process; the check's own share was not sampled apart.
