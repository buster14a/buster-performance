# Loop store motion (buster#3309): the 9700X's record, 2026-11-22 and 23

The evidence for [buster14a/buster#3328](https://github.com/buster14a/buster/pull/3328), the pass that gives each
global a loop both loads and stores a private slot before SSA promotion (`ir_store_motion.c`,
`--tier1-passes=+storemotion`), for [buster14a/buster#3309](https://github.com/buster14a/buster/issues/3309). The
design and what these numbers decided are in the compiler's `docs/tier1-store-motion.md`. In short:

- on the 9700X a loop over integer globals runs as it did with the pass, and a loop over `double` globals 2.37 times
  as fast;
- the pass changes one start-up loop of speedtest1's unit and nothing of Lua's, and costs a `--tier1` compile of
  `sqlite3.c` 0.27% more instructions and 0.43% more cycles;
- so the pass is off by default.

Every run on the 9700X held the lock (`exclusive.sh`), and each log starts with its receipt. The compiler is a Release
build (`BUSTER_DEBUG_INFO=0`) of `f16b0523a`, the pull request's head when measured, where the pass was still on by
default: "with the pass" is `--tier1`, and "without" is `--tier1 --tier1-passes=-storemotion`. Its SHA-256 is in the
logs (`f9cba235...`). The host's `clang` is 23.1.1.

## 1. Four kernels at four placements (`results/9700x/kernels/`)

**What was run.** `scripts/9700x/sm3309-kernels.sh`, one hold of the lock: `scripts/kernels/k1.c` to `k4.c`, each one
`noinline` function of one loop run 200,000,000 times, compiled to an object by Tier 0 (`t0`), `--tier1` without the
pass (`t1`), `--tier1` with it (`sm`) and `--tier1 --tier1-passes=+all` (`all`). Each object is linked by clang after
0, 16, 32 and 48 bytes of padding (`-p0` to `-p48`), the four places a 16-aligned function takes in a 64-byte line;
`t1` and `sm` are also linked by the compiler itself (`-bl`); clang's `-O0`, `-O2` and `-O2 -fno-unroll-loops
-fno-vectorize -fno-slp-vectorize` (`c0`, `c2`, `c2n`) stand beside them. Every binary's output is compared with
clang -O0's, and every binary runs 5 rounds pinned to CPU 2, the order rotating by round, under `perf stat -e
task-clock:u,cycles:u,instructions:u`. `results.txt` has the 420 runs (`run KERNEL BUILD ROUND ms cycles
instructions`), each binary's addresses (`layout`) and the pass's report for each kernel; `summary.md`
(`scripts/summarize.py`) has every build's median, least and most; `compact.md` (`scripts/compact.py`) is the table
below.

**Why four placements.** The first attempt (section 4) and another session's runs of the same kernel disagreed on
`--tier1` without the pass: 272M cycles here, 400.2M there, for the same loop's instructions. The other session's
binary had its function at `0x1150`, and this record's `t1-p16`, also at `0x1150`, reads 400.2M; at the other three
placements the same object reads 272.7M to 276.9M. One placement's reading decides nothing about a loop this small.

Cycles an iteration, the least and the most of the four placements' medians (one figure where they agree to three
decimals):

| Build | k1: `g_a += i; g_b ^= g_a;` | k2: k1 and `g_arr[i & 15] += 1;` | k3: `g_sum += p[i & 1023]; g_hash = g_hash * 31 + p[i & 1023];` | k4: `g_x = g_x * 1.0000001 + 0.5; g_y += g_x; s_n += i & 3;` |
| --- | ---: | ---: | ---: | ---: |
| Tier 0 | 2.001 to 3.001 | 3.001 | 4.002 | 15.002 |
| `--tier1` without the pass | 1.364 to 2.001 | 2.185 | 4.001 | 15.597 to 15.605 |
| `--tier1` with it | 1.365 to 1.408 | 2.147 | 4.001 | 6.571 to 6.587 |
| `--tier1 --tier1-passes=+all` | 1.275 to 1.276 | 1.950 | 4.001 | 6.001 |
| clang -O0 | 2.583 | 3.497 | 4.006 | 15.002 |
| clang -O2 | 1.877 | 1.516 | 3.001 | 6.001 |
| clang -O2, no unrolling or vectors | 1.001 | 1.473 | 3.003 | 6.001 |
| Instructions an iteration, without the pass and with it | 9 and 7 | 15 and 13 | 14 and 12 | 17 and 16 |

Without the pass over with it, by placement (`compact.md`'s second table):

| Kernel | +0 | +16 | +32 | +48 | The compiler's own link |
| --- | ---: | ---: | ---: | ---: | ---: |
| k1 | 1.002 | 1.466 | 0.983 | 0.999 | 1.014 |
| k2 | 1.018 | 1.018 | 1.018 | 1.018 | 1.018 |
| k3 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |
| k4 | 2.373 | 2.375 | 2.368 | 2.369 | 2.366 |

**What it says.**

- The integer kernels don't pay for the trip through memory on this machine. k3 takes 4.0 cycles an iteration by every
  build of the compiler, Tier 0's included. k1 is unchanged by the pass at three placements, and k2 gains 1.8%.
- At one placement k1's loop takes 2.00 cycles an iteration without the pass and 1.37 with it. The loop with the pass
  is 7 instructions against 9, and none of its four placements is slow.
- k4, the `double`s, goes from 15.6 cycles an iteration to between 6.57 and 6.59: 2.37 times. clang -O2 and `+all`
  read 6.00.
- With the loads gone, what is left of k1's gap to clang's build that stores once after the loop is the two stores:
  1.365 cycles an iteration against 1.001. The store-sinking variant another session measured on k1 read 200.2M
  cycles, which is that 1.001 ([its comment](https://github.com/buster14a/buster/issues/3309#issuecomment-7087516036)).
- The issue's figures (5.8 cycles an iteration by either tier, 0.8 by clang) were a cloud Xeon's. In this session's
  cloud container, a Xeon at 2.3 GHz, the pass took k1 from 424 ms to between 92 and 97 (not recorded here as runs).

## 2. The corpora (`results/9700x/logs/corpora.txt`)

**What was run.** `scripts/9700x/sm3309-measure.sh corpora`, one hold of the lock, four parts.

**Identity.** speedtest1's unit (`sqlite3.c` and `speedtest1.c` as one) and Lua 5.4.8's 33 units, each compiled by
`--tier1` with the pass and without it. 33 of the 34 objects are the same bytes (their SHA-256s are in the log).
Lua: 2 loops store to a listed object, in `lua.c`, and both call a function. speedtest1's unit: 68 such loops, of
which 66 call a function, 1 stores through a pointer and 1 is moved (1 key, 2 loads and 1 store given the slot).
`results/9700x/speedtest1-differing-functions.txt` compares the two objects' disassembly function by function: of
1,422 functions one differs, `memsys5Init` (97 lines against 93), which runs at start-up. `measure-tier1-programs`
was therefore not run: no code that runs more than once differs.

**The pass alone** (`benchmark-ir-source --passes --only store-motion`, CPU 2): the frozen `sqlite3.c`'s 2,602
lowered functions, 559,072 instructions, with every symbol listed: 0.476 ms in all, 0.852 ns and 10.975 instructions
an IR instruction.

**The corpus's verification** (`test-ir-source --passes`): the `store-motion` row ran 2,602 functions, changed 0 and
failed 0, among the other passes' rows, and the run passed.

**A compile's cost** (`time-runs --runs 11 --warmups 1`, CPU 2): `--tier1 --lanes 1 -c` of the frozen `sqlite3.c`
with the pass (list 1) and without it (list 2). Medians of the 11 runs:

| | With the pass | Without it | With over without |
| --- | ---: | ---: | ---: |
| Instructions | 8,020,707,614 | 7,998,769,414 | 1.0027 |
| User cycles | 3,265,293,627 | 3,251,386,846 | 1.0043 |
| Wall, ms | 607.901 | 604.853 | 1.0050 |
| Peak memory (wait4), KiB | 326,996 | 324,884 | 1.0065 |

## 3. Where the compile's cost goes (`results/cloud/stages-sqlite3.txt`)

Not the 9700X: a cloud container, for the proportions alone. `scripts/stages.patch` adds counters and `rdtsc` reads
to the pass's entry point; a Develop build of `9751762f9` with it compiles the frozen `sqlite3.c` by `--tier1
--lanes 1` three times. With the unit's real symbol list:

| Step | Function bodies that reach it | Their instructions | Share of the pass's ticks (median of 3) |
| --- | ---: | ---: | ---: |
| The symbols' filter | 949 name a listed symbol | 773,538 | 1.9% |
| The classification and every store's address | 949 | 773,538 | 45.7% |
| The CFG | 169 have a store to a listed symbol's constant offset | 144,423 | 8.0% |
| The dominator analysis with loops | 169 | 144,423 | 37.2% |
| The loops' rules | 95 have a loop | 117,764 | 6.6% |

The bodies are counted after inlining, and a callee's summary is a body of its own, which is why there are more
instructions here than in the 2,602 lowered functions of section 2. Nothing is moved (28 loops: 27 with a call, 1
with a store through a pointer), so nine tenths of the time is spent before any loop's rule is applied.

## 4. The first attempt (`results/9700x/first/`)

Kept because it is where the placement question came from. A Release build of an earlier state of the branch (main
`1f7ce98f` and the working tree's patch; the same pass, before its rewrite step was changed to run by runs, which
left the objects of the four kernels the same bytes) ran k1's seven builds, linked by the compiler itself and by
clang, for 7 rounds (`kernels/results.txt`, `scripts/kernels.sh`), and the identity step (`logs/identity.txt`,
`scripts/measure.sh`): the same counts as section 2's. Its queue script was then terminated by a signal this session
did not send (`go.log`), and `/home` on the host was full (68 KiB free), so the record's runs were made again from
`/dev/shm` at the pull request's head (`scripts/9700x/sm3309-go.sh`, `results/9700x/logs/{clone,build,queue}.txt`).

## 5. Cloud runs (`results/cloud/`)

Counts and differentials, no timings.

- **A random-program differential** (`scripts/fuzz/gen.py`, `run.sh`): loops over globals, fields, elements, a
  union, aliasing pointers, calls, breaks and returns, by clang -O0 and by `--tier1` with the pass. 760 seeds, 0
  differences, 3,299 keys moved (`fuzz-1-40.txt`, `fuzz-41-640.txt`, and `fuzz-641-760.txt` after the pass became
  opt-in). The same generator on the other session's store-sinking branch (`run-other.sh`): 400 seeds, 0
  differences, 1,497 keys (`fuzz-other-*.txt`).
- **The real symbol list's counts**: the frozen `sqlite3.c` alone has 28 loops that store to a listed object and
  none moved (`sqlite3-report-line.txt`); musl's 1,355 units have 4, each with a call (`musl-report-lines.txt`).
- **Probes** (`scripts/probes/`): two extern names of one object defined as an alias in another unit (`two1.c`,
  `two2.c`), an object's asm label (`asmlabel.c`) and a key past its object's bytes (`oob.c`), the cases the symbol
  list's rules are for.

## Files

- `scripts/9700x/`: what ran on the host for sections 1 and 2. `scripts/kernels/`: the four kernels.
  `scripts/summarize.py`, `scripts/compact.py`: the tables. `scripts/kernels.sh`, `scripts/measure.sh`: the first
  attempt's. `scripts/stages.patch`: section 3's counters. `scripts/fuzz/`, `scripts/probes/`: section 5's.
  `scripts/irgen.py`, `scripts/fixtures.py`: the generator of the compiler's `tests/ir/store-motion/*.ir`.
- `results/9700x/kernels/`, `results/9700x/logs/`, `results/9700x/speedtest1-differing-functions.txt`,
  `results/9700x/first/`, `results/cloud/`: as above.
