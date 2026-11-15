# #2781's vector-only passes: the takeover's diagnosis, tests and 9700X runs

Evidence for [buster#2781](https://github.com/buster14a/buster/issues/2781) and
PR [#2790](https://github.com/buster14a/buster/pull/2790), from the Claude Code
session that took the work over on 2026-11-14 (after the Factory Droid session's
[`vector-passes-1344-2781-2026-11-14`](../vector-passes-1344-2781-2026-11-14/README.md)).

| What | Commit on buster14a/buster |
| --- | --- |
| base of the recovered work | `45cd9aec77c4885f55da8f2ee9cace69fa394a85` |
| recovered implementation | `2011ce042e498f45d70bec7d3b7a69bcb14d173f` |
| fixture fix | `95585907c3656c7882793ae819d10a8b5f4f15fe` |
| main merged in (head) | `1dbbb92350d231f9c6ecfa85dd5f27d9db75e411` |
| main measured against | `2ebfe68a856613e300231520af5e7ec5627708b6` |

## The 14 `test-checker-driver` failures (`diagnosis/`)

`diagnosis/run.sh` reproduces each group on a cloud x86-64 container with
AVX-512, with compilers built at `45cd9aec` (BASE) and `2011ce042` (HEAD), CI's
staged clang 23.1.4 and Ubuntu's clang 23.1.6; `run.log` is its output.

- **2: the PR's own fixture.** Its function computed `a + a` twice from a local
  `a`. The solver runs before promotion, where those reads are loads, and value
  numbering never merges loads: `gvn_removed=0` by both paths, and even `+gvn`
  removes the same 32 instructions with one `a + a` as with two
  (`fixture-single-add.c`). The implementation does what #2781's design says;
  the fixture was wrong. `fixture-after.c` (now in the PR) builds an equal vector
  constant twice in the loop: `licm_moved=4 gvn_removed=1` by both paths, 0 and 0
  with `-vectors`, output 126 as clang's.
- **12: the desktop's clang enabled the stack protector by default.** The 8 CFI
  and target-version symbol lists differed from clang's only by clang's
  `__stack_chk_fail`, and #1373's program printed `12` where that clang printed
  `11`: with `-fstack-protector-strong`, clang -O0 makes one memcpy call of the
  program's two. `clang-stack-protector.sh` (Ubuntu's 23.1.6 with that flag)
  reproduces all 12, on BASE and HEAD alike (`ssp-{base,head}-*.log`); clang
  23.1.4 and plain 23.1.6 print `12`, as both compilers do on both paths, and
  `--target-versions-only` passes with either (`tv-head-*.log`). The clang version
  was not the cause, and this branch did not cause them.

## Tests on the final build (`tests/`)

Develop build of `1dbbb92` on the container, CI's clang 23.1.4 first on `PATH`,
run from the repository root:

| Test | Checks | Failures |
| --- | ---: | ---: |
| `test-checker-driver` (full) | 194,567 | 0 |
| `test-ir-gvn` | 2,195,108 | 0 |
| `test-ir-licm` | 3,424 | 0 |
| `test-checker --requests` (option tables) | 213 | 0 |
| `test-check-lanes --tier1-outcomes` | 3,592 | 0 |
| `test-tier1-masks` | 266,271 | 0 |
| `test-tier1-pipeline` | 7,317 | 0 |
| `test-ir-optimize` | 284,594 | 0 |

CI's run 43652196175 on `1dbbb92` (the merge ref) passed every hosted shard and
the vector draw.

## 9700X (`9700x/`)

benchpress, `exclusive.sh` per run, Release builds by the 9700X's staged clang
23.1.4 (`BUSTER_DEBUG_INFO=0`), base `2ebfe68a` against head `1dbbb92`
(`commit-*.txt`, `compilers.sha256`, `clang.txt`). `run.sh` is the whole job,
run detached by `systemd-run --user` on 2026-11-14 23:15 to 2026-11-15 00:57
UTC; `steps.log` is its timeline. The lock was contended (other sessions'
builds and runs between ours); `exclusive.sh` listed no busy processes as ours
took it, and `rows.log` and `state-*.txt` hold the busiest processes and the
load average inside the holds.

### The lexer, rows and scan programs (`rows.log`)

`measure-tier1-rows --runs 11 --clang CLANG --base BASE --march znver5 --lexer
src/buster/compiler/c_lexer.c` on CPU 2, as the 9700X job runs it. Every
build's outputs agree.

| | `--tier1` (base) | `--tier1` (head) | head / base | clang -O2 |
| --- | ---: | ---: | ---: | ---: |
| `c_tokenize`, cycles/B, median [min-max] | 8.274 [8.267-8.294] | 4.144 [4.133-4.155] | 0.501 | 0.800 |
| `c_tokenize`, instructions/B | 12.193 | 10.196 | 0.836 | 2.930 |
| lexer program, user cycles, M | 98.29 | 76.95 | 0.783 | 39.56 |
| lexer program, instructions, M | 299.96 | 289.34 | 0.965 | 135.47 |
| rows program, user cycles, M | 29.32 | 29.32 | 1.000 | 28.47 |
| scan program, user cycles, M | 30.12 | 30.09 | 0.999 | 23.21 |

The lexer unit's report: 67,782 records against 76,411, with `licm_moved=31`
and `gvn_removed=565` (0 and 0 at base). The prototype's 9700X run measured
8.192 to 4.049 cycles/B.

### Scalar neutrality (`objects.sha256`, `neutral-reports/`)

`--tier1 -march=znver5` objects of `sqlite3.c` (`--lanes 1
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`), Lua 5.4.8's 32 library
units (`-DLUA_USE_LINUX`; `lua.c` and `luac.c` left out) and the lexer unit, by
base, by head and by head with `--tier1-passes=-vectors`. SQLite's and every
Lua unit's three objects are byte-identical, and each report has
`licm_moved=0 gvn_removed=0`: no function passes the gate. The lexer's head
object differs, and its `-vectors` object is base's. `lua.c` was checked apart,
on the container's Develop build of the head: identical with and without
`-vectors`.

### Compile cost (`compile-*.log`)

`ab --rounds 3 --cpu 2` over `time-runs --copies 3 --build base --build head
--build base-again`, each process from a fresh copy in tmpfs, one lock hold per
round; `base-again` is the floor. User cycles, each round's median against base:

| Compile | head | base-again | instructions, head / base |
| --- | --- | --- | ---: |
| `-c sqlite3.c` (`--runs 3`, 3,281 M cycles at base) | +0.18%, -0.00%, +0.26% | +0.13%, +0.04%, -0.01% | 8,079.3 M / 8,077.7 M (+0.02%) |
| `-c c_lexer_benchmark.c` (`--runs 5`, 930 M cycles at base) | +12.27%, +12.19%, +12.19% | +0.03%, +0.04%, -0.06% | 3,168.0 M / 2,751.9 M (+15.1%) |

SQLite's compile is within about 0.2% of base's (wall 611 ms either way): the
gate's scan is all a scalar unit pays. The lexer unit's compile is 12% slower
(wall 179.6 to 200.5 ms). Both passes run on each of its functions that has
vector values, and the solver numbers all of such a function's values though it
applies only the vector merges (#2781's design, step 2); how the 12% splits
between the two passes was not measured. Numbering only what reaches a vector
value is #2781's next step for compile time.
