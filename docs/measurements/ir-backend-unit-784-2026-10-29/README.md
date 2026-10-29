# The IR's source commands in the backend's unit, Buster #784

Compiler branch: `claude/ir-backend-unit-784` of buster14a/buster, for
[this claim on #784](https://github.com/buster14a/buster/issues/784#issuecomment-6489490231).

The branch moves `test-ir-source` and `benchmark-ir-source` from the checker's
translation unit, the build's longest, to the backend's. It shares the x86
encoder's templates between `main.c`'s units (`BUSTER_X86_SHARED`, the driver
unit's), so that the checker's emission and the IR adapter's validation in
another unit read one copy. It homes their check and emission
(`ir_source_prepare`) in the checker's unit, so that the checker's unit no
longer compiles the IR's modules. This record holds the 9700X's comparison of
the checker's unit's compile time and of `-c`, whose encoder's tables moved.

## Sources and host

Each tree is a `git archive` of its commit, extracted into a fresh directory on
the 9700X; `logs/manifest-*.sha256` lists every file's SHA-256 as the host had
it after the runs, which matched `git archive` of the commits file for file:

- **main:** `d11a91d2470784f627e9b69537f6b491ab8f2c5b`, the branch's base;
- **head:** `d1c21464bd2373ff02e3bcfb6bed5f52c4e8edd9`.

Host (`logs/host.txt`, captured after the runs, from the same session): AMD
Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2's governor
and energy preference `performance`. Every build, measurement and the receipts
took a separate hold of the host's lock (`exclusive.sh`), and every measurement
ran pinned to CPU 2. The lock's waiting messages are left out of the logs, since
they name other jobs: only the lines the scripts, `build.sh`, `ab` and
`time-runs` print are kept (an allowlist of their shapes).

Builds: `BUSTER_DEBUG_INFO=0 ./build.sh`. `logs/executables.sha256` gives the
executables' SHA-256 as the host had them after the runs; the placement step
rebuilt each tree's `build/compiler` from the same sources and flags before
linking its shifted copies, so the `perf stat` pairs ran the executables before
that rebuild.

Input: SQLite 3.53.2's `sqlite3.c` from the host's frozen corpora
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE`.

## Results

`scripts/q784.sh` (`logs/progress`), main and head alternating, the order
turning each round:

- **The checker's unit** compiled alone by each tree's flags (`./build.sh
  print-compile-flags`, `-O3` without `-g`), pinned to CPU 2, three rounds
  (`logs/pair-checker-unit.log`): main 26,705, 26,693 and 26,735 ms; head
  25,574, 25,559 and 25,582 ms (−1.13 s, −4.2%).
- **The whole builds** (`logs/build-*.log`, one each, the compiles one per
  core): main 32.2 s, its checker's unit the longest at 32.2 s and the
  backend's 27.4 s; head 31.1 s, 31.1 s and 27.8 s.
- **`-c` of `sqlite3.c`**, `perf stat -r 11` per tree per round
  (`logs/pair-compile-*.csv`, exit statuses in `logs/pair-compile.log`): the
  objects are byte-identical (`cmp`'s status 0 in `logs/progress`); user
  instructions 1,314.119, 1,314.125 and 1,314.119 million (main) against
  1,314.119, 1,314.125 and 1,314.125 million (head); user cycles 608.3, 603.1
  and 602.1 million against 604.4, 604.7 and 604.3 million.
- **`-c` over placements** (#509's method; `logs/shifts-*.log`,
  `logs/placements.log`): each tree linked six times with the checker's unit
  shifted by 0, 640, 1,344, 2,048, 2,752 and 3,456 bytes, each link run from
  three fresh copies, main's links again as the floor (`main-again`), three
  rounds of `time-runs` under `ab`:

  | Round | head, wall | main-again, wall | head, user cycles | main-again, user cycles |
  | ---: | ---: | ---: | ---: | ---: |
  | 1 | +0.01% | −0.18% | −0.02% | −0.18% |
  | 2 | +0.13% | +0.12% | +0.19% | +0.22% |
  | 3 | +0.04% | +0.06% | −0.03% | +0.18% |

  Every range over the placements includes 0.

## Limitations

The checker unit's times are one compile per tree per round. The host receipts
were captured after the runs.
