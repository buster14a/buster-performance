# The IR of every corpus function, Buster #131

Compiler branch: `claude/solve-131-9dd8b8` of buster14a/buster, for
[this claim on #131](https://github.com/buster14a/buster/issues/131#issuecomment-6478779116).

The branch makes Tier 1's IR (`ir.c`) take every function the C driver's `-c`
compiles: the typed-stream adapter (`ir_lower.c`) lowers indirect calls,
labels and indirect jumps (through one dispatch block per function),
aggregates passed and returned by value (with their ABI records), variadic
definitions' frames, long double and `__int128`. `test-ir-source` lowers every
such function of a set of files by both paths, which must agree and verify, and
promotes each to SSA by both of `ssa_ir.c`'s paths; `benchmark-ir-source`
reports the IR's bytes per source token and times lowering, verification and
promotion. This record holds the 9700X runs of both, and main-against-head
comparisons of the default `-c` path, the checker unit's build and the IR's
synthetic benchmarks.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on
the 9700X:

- **main:** `9bb5060ebe347de5c7a0a92ba325a7b14a567788`, the branch's base;
- **head:** `dc8adc81878316fbd997eedc1078c9bb32cd2d3f` (tree
  `a4014dad11e77f82637a6428d0d7fbf50edf986a`, measured as `a47f090d`, the same
  tree before its message was amended), main merged into the branch, with the
  IR's optional operands found by table (`ir_value_mask`). Its later commits
  change only documentation.
- **before** (`before/`): `fb3dce1010585d25f7143aa5170daf5e07744ba7`, the same
  branch before that table, against the same main.

`scripts/queue-first.sh` built main and `fb3dce10` and ran the latter's tests and
`benchmark-ir-source`; main's build (`logs/build-main.log`) is the one the later
runs used, and the rest of that queue is superseded by `scripts/queue.sh`'s runs
of head. `scripts/queue-before.sh` ran `before/`'s comparisons.

Author-reported host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1,
perf 7.2.9, CPU 2's governor `performance`. The scripts take a separate hold of
the host's lock (`exclusive.sh`) for each build, test run and measurement, and
pin each measurement to CPU 2. The lock's waiting messages are left out of the
logs: they name other jobs. Only the lines the scripts and the compiler print
are kept (an allowlist of their shapes where a log held the lock's messages).

Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds. The
executables' SHA-256, as `sha256sum` printed them on the host (the binaries are
not included): main `81181fcd6731fe16ca4dd712c9ab5ef325850f686f877b0855a18b4c72766cf8`,
head `a89d9974ec1928a70efe4502a38270526a11ea552a13515b349a5f54bf088f91`,
before `e23c9b5aef24230b015898676bcc69e4b9033edd2bc0a4eb60e98db8f0796faf`.

Inputs, from the host's frozen corpora
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`): SQLite 3.53.2's
`sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the
9700X job's `benchmark-backend-source` options (its pinned predefines and
headers, `-std=gnu17 -march=znver5`); musl 1.2.5 as Zig 0.14.1 vendors it
(`libc/musl`), its 1,355 units with its build's options; and c-testsuite's
commit `5c72756`, the 220 programs of `tests/c-testsuite/subset.txt`.

## Correctness on the host

`scripts/tests-rerun.sh` (`logs/tests-rerun.log`, `logs/head-*.log`): `test-ir`,
`test-ir-parse`, `test-ssa-ir`, `test-ir-interpreter`, `test-ir-optimize`,
`test-ir-inline`, `test-ir-gvn`, `test-ir-licm`, `test-ir-sroa`,
`test-tier1-select`, `test-tier1-pipeline`, `test-call-graph` and
`test-ir-lowering` (31,900 checks) pass on head, and `./build.sh
check-call-graph` reports no cycle and no split variable. `test-ir-source`:

| Corpus | Files | Functions | IR instructions | Bytes per token |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 2,602 | 598,568 | 19.82 |
| c-testsuite | 220 | 430 | 22,378 | 2.63 |
| musl's units that `-c` compiles | 1,049 | 1,914 | 246,057 | 1.59 |

Every function lowers by both paths alike, verifies, and promotes by both. `-c`
refuses musl's other 306 units' features by name, and they are left out.
`scripts/queue.sh`'s own tests hold passed the expanded musl file list in
`bash -c`'s one argument, past the kernel's 128 KiB for an argument, so that
the hold never started; `scripts/tests-rerun.sh` is that hold with the held
shell expanding the globs.

## The IR's bytes and times on `sqlite3.c`

