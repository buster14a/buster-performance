# Host-independent Tier 1 objects (#1395, #2606), 2026-11-13

Evidence for buster14a/buster#2672, which makes `tier1_frame.c`'s scalar colorer compute the vector colorer's slots
exactly, so that `--tier1` and `--tier1 --scalar` (and so a baseline `x86-64` build) write the same objects.

## Revisions

- buster main `65ab5d8f129fd2c376f2bbbbdb1c938e86710617` (the PR's base) and the PR head
  `1c734269f5b922b30dc7159088f34a488b51a47c` (`adfbaee8` merged with that main; the merge brought front-end changes
  only). The container receipts were also taken at main `b7a95eed` and head `adfbaee8`, the same Tier 1 code.
- The trees on the 9700X were `git archive` of those commits, built with
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` (Release), each under the lock.

## Hosts

- **9700X**: benchpress, AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 (governor and EPP
  `performance`) for every timing, every step under `exclusive.sh` (`scripts/queue.sh`).
- **Container**: a Claude Code cloud container, Intel Xeon with the full AVX-512 set `host_isa.h` requires (VBMI2,
  BITALG, GFNI, VAES), so its native Release build takes the vector path; gdb stopped in
  `tier1_burs_classify_vector` under `check_program_emit_tier1` on `-c --tier1`. clang 23.1.6. No timings come from it.

## Identities (9700X)

| file | SHA-256 |
| --- | --- |
| main's `build/compiler` | `5361fe525dc778387323b6df59ecd9cda3137d88082ad9124d29e86f2aafa5c8` |
| head's `build/compiler` | `f5913a43ae8d8b5a0a71e48de6890bc98a12592f8e252c3f880e0f08c785ab28` |
| `sqlite3.c` (the frozen corpus's) | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| Lua 5.4.8 `src/*.c src/*.h`, concatenated | `d547f17810fb28276ed06b38547e3119f2018b098e56df2421f3a1741f2ab494` |
| `scripts/kernels.c` | `295b6916da7ebb9694d1440c2af51f11dc1a73c4317a2502814e8be794ae6307` |
| `scripts/driver.c` | `05afe5abb01b5ed0deeff954ee14b9d34aef6b014b6fc05772105ed52bff1604` |
| #1395's five functions (`issue.c`, below) | `15e5d269a384a49e3113e516a656f6b8101090cd83c48217e29d48a1041aef55` |

Lua 5.4.8 is lua.org's `lua-5.4.8.tar.gz` (SHA-256 `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae`,
the one buster's CI fetches). `issue.c` is the issue's code block:

```c
long m3(long x) { return x * 3; }
long m5(long x) { return x * 5; }
long m9(long x) { return x * 9; }
int  m3i(int x) { return x * 3; }
long a(long x, long y) { return x + y * 4 + 8; }
```

## Twin identity (`scripts/twins-run.sh`, `scripts/twins.sh`)

Each source by `-c --tier1` and `-c --tier1 --scalar`, the objects compared byte for byte (`cmp`); then
`test-ssa-source --tier1 --generate 48 --seed 1 --lifetimes --clang clang --keep` and each program's two executables.
Lua with `-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`; sqlite3.c with `-DSQLITE_OMIT_LOAD_EXTENSION
-DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`. Logs: `9700x/twins-*.log`.

| identical | main | head |
| --- | --- | --- |
| `issue.c` | 1 of 1 | 1 of 1 |
| Lua's 34 units | 33 (`lvm.c` differs) | 34 |
| `sqlite3.c` | 0 of 1 | 1 of 1 |
| random programs' executables | 10 of 48 | 48 of 48 |

On the container (`container/results.txt`): head gives c-testsuite's 220 single-exec tests, Lua's 34 units and
sqlite3.c identical, and `test-ssa-source --generate 300 --seed 1 --lifetimes --tier1` passes 300 of 300 with
the PR's executable check. At main, the same 300 programs, kept with `--keep` and compared with `cmp`, gave 226
differing executables of 300; that comparison's directory wasn't retained, only the run's totals line. `lvm.c`'s and
sqlite3.c's differences on main were frame offsets alone (`luaV_execute`'s `0x50`/`0x58`/`0x60` swapped). The vector
path's own objects are unchanged: head's `-c --tier1` objects of sqlite3.c and Lua's 34 units equal main's.

## #1395's chains (`scripts/run.sh`)

`kernels.c` by Tier 1 (default and `--scalar`), clang `-O0` and clang `-O2 -fno-vectorize`, each linked with
`driver.c` by clang `-O2`; 4,096 elements, 20,000 calls per run, 11 runs after one warm-up, on CPU 2; ms, median
(min-max in `9700x/chains-*.log`). Both builds' Tier 1 objects of `kernels.c` were identical by both paths.

| kernel | Tier 1 vector, main | Tier 1 scalar, main | Tier 1 vector, head | Tier 1 scalar, head | clang -O0 | clang -O2 -fno-vectorize |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `s = s * 5 + p[i]` | 29.5 | 29.5 | 29.5 | 29.5 | 59.0 | 29.4 |
| `s = s * 9 + p[i]` | 29.5 | 29.5 | 29.5 | 29.5 | 59.0 | 29.4–29.5 |
| `s = s * 4 + p[i]` | 29.6 | 29.5 | 29.5 | 29.5 | 44.6 | 22.1 |
| `s = (s * 3) * 3 + p[i]` | 44.2 | 44.2 | 44.2 | 44.2 | 103.2–103.3 | 29.4 |

#1395 reported 58.7, 58.7, 58.7 and 102.9 ms for the vector cover at main `ef25f566`; #1289's costs had already
fixed that, and both paths now run at the old scalar twin's times.

## `benchmark-tier1-frame` (`9700x/frame-*.log`)

`taskset -c 2 build/compiler benchmark-tier1-frame`, main and head interleaved, two rounds. Color phase, ns per
object (round 1 / round 2):

| shape | scalar, main | scalar, head | vector, main | vector, head |
| --- | --- | --- | --- | --- |
| leaf, 16 objects | 1.93 / 1.91 | 1.28 / 1.28 | 7.61 / 7.64 | 7.44 / 7.64 |
| calls, 256 | 1.66 / 1.69 | 1.76 / 1.79 | 27.2 / 27.4 | 26.4 / 27.4 |
| variadic, 4,096 | 1.60 / 1.58 | 4.51 / 4.23 | 58.1 / 58.8 | 55.8 / 58.6 |
| dynamic-realigned, 32,768 | 12.64 / 12.70 | 6.05 / 5.83 | 88.4 / 89.7 | 85.8 / 90.0 |

The scalar pass is faster on two shapes and slower on the variadic one, where each color is stored and read back
through memory (an item's color, then its level's) on a chain the old first-free scan didn't have, since its
comparisons fed only branches. Whole plans (`phase=total`) on the scalar path are the same or faster on every shape.
The vector path's code is unchanged; its numbers differ by noise. The vector colorer is 4 to 15 times slower than either
scalar one on this host: that is main's state, outside this PR.

## Frame tests

`test-tier1-frame` and `test-tier1-frame-execution`. On the 9700X, main: 2,277,543 checks and 14,619 checks, 0
failures (`9700x/frame-tests-main-65ab5d8f.log`). Head on the container: 2,277,958 checks (main's plus the PR's
identity checks and fixture) and 14,619, 0 failures; with the old first-free colorer restored, 44 failures, and with
`--count 1` the PR's two checks alone fail. Head's 9700X run was still waiting for the lock when this record was
written; a later commit adds it.

## Limitations

- The identity checks compare one compiler build's two host paths on one host (`--scalar` against the default). A
  baseline `BUSTER_HOST_ARCH=x86-64` build wasn't built for this record; its `tier1_frame_plan` calls the same scalar
  colorer (`host_isa.h` makes every `BUSTER_VECTOR_PATH` false there).
- The chain kernels measure generated code, two builds whose kernel objects are identical; they show #1395's
  performance half stays fixed, not a change this PR makes. The frame benchmark is synthetic (four shapes); it isn't a
  compile-time measurement, and a Zen 5 host's compile runs the vector colorer, which this PR doesn't change.
- Container results come from a different machine and clang (23.1.6) and carry no timing.
- sqlite3.c and Lua 5.4.8 are external inputs identified by hash above; they aren't included here. Everything in
  `scripts/` is original to this record.

## Logs

`9700x/` keeps only the lines these scripts print: `exclusive.sh`'s waiting notices, which name other sessions'
holds, are removed. `container/results.txt` has the container's summary lines, with its work directory written
`$WORK`.
