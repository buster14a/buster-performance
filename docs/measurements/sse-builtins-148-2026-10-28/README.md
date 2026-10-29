# The SSE builtins the corpora call, Buster #148

Compiler branch: `claude/sse-builtins-148` of buster14a/buster, for
[this claim on #148](https://github.com/buster14a/buster/issues/148#issuecomment-6482945766).

The branch adds 8 SSE builtins to the checker's frozen x86 scope, with
SemaX86's ranges for their immediates, and 14 rows to the lowering's x86
table. This record keeps four things:

1. the 9700X's regeneration of the own-main inventory from the pinned clang
   23.1.1 inputs (`inventory/`, `scripts/regenerate.sh`);
2. the default path's cost: `-c` of the frozen `sqlite3.c`, main against the
   head (`measure.log`, `scripts/`);
3. where stb_image, dr_flac, dr_mp3, minimp3 and xxhash stop on main, with the
   branch, and with the branch and #741's diff (`survey/`);
4. the mutation check of the new rows' tests (`mutants/`).

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X:

- **base:** `9bb5060ebe347de5c7a0a92ba325a7b14a567788`, main, the branch's
  merge-base;
- **head:** `14f7ed5260ddc85d405ef4bdea6635a2f4827b3c`, the branch's head.

## The inventory's regeneration

`scripts/regenerate.sh` ran on the 9700X with the generator's source
(`tools/clang_builtin_metadata.c`, SHA-256 `8b0b0a41…`) and the branch's
`own-main.names.txt` (`1b7a7b31…`, 1,543 names). Each step took a hold of the
host's lock of its own. `inventory/receipts.txt` is the script's whole
transcript:

- the host, clang 23.1.1's package, and the SHA-256 of `/usr/bin/clang` and of
  the four inputs, each its recorded digest;
- the generator's build (status 0), into the recorded binary digest
  `bebe0ac3…`;
- the three generations, each with status 0, and their outputs' SHA-256. The
  full catalogue is `8fccc63b…`, its recorded digest. The own-main TSV is
  `0b8ff89f…` and the C file `47328ed9…`, which are the branch's files, byte
  for byte.

The lock's waiting messages went to separate files that this record leaves
out: they name other jobs.

## Method

The command is the 9700X job's compile-time step's `-c` of the frozen SQLite
3.53.2 amalgamation:
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`,
with `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`. Pinned to one
CPU, the driver compiles on one lane.

`scripts/queue.sh` built each tree (`scripts/build-tree.sh`,
`BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds), then ran
`scripts/measure.sh`, each in a hold of the lock of its own. `measure.log` is
the measurement's whole transcript:

1. **Receipts:** the date, `uname -a`, the CPU, CPU 2's governor, clang's and
   perf's versions, the lock's owner line (this measurement's), and the SHA-256
   of both executables and of `sqlite3.c`.
2. **A drive check:** each tree compiles once with its status, and the two
   objects are compared with `cmp` and their SHA-256.
3. **8 rounds:** in each, each tree, in an order alternated by round, runs 3
   times under `perf stat -e instructions:u,cycles:u,task-clock` on CPU 2.
   Every run's exit status is on its counters' lines.

`scripts/analyze.py` takes each round's mean of a tree's 3 runs, then the
median of the rounds' means, and the median, minimum and maximum of the
per-round ratios of head to base. It also checks that every run's status is 0.
Its output is `analysis.txt`.

## Results

Both trees exit 0 on the drive check and write byte-identical objects (SHA-256
`9048dda4…`). All 48 timed runs exit 0. `-c` of `sqlite3.c`, the medians of the
rounds' means, and the per-round ratios' median and range:

| | base | head | head against base |
|---|---:|---:|---:|
| instructions | 1,260,401,514 | 1,260,399,649 | −1,865 (−0.0001%) |
| cycles | 586.22 M | 585.81 M | −0.01% (−1.11% to +0.58%) |
| task clock | 124.12 ms | 124.00 ms | +0.15% (−1.10% to +0.46%) |

Each tree's instructions vary by at most 16 within a round, so the difference
of 1,865 is real but small. The cycles' and task clock's ratios straddle zero.

The executables' SHA-256: base `81181fcd…`, head `b2b96503…` (`build-*.log`,
`measure.log`).

## Corpus survey

`survey/` runs each of the six SSE units (`survey/units/`, from the sources
`survey/fetch.sh` names) with `-c` at the default target and with
`-march=native`, on the laptop (Ryzen 9 7940HS, Zen 4, clang 23.1.4), and
writes each unit's status and first error (`survey/stops.sh`). There are three
builds, whose SHA-256 are in `survey/executables.sha256`:

- **main:** `9bb5060e`, in `results-main.txt`;
- **head:** the branch, in `results-head.txt`;
- **head with #741:** the branch with #741's diff at `d50fe6f4` applied, whose
  VPEXTRW hunk the branch already had, in `results-head-with-741.txt`.

On main, the five units stop at the SSE shuffles, at both targets. With the
branch, every unit passes the checker. At the default target, each then stops
where the lowering refuses vectors without AVX-512F and AVX-512VL. With
`-march=native`, each stops at `__builtin_shufflevector` in clang's headers,
which #741 lowers. With #741 too, three other limits remain:

- stb_image: Tier 0's registers, where `_mm_set1_epi8` calls `_mm_set_epi8`
  with 16 arguments;
- dr_flac: `__builtin_convertvector` to floats;
- dr_mp3, minimp3 and minimp3_ex: `_mm_storeh_pi`'s 8-byte vector type.

xxhash compiles with `-march=native` on all three builds, through its AVX-512
path.

`survey/scan.py` and `survey/closure.py` are the static scan that chose the
builtins. They list the `__builtin_ia32_*` names that each unit's `clang -E`
text reaches, directly and through the header functions the unit calls,
against the own-main inventory and the lowering table.

## Mutation check

`scripts/mutants.sh` built two mutants of the branch's working tree, each with
one row changed (`mutants/*.diff`), and ran `test-checker --program-vectors`.
`maxps` with its operands swapped, and `cvtps2dq` with VCVTTPS2DQ's
truncation, each fail 4 checks: the `x86-sse` and `x86-sse-intrinsics`
programs' runs against clang, on both paths (`mutants/results.txt`).

## Limits

- One host and one lane, and one build of each tree. The cycles' differences
  are within the placement noise that two builds of the same work show on
  this file (0.7%, #536's record); the instruction counts are the precise
  comparison.
- The survey and the mutation check ran on the laptop, not the 9700X. The
  survey's upstream branches are as fetched on 2026-10-28, without a pinned
  revision.
- The survey's #741 build applies that PR's diff as fetched with `gh pr diff`,
  not a merge: its result is a preview of the two together, not of a merged
  main.

## After merging main

[`after-merge-2026-10-29/`](after-merge-2026-10-29/README.md) measures the branch's head after it merged main
(`d9a474cf`, against the merge-base `39732990`) the same way: byte-identical objects, +7,802 instructions
(+0.0006%), and cycles' and task clock's per-round ratios that straddle zero. It also keeps the mutation check of the
test that the PR's review asked for, `cvtps2dq` under each of MXCSR's rounding modes: a mutant whose `ldmxcsr`
stores MXCSR fails that test on both paths, and passes the test before it.
