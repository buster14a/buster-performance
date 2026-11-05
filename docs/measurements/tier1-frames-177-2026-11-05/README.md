# Tier 1's frames on the 9700X (#177, 2026-11-05)

These are the 9700X records for [buster#177](https://github.com/buster14a/buster/issues/177):

- frame sizes against `clang -O2` on the corpora's functions, with and without the objects' lifetimes;
- the run-time effect of slot sharing (`--tier1-no-lifetimes`) and of keeping the frame pointer
  (`-fno-omit-frame-pointer`, new in this head) on `speedtest1` and Lua 5.4.8's five scripts.

The pull request is [buster14a/buster#1415](https://github.com/buster14a/buster/pull/1415), head
[`824caec5`](https://github.com/buster14a/buster/commit/824caec53e1e5d25e1c7ca8eeaf0d1eefb3a6f85), against main
[`483e5f70`](https://github.com/buster14a/buster/commit/483e5f70d54ff8adccf011e773de4c04abd6489c).

## Setup

- **Host:** benchpress, an AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1.
- **Builds:** both trees by `BUSTER_HOST_ARCH=znver5 ./build.sh`.
- **Lock:** every step under `~/buster-fast-bench/exclusive.sh`, one hold per step.
- **Timing:** every timed run pinned to CPU 2 by `time-runs`, 11 runs after one warm-up, in rotating order.
  - Lua's runs used `--copies 3`, so 33 runs per build and script.
  - speedtest1's runs go through a wrapper per build (`out/st/run-t1.sh` is one of them). The wrapper removes the
    database and SQLite's temporary directory on tmpfs, then execs the build with #136's options. Its startup is the
    same for every build.
- **Inputs:**
  - the frozen corpus's `sqlite3.c` (SQLite 3.53.2) and SQLite 3.53.2's `test/speedtest1.c`, as one unit with #136's
    flags;
  - Lua 5.4.8, built as its Makefile's linux target builds it, and the five original scripts of #141's records
    (`claude-141-reciprocal/lua`).
- **Harness:** [`run177.sh`](run177.sh), run as `run177.sh 824caec5`. Its log, `out/steps.log`, is on benchpress
  (below). [`frames177.sh`](frames177.sh), run as `frames177.sh 07e4552a`, measured the frames again with #1415's
  review's control-flow reading; its log is [`out/frames2/steps.log`](out/frames2/steps.log).

| Build | Command |
| --- | --- |
| t0 | `compiler` (Tier 0) |
| t0fp | `compiler -fno-omit-frame-pointer` |
| t1 | `compiler --tier1 -fno-asynchronous-unwind-tables` |
| t1fp | t1 with `-fno-omit-frame-pointer` |
| t1nl | t1 with `--tier1-no-lifetimes` |
| clang2 | `clang -O2` |
| clang2fp | `clang -O2 -fno-omit-frame-pointer` |
| clang0 | `clang -O0` (Lua's output reference and frames) |

## Correctness

- **The default objects are unchanged.** head's `-c sqlite3.c` by Tier 0 and by `--tier1` gives objects byte-identical
  to main's (`t0-same` and `t1-same`, the last lines of `out/identity.txt` on benchpress). Without `-fno-omit-frame-pointer` the
  frames are as before.
- **speedtest1:** `--verify` gives one verification hash by all seven builds ([`out/st/verify.txt`](out/st/verify.txt)).
- **Lua:** each script's output by every build is clang -O0's byte for byte, 35 of 35
  ([`out/lua/compare.txt`](out/lua/compare.txt)).

## Frame sizes against clang -O2

`measure-frames` (`frame_measure.c`) decodes each function's code from the file's symbol table. A function's frame is
the most bytes it takes below its return address on any path of its control flow:
- each instruction's depth on entry is its predecessors';
- pushes and `sub rsp` add, pops and `add rsp` take back, and `mov rsp, rbp` and `leave` go back to rbp's;
- in an object, a relocated jump (a tail call) leaves the function;
- code only a jump table reaches takes its indirect jump's depth (`assumed`), padding none;
- paths that join at different depths are `unresolved`, and the comparison leaves them out.

These numbers are buster#1415's head `07e4552a` (#1415's review: the depth along the control flow) reading
`run177.sh`'s objects and executables again under the lock (`frames177.sh 07e4552a`). That commit changes the reader,
not the code the objects hold. The comparison runs over the functions both files have, each name once: `sqlite3.c`'s
`-c` objects and Lua's executables. Every file's summary line is in [`out/frames2/summary.txt`](out/frames2/summary.txt);
the per-function lines are on benchpress (below).

| Corpus | Build | Functions in common | Their frames, bytes | Against clang -O2 | Median per-function ratio | Larger / equal / smaller |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| sqlite3.c | clang -O2 | 1,600 | 112,744 | 1.000 | 1.000 | |
| | `--tier1` | 1,600 | 168,296 | 1.493 | 1.667 | 1,304 / 195 / 101 |
| | `--tier1-no-lifetimes` | 1,600 | 169,704 | 1.505 | 1.667 | 1,306 / 194 / 100 |
| | Tier 0 | 1,600 | 143,400 | 1.272 | 1.250 | 917 / 468 / 215 |
| | clang -O0 | 1,600 | 144,160 | 1.279 | 1.500 | 1,197 / 245 / 158 |
| Lua 5.4.8 | clang -O2 | 653 | 55,896 | 1.000 | 1.000 | |
| | `--tier1` | 653 | 80,928 | 1.448 | 2.500 | 576 / 54 / 23 |
| | `--tier1-no-lifetimes` | 653 | 81,600 | 1.460 | 2.500 | 576 / 54 / 23 |
| | Tier 0 | 653 | 67,896 | 1.215 | 1.333 | 373 / 197 / 83 |
| | clang -O0 | 653 | 68,280 | 1.222 | 1.500 | 490 / 108 / 55 |

The per-function ratio is (bytes + 8) / (clang -O2's + 8), so that the return address counts.

- **Nothing in `sqlite3.c` is unresolved**, by any build. 59 of clang -O2's functions and 49 of each other build's are
  assumed (jump tables). In Lua's executables only the C runtime's `_start`, which pops past its entry, is unresolved
  (clang's builds), and it is left out.
- **What the earlier reading got wrong:** a first reading in address order (`run177.sh`'s,
  [`out/frames/summary.txt`](out/frames/summary.txt)) undercounted clang -O2's frames: 112,032 bytes on `sqlite3.c`,
  where the control flow gives 112,744. clang's shrink-wrapped paths and early returns lost bytes there, and so did its
  pushed stack arguments. Tier 0's and Tier 1's frames come out the same either way.
- **Slot sharing** saves 0.8% of the frames: 1,408 bytes on `sqlite3.c`, 672 on Lua.
- **Tier 1's frames are larger than Tier 0's.** Over all 2,668 of `sqlite3.c`'s functions, Tier 1's frames are 242,384
  bytes against Tier 0's 189,512, larger in 1,869.
  - **The cause:** in a function with calls, the CFG consumer gives a call-save row to every caller-saved register in
    `call_save_mask`, and keeps all of them in the frame for the whole function (`tier1_emit_cfg.c`'s frame rows: start
    0, end at every position), whether a value is saved there at a call or not.
  - **An example:** `sqlite3GetInt32` takes 104 bytes by Tier 1 (four pushes and `sub rsp, 0x48`, its one object at
    `0x40`), 72 by Tier 0 and none by clang -O2. 64 of Tier 1's bytes are eight call-save rows.

## Run time

Medians of the runs on CPU 2: [`out/st/time-runs-medians.txt`](out/st/time-runs-medians.txt) and
[`out/lua/time-runs-medians.txt`](out/lua/time-runs-medians.txt) have each build's medians, Lua's against t0 with its
range over the copies; every run's line is on benchpress (below).

speedtest1, 11 runs:

| Build | Wall, ms | User cycles, M | Instructions, M |
| --- | ---: | ---: | ---: |
| t0 | 255.16 | 1,316.0 | 5,687.9 |
| t0fp | 275.91 (+8.1%) | 1,431.7 | 5,888.9 |
| t1 | 199.95 | 1,012.9 | 3,687.7 |
| t1fp | 214.99 (+7.5%) | 1,092.2 | 3,918.6 |
| t1nl | 202.81 (+1.4%) | 1,026.7 | 3,749.8 |
| clang2 | 131.10 | 633.5 | 2,012.1 |
| clang2fp | 133.39 (+1.7%) | 645.2 | 2,060.4 |

Lua 5.4.8's scripts, wall-time medians in ms, 33 runs each:

| Build | calls | tables | strings | arithmetic | closures | Sum |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| t0 | 34.94 | 66.57 | 63.07 | 71.93 | 97.01 | 333.52 |
| t0fp | 35.43 | 75.98 | 69.00 | 73.94 | 110.17 | 364.52 (+9.3%) |
| t1 | 30.95 | 49.42 | 52.64 | 56.56 | 69.24 | 258.79 |
| t1fp | 32.02 | 58.62 | 53.99 | 58.89 | 76.22 | 279.75 (+8.1%) |
| t1nl | 49.14 | 55.09 | 54.35 | 72.44 | 88.36 | 319.37 (+23.4%) |
| clang2 | 18.22 | 32.84 | 36.27 | 32.02 | 45.60 | 164.95 |
| clang2fp | 19.05 | 34.65 | 37.37 | 33.02 | 48.62 | 172.71 (+4.7%) |

Each percentage is against the same tier without the option.

- **Slot sharing (lifetimes)** is worth 1.4% on speedtest1 (1.7% fewer instructions) and 23% on Lua's scripts.
  - Lua's calls script runs 59% longer without lifetimes, with a wide spread over its copies (21.7%).
  - Without lifetimes, promotion also loses the block starts at which locals become undefined (#1117's fix of
    `luaV_execute`'s phis), which is likely most of that.
- **Omitting the frame pointer** is worth 7.5% (speedtest1) and 8.1% (Lua) to Tier 1, and 8.1% and 9.3% to Tier 0,
  where clang -O2 loses 1.7% and 4.7% by keeping it. Both tiers then lose rbp as a register:
  - Tier 0 loses a depth;
  - Tier 1 loses rbp from the callee-saved registers that values live across calls take, so they spill sooner (t1fp
    runs 6.3% more instructions than t1 on speedtest1).

## Limitations

- **One host, one toolchain:** the 9700X with clang 23.1.1. The builds are whole-process runs, which `time-runs`
  compares; the same code moves up to 2% from another placement (docs/profiling.md).
- **Ours and clang's builds differ in shape.** speedtest1's builds by this compiler are one translation unit (its
  direct path), clang's two objects linked, as #136's records have them.
- **Shared functions only:** frame sizes compare only functions both builds have. 1,068 of `sqlite3.c`'s 2,668
  functions aren't in clang -O2's object, inlined or removed.
- **What the frame size counts:** pushes and immediate subtractions only. A dynamic allocation (`sub rsp, reg`) and a
  realignment's gap aren't counted; `measure-frames` reports the alignment apart.

## Files kept on benchpress

These files are too large to publish through this session's tools. They stay in
`~/buster-fast-bench/177-claude/out/` on benchpress:

| File | Bytes | SHA-256 |
| --- | ---: | --- |
| `frames/sqlite3-frames.tsv` (each function's frame, by build, address order, superseded) | 477,786 | `4e00d1cf6311b84a8a8a3978b03d22322d949c4c68e949a2246741ad177d5e42` |
| `frames/lua-frames.tsv` | 159,519 | `0b1e8bab248f06bf18950e5c14000d7aba62c523234ff8abb18e47acb6ae73d3` |
| `lua/time-runs.txt` (every run's line) | 238,843 | `e6dd35c9f28dd68dc904e3e001f8f29b5ac29577d503d786ae8f0535cb9d303e` |
| `st/time-runs.txt` (every run's line) | 16,151 | `216b4e152b90146c32a7aec420f0e8df687023b263a44f5e889af0b8c53c51e0` |
| `identity.txt` (the objects' comparison, with the compiles' warnings) | 2,799 | `6bc69831748c87b3db5a6d13d9ddb0b7a0b33f31b8dac16f886b6c2a7d645656` |
| `steps.log` (the harness's log) | 6,265 | `adf18ad0909771da3f3731d0122f1acd0208d3ecdf314a50b834ee60993a4c7f` |
| `frames2/sqlite3-frames.tsv` (each function's frame and state, by build, at `07e4552a`) | 588,201 | `d5cce4c05f89da147bd6bc8daf718677b9db432ad3563eded7235365dc31f110` |
| `frames2/lua-frames.tsv` | 204,603 | `c062a81fa43b9a4735cd3f47fa34ce6a8ec948225a99cf62bd4e010ab4127c29` |

`run177.sh` and `frames177.sh` write them again from the same commits.
