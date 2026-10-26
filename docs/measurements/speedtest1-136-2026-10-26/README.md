# speedtest1 through Tier 0, against clang -O0 and tcc

2026-10-26, for [buster14a/buster#136](https://github.com/buster14a/buster/issues/136)'s
last "Done when" item: "the generated code's run time and size against
`clang -O0`'s on the same programs (`speedtest1` once SQLite works)". SQLite's
own benchmark, `test/speedtest1.c` at 3.53.2, built from the frozen corpus's
`sqlite3.c` (the file [the SQLite record](../sqlite-136-2026-10-26/README.md)
measured) by this compiler (Tier 0's code), by clang 23.1.1 at -O0 and by tcc
0.9.28rc, and run on the 9700X, pinned to CPU 2.

## Source and inputs

- buster: main at `e04462c12f1ce25c70e41e8aa4acf48f4d7c4004`, built with
  `BUSTER_DEBUG_INFO=0 ./build.sh` (`build-compiler.log`).
  `manifest-e04462c1.sha256` lists the measured tree's `build.sh`, `src` and
  `tests`, which match that commit's `git archive` byte for byte.
- `sqlite3.c` and `sqlite3.h`: SQLite 3.53.2's amalgamation, Fossil check-in
  `d6e03d8c777cfa2d35e3b60d8ec3e0187f3e9f99d8e2ee9cac695fd6fcdf1a24`, from the
  frozen corpus `preprocessor-corpora-astra-01a158dd`.
- `speedtest1.c`: SQLite's `test/speedtest1.c` at tag `version-3.53.2`, the
  same check-in. That is the GitHub mirror's commit
  [`ccc132c5be20ab5c755c97a08d06b1b592fef330`](https://github.com/sqlite/sqlite/blob/ccc132c5be20ab5c755c97a08d06b1b592fef330/test/speedtest1.c)
  (its message's `FossilOrigin-Name` is the check-in):
  - git blob `a127f62e9fd8366ca782e923d7d299d95c9408b8`;
  - Fossil artifact
    `6c01252e66f46de0b6b8d5316e03521e2151782104f3608c10262aa5dce85721`;
  - 116,785 bytes, sha256
    `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675`.

  sqlite.org's `/src/raw/test/speedtest1.c?ci=d6e03d8c...` gave the same
  bytes. It is an external input (SQLite's source, in the public domain) and
  is not copied here.
- `speedtest1-unity.c`: ours, for the direct path (below).
- `identities.txt`: the toolchain's versions, the kernel, the CPU, CPU 2's
  governor and EPP, and the sha256 of the inputs and of the measured
  `build/compiler`. `files.txt` and `hashes.txt` list the objects and
  executables, which aren't recorded.

## Builds

Every compile uses SQLite's own performance procedure's options
(`test/speedtest.tcl` at 3.53.2): `-DSQLITE_OMIT_LOAD_EXTENSION
-DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`. Each
compiler's own level replaces the script's `-Os`, and there is no `-g`:

- **ours:** `compiler -c` of `sqlite3.c` and of `speedtest1.c`, linked by `cc`
  (GCC 16.2.1's driver, GNU ld 2.47) with `-lm`.
- **direct:** the C driver's direct path. It compiles and links in one
  process: `compiler -o st-direct speedtest1-unity.c -lm`, a dynamic PIE that
  `executable.c` writes. The driver takes one file, so `speedtest1-unity.c`
  includes `sqlite3.c`, then `speedtest1.c`. It renames speedtest1.c's static
  `randomFunc`, which would redefine sqlite3.c's.
- **clang:** `clang -O0 -c` of both files, linked by `cc`.
- **tcc:** `tcc -c` of both files, linked by tcc itself.

  The shell of the SQLite record didn't link this way: its `atexit` is a
  member of `libc_nonshared.a`, whose `.note.GNU-stack` tcc refuses.
  speedtest1 and `sqlite3.c` need no member of that archive.

## Commands

`st-all.sh` ran detached on the 9700X and took the shared lock twice:

1. `st-compiler.sh`: the compiler's build.
2. `st-measure.sh`: everything else, in one 35 s hold. All of it was pinned to
   CPU 2 (`st-env.sh` has the paths, options and steps):
   - `st-build.sh`: the four builds, then the identities and sizes. Then one
     `--verify` run of each build (`verify-*.txt`), whose verification hashes
     must agree.
   - `st-compile.sh`: 11 rounds of the four builds in a rotating order
     (`compile.times`, in microseconds). Each round times each compiler's
     `sqlite3.c`, its `speedtest1.c` and its link, and the direct path's whole
     build. Every round's outputs were the build step's, byte for byte.
   - `st-runs.sh`: one untimed warm-up run of each build, then 11 rounds in a
     rotating order (`run.times`, outputs in `runs/`). `run.times` has, per
     run: the wall time in microseconds, bash's user and system seconds, and
     speedtest1's own `TOTAL`.
   - `st-counts.sh`: 3 rounds under `perf stat -e instructions:u,cycles:u`
     (`counts/`).
   - `st-profile.sh`: a `perf record` of one run of each build per event,
     reported by function (`profile/`).

Each run starts from a fresh database on tmpfs, with SQLite's temporary
files there too. It uses `speedtest.tcl`'s speedtest1 options:

```sh
cd /tmp/speedtest1-136-claude/db
SQLITE_TMPDIR=/tmp/speedtest1-136-claude/tmp taskset -c 2 ./st-BUILD --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 speedtest1.db
```

`st-summary.sh` made `summary.txt` and `testsets.txt` from these files.
`st-sections.sh` made `sections.txt` (`size -A`) and `dispatch.txt`
(`objdump -d`) from the measured binaries, with GNU binutils 2.47, after they
were copied off the 9700X. `measure.log` is `st-all.sh`'s report.

## Results

Medians of 11 rounds (runs and compiles) and 3 (counts):

| | ours (`-c`, cc) | direct | clang -O0 | tcc |
|---|---|---|---|---|
| speedtest1's run, wall time | 294.4 ms | 295.7 ms | 293.3 ms | 271.5 ms |
| against clang -O0's | 1.004 | 1.008 | 1 | 0.926 |
| the rounds' range | 293.2 to 294.9 | 294.7 to 296.8 | 292.1 to 294.7 | 271.1 to 279.2 |
| speedtest1's own `TOTAL` | 0.292 s | 0.294 s | 0.292 s | 0.270 s |
| user-space instructions | 6,865.7 M | 6,865.5 M | 3,921.8 M | 4,832.6 M |
| user-space cycles | 1,536.5 M | 1,540.0 M | 1,514.4 M | 1,402.1 M |
| instructions per cycle | 4.47 | 4.46 | 2.59 | 3.45 |
| `.text` of `sqlite3.o` | 1,292,088 B (1.30) | | 993,846 B | 1,254,666 B (1.26) |
| `.text` of `speedtest1.o` | 38,981 B (1.29) | | 30,230 B | 39,311 B (1.30) |
| `.text` of the executable | 1,331,336 B (1.30) | 1,331,216 B (1.30) | 1,024,342 B | 1,295,452 B (1.26) |
| `.eh_frame` of `sqlite3.o` | 215,416 B (2.46) | | 87,680 B | 96,112 B (1.10) |
| `sqlite3.c` compiled | 194.8 ms | | 571.9 ms | 42.2 ms |
| `speedtest1.c` compiled | 12.8 ms | | 32.2 ms | 3.6 ms |
| link | 14.2 ms (cc) | | 12.9 ms (cc) | 2.7 ms (tcc) |
| the whole build | 221.8 ms (sum) | 199.5 ms | 616.9 ms (sum) | 48.6 ms (sum) |

Ratios in parentheses are against clang -O0's. "Sum" is the sum of the steps'
medians; the direct path's build is one process.

Tier 0's code runs speedtest1 at clang -O0's speed: 0.4% slower, within the
rounds' spread (0.6% of Tier 0's runs, 0.9% of clang's). It retires 1.75 times clang's instructions in
1.5% more cycles: clang's -O0 code keeps every local in memory, and its
instructions wait on those loads and stores, while Tier 0's register homes
retire 4.47 instructions per cycle on Zen 5. tcc's code takes 7.4% less time
than clang's, and 7.8% less than Tier 0's.

By testset (`testsets.txt`, speedtest1's per-test milliseconds summed per
testset in each run; medians), Tier 0 against clang -O0:

- equal on `json` and `rtree`;
- about equal on `main` (155 ms against 157);
- faster on `cte` (27 against 30);
- slower on `fp` (25 against 22), `orm` (29 against 28) and `app` (10
  against 9).

Under `size`'s Berkeley count (`sizes.txt`), whose "text" also counts
`.rodata` and `.eh_frame`, Tier 0's `sqlite3.o` has 1,560,706 bytes against
clang's 1,143,263. Tier 0's `.eh_frame` is 2.46 times clang's, for one FDE per
function in both (2,668 and 2,667). Each of its transitions advances with a
5-byte `DW_CFA_advance_loc4`, so that the writer knows every FDE's size before
it writes them (`unwind_fde_bytes`). And without a frame pointer, every push
and pop of the prologue and epilogue has its own rule.

## Where the instructions go

`switch` lowers to a chain of compares and branches in case order on main
(`check_lower_case` in `c_check_program_lower.c`), and clang -O0 makes jump
tables. `dispatch.txt` shows both:

- **Tier 0's `sqlite3VdbeExec`:** SQLite's bytecode interpreter loads each
  opcode into `r14d`, then runs a chain of 184 `cmp`/`je` pairs (2,016 bytes),
  so an opcode far down the cases pays dozens of compares.
- **clang -O0's:** the same switch is a bounds check and a jump table.
- **The parser's `yy_reduce`:** 10,656 instructions in Tier 0's code, without
  an indirect jump, against clang's 4,081 with one.

From the sampled profiles (`summary.txt`'s last table: each function's share
of `instructions:u` times the build's count), the two functions account for
1,049 M of Tier 0's 2,944 M extra instructions:

- `sqlite3VdbeExec`: 1,339 M against clang's 616 M (2.17 times);
- `yy_reduce`: 382 M against 56 M (6.8 times).

The rest is spread: most hot functions run 1.4 to 3 times clang's
instructions. In `sqlite3VdbeExec`, 6,828 of the 14,663 instructions are
`mov`s.

## Outputs

- **Verification hashes:** all four builds' `--verify` runs print the same,
  `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` (a hash of every
  query's results).
- **What else was compared:** every timed and counted run's output (56 in all),
  with its timings masked, against clang's first round's.
- **Set apart:** the lines that name the compiler (`COMPILER=` and
  `ATOMIC_INTRINSICS=`, below) and the process's I/O counts from
  `/proc/PID/io`. The direct path's executable reads 224 bytes fewer at load,
  and tcc's 744 more, with one more `read()`.
- **The result:** with those lines apart, ours, direct and clang print the same
  bytes in every run. tcc's builds report one successful lookaside allocation
  fewer in every run (1,115,930 against 1,115,931). The count follows tcc's
  `sqlite3.o`: linking its objects crosswise with clang's showed this, on the
  7940HS. SQLite configures itself otherwise under tcc's predefined macros.

## Limitations

- **The size:** one size, `speedtest.tcl`'s `--size 5`, at which a run takes
  0.29 s. speedtest1's own default, 100, wasn't measured.
- **Wall time:** it includes the process's start and exit, about 2 ms.
  `TOTAL` is speedtest1's own count, a millisecond per test.
- **The database on tmpfs:** each run reads 320 MB in 78,202 `read()` calls and
  writes 26.6 MB. That is the kernel's work, the same for every build: system
  time is 13 to 17 ms of the 290 (bash's `time`, tick-based).
- **The atomics:** under this compiler, SQLite configures itself with
  `ATOMIC_INTRINSICS=0`, because the compiler's `__has_extension(c_atomic)`
  answers what buster implements. Its `AtomicLoad` and `AtomicStore` are then
  plain accesses, where clang's build uses relaxed `__atomic` builtins: the
  same `mov`s at -O0. tcc's build has `ATOMIC_INTRINSICS=0` too. This compiler
  predefines clang 23.1.3's version (`COMPILER=clang-23.1.3`).
- **The direct path's build** is one translation unit, with `randomFunc`
  renamed. It writes no symbol table, so its profile names no function, and
  neither does tcc's executable's. Its code is the `-c` build's: 120 bytes
  less `.text`, and 170 thousand fewer instructions retired.
- **The profiles** are sampled every 1,000,003 instructions and every 200,003
  cycles. AMD's sampling skids, so the shares are approximate: the 7940HS's
  samples of the same code put `sqlite3VdbeExec` at 21.5% of Tier 0's
  instructions, not 19.5%.
- **cachegrind,** SQLite's own counter, couldn't run. The 9700X has no
  valgrind, and the 7940HS's glibc uses AVX-512, which valgrind 3.25.1 doesn't
  decode. `perf`'s `instructions:u` counts the same events: every user-space
  instruction, the loader's and libc's among them.
- **Main before jump tables:** this is main before #136's item 7 (`switch` as a
  jump table), which will change `sqlite3VdbeExec`'s and `yy_reduce`'s
  dispatch. The same scripts can measure it again once that merges.
- **The lock's messages:** its "exclusive.sh: waiting" lines, with their title,
  link and pull request lines, were removed from `measure.log` and
  `build-compiler.log`. Nothing else was changed.
