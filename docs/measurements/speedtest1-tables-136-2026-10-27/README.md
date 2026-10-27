# speedtest1 through Tier 0 before and after switch jump tables

2026-10-27, for [buster14a/buster#136](https://github.com/buster14a/buster/issues/136): the
[2026-10-26 speedtest1 measurement](../speedtest1-136-2026-10-26/README.md) again, now that `switch`
dispatches through a jump table where clang -O0's code does
([buster14a/buster#536](https://github.com/buster14a/buster/pull/536), #136's item 7). SQLite's own
benchmark, `test/speedtest1.c` at 3.53.2, built from the frozen corpus's `sqlite3.c` by this compiler
(Tier 0's code) on main just before and just after the jump tables' merge, by clang 23.1.1 at -O0 and
by tcc 0.9.28rc, and run on the 9700X, pinned to CPU 2.

## Source and inputs

- buster, two trees, each built with `BUSTER_DEBUG_INFO=0 ./build.sh` (`build-compiler.log`):
  - **before:** main at `b7f444eb52bb53495da751f188b6bba883bbf891`, the first parent of the jump
    tables' merge (#552's objects aligned past 16 bytes are in it);
  - **after:** `ad408cf2ec956860833db81e4333c5faa78390fe`, #536's merge into main.

  `manifest-before.sha256` and `manifest-after.sha256` list each measured tree's `build.sh`, `src` and
  `tests`, which match the commits' `git archive` byte for byte (498 files each).
- `sqlite3.c`, `sqlite3.h` and `speedtest1.c`: the earlier record's, byte for byte (`identities.txt`
  has their sha256): SQLite 3.53.2, Fossil check-in
  `d6e03d8c777cfa2d35e3b60d8ec3e0187f3e9f99d8e2ee9cac695fd6fcdf1a24`, the amalgamation from the frozen
  corpus `preprocessor-corpora-astra-01a158dd`, and `test/speedtest1.c` of that check-in (GitHub
  mirror commit `ccc132c5be20ab5c755c97a08d06b1b592fef330`; sha256
  `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675`). `speedtest1.c` is SQLite's
  source, in the public domain, and is not copied here.
- `speedtest1-unity.c`: ours, for the direct path, the earlier record's file.
- `identities.txt`: the trees' commits, the toolchain's versions, the kernel, the CPU, CPU 2's
  governor and EPP, and the sha256 of the inputs and of both measured `build/compiler`s.
  `files.txt` and `hashes.txt` list the objects and executables, which aren't recorded.

## Builds

As in the earlier record, with SQLite's own performance procedure's options (`test/speedtest.tcl` at
3.53.2): `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE`, each compiler's own level in place of the script's `-Os`, and no `-g`. Six
builds:

- **before** and **after:** each tree's `compiler -c` of `sqlite3.c` and of `speedtest1.c`, linked by
  `cc` (GCC 16.2.1's driver, GNU ld 2.47) with `-lm`.
- **before-direct** and **after-direct:** each tree's direct path, `compiler -o ... speedtest1-unity.c
  -lm`, one process.
- **clang:** `clang -O0 -c` of both files, linked by `cc`.
- **tcc:** `tcc -c` of both files, linked by tcc itself.

## Commands

The earlier record's scripts, made to measure two trees. `st-all.sh` ran detached on the 9700X and
took the shared lock twice:

1. `st-compiler.sh`: both trees' builds.
2. `st-measure.sh`: everything else, in one hold of about 3 minutes, pinned to CPU 2 (`st-env.sh`
   has the paths, options and steps):
   - `st-build.sh`: the six builds, the identities and sizes, and a `--verify` run of each
     (`verify-*.txt`), whose verification hashes must agree;
   - `st-compile.sh`: 11 rounds of the six builds in a rotating order (`compile.times`, in
     microseconds), each round's outputs the build step's, byte for byte;
   - `st-runs.sh`: one untimed warm-up run of each build, then 11 rounds in a rotating order
     (`run.times`: wall microseconds, bash's user and system seconds, speedtest1's own `TOTAL`;
     outputs in `runs/`);
   - `st-counts.sh`: 3 rounds under `perf stat -e instructions:u,cycles:u` (`counts/`);
   - `st-profile.sh`: a `perf record` of one run of each build per event, by function (`profile/`).

Each run starts from a fresh database on tmpfs, with SQLite's temporary files there too:

```sh
cd /tmp/speedtest1-136-claude/db
SQLITE_TMPDIR=/tmp/speedtest1-136-claude/tmp taskset -c 2 ./st-BUILD --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 speedtest1.db
```

`st-summary.sh` made `summary.txt` and `testsets.txt`, and `st-sections.sh` made `sections.txt`
(`size -A`) and `dispatch.txt` (`objdump -d`, GNU binutils 2.47), from the files copied off the 9700X.
`measure.log` is `st-all.sh`'s report.

## Results

Medians of 11 rounds (runs and compiles) and 3 (counts):

| | before (`-c`) | after (`-c`) | before-direct | after-direct | clang -O0 | tcc |
|---|---|---|---|---|---|---|
| speedtest1's run, wall time | 295.0 ms | **256.7 ms** | 296.5 ms | 255.4 ms | 295.9 ms | 271.6 ms |
| against clang -O0's | 0.997 | **0.867** | 1.002 | 0.863 | 1 | 0.918 |
| against before's same build | | **0.870** | | 0.861 | | |
| the rounds' range | 293.6 to 298.0 | 256.0 to 260.2 | 295.9 to 298.4 | 254.9 to 256.2 | 295.3 to 296.8 | 271.0 to 272.0 |
| speedtest1's own `TOTAL` | 0.292 s | 0.255 s | 0.294 s | 0.254 s | 0.294 s | 0.270 s |
| user-space instructions | 6,865.7 M | **5,685.9 M** | 6,865.5 M | 5,685.7 M | 3,921.8 M | 4,832.6 M |
| against clang -O0's | 1.751 | **1.450** | 1.751 | 1.450 | 1 | 1.232 |
| user-space cycles | 1,531.0 M | 1,319.3 M | 1,541.3 M | 1,314.8 M | 1,526.3 M | 1,402.8 M |
| instructions per cycle | 4.49 | 4.31 | 4.45 | 4.32 | 2.57 | 3.45 |
| `.text` of `sqlite3.o` | 1,292,088 B | 1,280,280 B (1.29) | | | 993,846 B | 1,254,666 B (1.26) |
| `.rodata` of `sqlite3.o` | 53,202 B | 64,434 B | | | 61,737 B | 60,898 B |
| `.text` of the executable | 1,331,336 B | 1,319,528 B (1.29) | 1,331,216 B | 1,319,408 B | 1,024,342 B | 1,295,452 B (1.26) |
| `sqlite3.c` compiled | 191.9 ms | 191.4 ms | | | 577.4 ms | 42.2 ms |
| the whole build | 219.1 ms (sum) | 218.6 ms (sum) | 200.4 ms | 199.8 ms | 623.6 ms (sum) | 48.6 ms (sum) |

Ratios of sizes in parentheses are against clang -O0's. "Sum" is the sum of the steps' medians
(`summary.txt`); the direct path's build is one process.

With the jump tables, Tier 0's code runs speedtest1 in **13.0% less time** than before them, in 17.2%
fewer instructions and 13.8% fewer cycles: 13.3% faster than clang -O0's code and 5.5% faster than
tcc's. The direct path's build moves alike (−13.9%). Before them, Tier 0's code ran at clang -O0's
speed, as the earlier record found at `e04462c1` (294.4 ms, 6,865.7 M instructions): the before
build's `sqlite3.o` and `speedtest1.o` are that record's byte for byte (`hashes.txt`).

By testset (`testsets.txt`, speedtest1's per-test times summed per testset in each run; medians), the
after build against the before one: `main` 0.87, `orm` 0.93, `cte` 0.85, `json` 0.95, `fp` 0.84,
`rtree` 0.91, `app` 0.80; and against clang -O0's, faster on every testset but `parsenumber`, the same
(1 ms).

The tables add 11,232 bytes of `.rodata` to `sqlite3.o` (2,808 four-byte entries) and 84 to
`speedtest1.o` (21), and take 11,808 bytes (0.9%) out of its `.text`. Compiling `sqlite3.c` takes no
measurable longer: 191.4 ms against 191.9 (−0.3%, within the rounds' spread).

## Where the instructions went

`dispatch.txt` counts the two largest switches' code in the cc-linked builds:

| | instructions | indirect jumps | compares of a register with an immediate |
|---|---|---|---|
| `sqlite3VdbeExec`, before | 14,663 | 0 | 262 |
| `sqlite3VdbeExec`, after | 14,312 | 5 | 83 |
| `sqlite3VdbeExec`, clang -O0 | 9,255 | 5 | 233 |
| `yy_reduce`, before | 10,656 | 0 | 363 |
| `yy_reduce`, after | 9,969 | 1 | 16 |
| `yy_reduce`, clang -O0 | 4,081 | 1 | 26 |

SQLite's bytecode interpreter now dispatches on its opcode as clang's code does, with a bounds check,
then the table's entry and an indirect jump (`dispatch.txt` shows both). From the sampled profiles
(`summary.txt`'s last tables: each function's share of `instructions:u` times the build's count), the
two functions account for 938 M of the 1,180 M fewer instructions:

- `sqlite3VdbeExec`: 767 M against 1,399 M before (0.55), and clang's 628 M;
- `yy_reduce`: 100 M against 406 M before (0.25), and clang's 47 M.

Next by the difference: `yy_find_reduce_action` (−47 M) and `sqlite3DbMallocRawNN` (−44 M), and
`yy_shift` +28 M, which the profile's attribution may move between neighbors. Against clang -O0's,
`sqlite3VdbeExec` keeps 1.22 times its instructions, and the rest is spread as before: the hot
functions run 1.3 to 2.6 times clang's.

## Outputs

- **Verification hashes:** all six builds' `--verify` runs print the same,
  `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`, the earlier record's.
- **What else was compared:** every timed and counted run's output (84 in all), with its timings
  masked, against clang's first round's, with the lines that name the compiler (`COMPILER=`,
  `ATOMIC_INTRINSICS=`) and the process's I/O counts set apart.
- **The result:** before, after, both direct builds and clang print the same bytes in every run; tcc's
  builds report one successful lookaside allocation fewer (1,115,930 against 1,115,931), as in the
  earlier record.

## Limitations

The earlier record's hold too: one size (`--size 5`, a run of about 0.26 s), wall time with the
process's start and exit, the database on tmpfs, `ATOMIC_INTRINSICS=0` under this compiler, the
profiles' sampling skid, and no cachegrind (`perf`'s `instructions:u` counts the same events).
Besides:

- **Two trees, not a switch:** before and after are two builds of the compiler, whose own code lands
  at other places; speedtest1's code is what changed, and its instructions are exact.
- **The lock's messages:** its "exclusive.sh: waiting" lines, with their title, link and pull request
  lines, were removed from `measure.log` and `build-compiler.log`. Nothing else was changed.
