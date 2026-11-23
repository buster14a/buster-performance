# Sinking a loop's stores to its exits (buster#3346): the 9700X's record, 2026-11-23

The evidence for [buster14a/buster#3391](https://github.com/buster14a/buster/pull/3391), which extends
[#3328](https://github.com/buster14a/buster/pull/3328)'s loop store motion so that a loop's stores of a global move to
its exits where every read of memory in the loop is a load the pass can place
([buster14a/buster#3346](https://github.com/buster14a/buster/issues/3346)). The design is in the compiler's
`docs/tier1-store-motion.md`; [#3309's record](../store-motion-3309-2026-11-22) has the pass before this change, whose
kernels and random-program generator this record reuses. In short:

- the issue's integer kernel goes from 1.365 cycles an iteration to **1.001**, clang -O2's own figure when it doesn't
  unroll or vectorize, at every one of the four placements;
- the kernel with an indexed store beside it goes from 2.147 to 1.70, and the `double` kernel from 6.57 to 6.385;
- the kernel that reads through a pointer is refused and unchanged, 4.001 by every build of this compiler;
- a `--tier1` compile of the frozen `sqlite3.c` costs the same with the pass as #3309 measured (0.46% more cycles),
  since it still moves nothing there, and Lua's 33 units 0.16% more; both corpora's objects are unchanged.

Every run on the 9700X held the lock (`exclusive.sh`) and each log starts with its receipt. The trees were built from
`/tmp` (benchpress's `/home` was full), each a Release build with `BUSTER_DEBUG_INFO=0`:

| Tree | Commit | What it is |
| --- | --- | --- |
| `tree` | `e5f3e304b` | the pull request's head: the stores sink, and the write-back reads the key at the exit |
| `keep` | `42770575f` | its first commit: the stores sink, and the write-back compares the preheader's value, held in a register across the loop (`held` below) |
| `base` | `0766f0a44` | #3328's head: the stores stay (`keep` below) |

The host's `clang` is 23.1.1 for the kernels; the correctness runs in the cloud container used the staged clang 23.1.4.

## 1. Four kernels at four placements (`results/9700x/kernels/`)

**What was run.** `scripts/9700x/sm3346-kernels.sh`, one hold of the lock: #3309's `scripts/kernels/k1.c` to `k4.c`,
each one `noinline` function of one loop run 200,000,000 times, compiled by `--tier1` without the pass (`t1`), by
#3328's head with it (`keep`), by this branch's first commit (`held`) and by its head (`sink`). Each object is linked
by clang after 0, 16, 32 and 48 bytes of padding (`-p0` to `-p48`), the four places a 16-aligned function takes in a
64-byte line, because placement alone moved k1's loop by half a cycle an iteration in #3309's record. clang's `-O2`
and `-O2 -fno-unroll-loops -fno-vectorize -fno-slp-vectorize` (`c2`, `c2n`) stand beside them; every binary's output
is compared with clang -O0's. 5 rounds of every binary, pinned to CPU 2, the order rotating by round, under
`perf stat -e task-clock:u,cycles:u,instructions:u`. `results.txt` has the 280 runs
(`run KERNEL BUILD ROUND ms cycles instructions`), the pass's report for each kernel and the sunk objects'
disassembly (`asm`).

Cycles an iteration, the least and the most of the four placements' medians (one figure where they agree to three
decimals):

| Build | k1: `g_a += i; g_b ^= g_a;` | k2: k1 and `g_arr[i & 15] += 1;` | k3: sums through a pointer | k4: two `double`s and a `long` |
| --- | ---: | ---: | ---: | ---: |
| `--tier1` without the pass | 1.365 to 2.001 | 2.185 | 4.001 | 15.594 to 15.599 |
| With #3328: the stores stay | 1.365 to 1.408 | 2.147 | 4.001 | 6.569 to 6.589 |
| With sinking, the value held in a register | 1.001 to 1.155 | 2.186 to 2.193 | 4.001 | 6.385 to 6.386 |
| **With sinking (this PR)** | 1.001 | 1.696 to 1.710 | 4.001 | 6.385 to 6.387 |
| clang -O2 | 1.877 | 1.516 | 3.001 | 6.001 |
| clang -O2, no unrolling or vectors | 1.001 | 1.473 | 3.003 | 6.001 |
| Instructions an iteration: without the pass, with #3328, with sinking | 9, 7, 5 | 15, 13, 11 | 14, 12, 12 | 17, 16, 13 |

- **The integer kernel is clang's.** k1 reads 1.001 cycles an iteration at every placement, the same as clang -O2's
  build that stores after the loop, from 1.365 to 1.408 with #3328's stores in the loop. Its five instructions an
  iteration are clang's five.
- **The indexed store's kernel gains too**: 2.147 to between 1.696 and 1.710 (clang -O2: 1.516; without unrolling,
  1.473).
- **The `double` kernel**: 6.569 to 6.589 with #3328, 6.385 to 6.387 now, against clang's 6.001.
- **The pointer kernel is refused**: `sink.load=2` in its report, and 4.001 cycles an iteration by `t1`, `keep` and
  `sink` alike.
- **Why the write-back reads the key.** With the preheader's value held in a register for the comparison (`held`),
  k2 was no faster than #3328's build and slower than `t1`: 2.186 to 2.193 against 2.147, with 14 instructions an
  iteration against 13, because each key's value live across the loop cost a spill and a reload every iteration
  (`mov %r10,-0x8(%rsp)` … `mov -0x8(%rsp),%r10` in `results.txt`'s `asm k2` of that build). Reading the key at the
  exit instead removes that: the loop no longer stores to it, so memory still holds the value the preheader read.

## 2. What the pass does to the corpora (`results/9700x/compile/`)

**`sqlite3.c`** (`scripts/9700x/sm3346-sqlite.sh`, two holds of the lock): the frozen corpus's `sqlite3.c` by
`--tier1 --lanes 1 -c` with the pass and without it. The report is `loops=28 barrier=27 unknown-store=1`: the pass
moves nothing, as in #3309's record, so the objects are byte-identical (`sqlite3 objects identical`). 11 runs each
after a warm-up, pinned to CPU 2, by `time-runs`, medians:

| | With the pass | Without it | With over without |
| --- | ---: | ---: | ---: |
| Instructions | 8,022,662,193 | 7,999,995,214 | 1.0028 |
| User cycles | 3,265,066,339 | 3,249,974,560 | 1.0046 |
| Wall, ms | 607.100 | 604.579 | 1.0042 |
| Peak memory, KiB | 327,120 | 325,008 | 1.0065 |

**Lua 5.4.8's 33 units** (`scripts/9700x/sm3346-compile.sh`, one hold): one command that compiles them in turn by
`--tier1 --lanes 1 -c`, 12 runs each way with the first dropped, pinned to CPU 2 under `perf stat`. Medians:

| | With the pass | Without it | With over without |
| --- | ---: | ---: | ---: |
| Instructions | 2,347,955,360 | 2,346,030,920 | 1.0008 |
| User cycles | 1,032,287,931 | 1,030,653,304 | 1.0016 |
| Wall, ms | 230.87 | 230.49 | 1.0016 |

Lua's objects are unchanged: only `lua.c` has a `tier1-store-motion` line, `loops=2 barrier=2` — its two loops that
store to one of its own objects both call a function, as #3309 found.

(`results/9700x/compile/compile-sqlite3.txt`'s first copy and `reports.txt` are from a first attempt whose `sqlite3.c`
commands passed `--no-default-config`, which `-c` doesn't take: those runs failed in 0.1 ms and say nothing. The Lua
timing in `compile-lua.txt` and the valid `sqlite3` runs in `sqlite3-reports.txt` and the second
`compile-sqlite3.txt` are the record.)

## 3. Random programs (`results/fuzz/`, the cloud container)

#3309's generator, `scripts/fuzz/gen.py`, with a `known` mode added for this change: without it a loop may read
through `p`, `q` or `gp`, which refuses sinking; with it no access goes through a pointer, so most loops' stores sink.
Each seed's program is compiled by clang -O0 and by `--tier1 --tier1-passes=+storemotion`, run, and its output and
status compared; a difference is retried without the pass to say which build is wrong (`scripts/fuzz/run.sh`).

| Seeds | Keys moved | Keys sunk | Differences |
| --- | ---: | ---: | ---: |
| 1 to 800, the default mode | 3,660 | — | 0 |
| 1,001 to 1,800, `known` | 6,222 | 5,741 | 0 |

(The default mode's shards were run before the `sunk` count was printed; `default-sunk.txt`, seeds 1 to 40 of that
mode with the count, sank 81 of 179.)

## 4. The repository's own tests (`results/inventory.log`)

The inventory blocks of `tools/ci/correctness.tests` that name the IR, Tier 1 and SSA tests, by
`BUSTER_COMPILER=$PWD/build/compiler ./build/compiler parallel --jobs 4`, with the staged clang 23.1.4 first on PATH,
in the cloud container: **35 commands, 35 passed, 0 failed**, among them the pass's own
`test-ir-store-motion` (394 checks) and `tests/driver/tier1_store_motion.c`'s six programs. The two SQLite shell and
testfixture blocks are not in that selection: they need SQLite's tree and Tcl, and run no opt-in pass.