`logs/benchmark-ir-source.log`: 705,670 source tokens (the parser's), 396,872
typed entries, 598,568 lowered IR instructions in 13,986,379 bytes (19.82 per
token: 13.57 of instruction columns, 4.64 of blocks and side tables, 1.60 of
64-byte alignment gaps), 493,934 promoted instructions in 12,227,119 bytes
(17.33 per token). `sqlite3VdbeExec` is the largest function, 571,792 bytes
(4.09%), and the ten largest are 14.00%.

21-pass medians per typed entry over every function, each pair's paths taking
turns:

| Variant | ns | Cycles | Instructions | IPC |
| --- | ---: | ---: | ---: | ---: |
| `lower` | 46.86 | 259.67 | 569.59 | 2.19 |
| `lower-scalar` | 49.64 | 274.93 | 687.01 | 2.50 |
| `verify` | 23.45 | 129.77 | 330.79 | 2.55 |
| `verify-scalar` | 24.06 | 133.25 | 429.03 | 3.22 |
| `promote` | 159.40 | 882.69 | 2,535.19 | 2.87 |
| `promote-scalar` | 150.85 | 835.80 | 2,285.41 | 2.73 |

`logs/benchmark-ir-source-after.log`: `lower` alone, with 200 ms of scalar work
before each sample, 46.92 ns per entry.

## Main against head

`scripts/queue.sh` runs each comparison's main and head in one hold, the order
alternating by round.

**The default path,** `-c` of `sqlite3.c` (`logs/pair-compile-*.csv`, three
rounds of `perf stat -r 11`): user instructions 1,260,243,852 on main and
1,260,248,697 on head (+4,845, +0.0004%), cycles 584.8 to 586.3 million on
main and 585.5 to 586.4 million on head, task clock 123.45 to 123.78 ms and
123.55 to 123.77 ms: no difference beyond the rounds' spread. Both write the
same object (`logs/pair-sqlite3-objects.sha256`).

**The build** (`logs/pair-checker-unit.log`, `logs/build-*.log`): the checker's
unit compiles in 24.44 and 24.41 s on main and 25.59 and 25.54 s on head
(+1.14 s, +4.7%), the whole build in 29.7 s and 30.9 s. `test-ir-source` and
`benchmark-ir-source` run in the checker's unit, which compiles the IR's modules
for them: a command that runs the checker's emission (whose x86 encoder keeps
its templates in each unit's own storage) and the adapter's validation (which
reads them) must run both in one unit's copy, by `./build.sh
check-call-graph`'s split-state rule, and only the checker's unit has the
checker.

**The IR's benchmarks** (`logs/summary.md`, from `logs/pair-benchmark-*.log`
by `scripts/summarize.py`): medians of three rounds (the optimizer's two),
main → head, and for the optimizer the median and range over its functions:

| Measurement | Change |
| --- | ---: |
| Verifier, vector, 32 and 262,144 instructions | +5.7%, +7.3% |
| Verifier, scalar | +1.3%, +5.6% |
| Use lists | +1.0%, −1.1% |
| CFG | +3.2%, +3.1% |
| Lowering, larger programs (mixed, objects, dynamic stack), vector | +2.8%, +3.2%, +2.9% |
| Lowering, small programs, vector | +3.4% |
| `benchmark-ir-optimize`'s five functions, scalar | +5.1% (+3.2% to +8.7%) |
| Its vector path | −0.4% (−2.6% to +2.9%) |
| `benchmark-ir-optimize-passes`' nine (GVN, LICM, SROA), scalar | −1.4% (−6.5% to +4.8%) |
| Their vector paths | −0.8% (−23.8% to +5.0%) |

`scripts/counters.sh` (`logs/counters-*.csv`) ran each benchmark whole twice per
tree, the order alternating, with user instructions, cycles and the dispatch
slots the front end left empty (PMCx1A0, umask 1, raw `0x1000001a0`); the
calibrated repetitions are the same in both trees, so each run does the same
work:

| Run | Instructions | Cycles | Empty dispatch slots |
| --- | ---: | ---: | ---: |
| `benchmark-ir --only vector` | −1.1% | +5.4% | +13.6% |
| `benchmark-ir --only scalar` | +0.5% | +3.8% | +2.1% |
| `benchmark-ir-lowering --only vector` | +1.8% | +3.8% | +5.8% |

The vector verifier does less work on head and takes 5.4% longer, with 13.6%
more slots its front end leaves empty: where its code falls, not what it does.
The lowering does 1.8% more work, the new kinds' and records' tests, and loses
as much again in the front end. On a Zen 4 laptop (Ryzen 9 7940HS, not
recorded here), the same pairs read head's verifier 2% to 7% faster than main's,
its use lists 5% to 12%, and its lowering of the larger programs within 1%.

**Before the table** (`before/summary.md`, `scripts/queue-before.sh`'s
comparisons of `fb3dce10`): the verifier was 5% to 6% slower, the use lists 4% to 7%, the
optimizer's functions a median 4.8% (scalar) and 3.8% (vector), and its passes
4.7% and 3.9%. `ir_value_mask`, which the verifier's graph
checks and the use lists run for each operand, then tested each operation with
optional operands in turn, a call's destination the third; the table made the
use lists main's again.

## Limitations

- One build per tree. The backend unit's `.text` is aligned to 64 bytes, so
  `./build.sh shifts` can't move its code within a line, and no placement sweep
  separates placement from the change beyond the front-end counters above.
- Each comparison's rounds share holds, with other jobs between holds.
- These runs say nothing of Tier 1's code, which doesn't compile these functions
  yet.
