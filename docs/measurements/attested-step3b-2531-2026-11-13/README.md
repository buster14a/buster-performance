# Attested declarations, step 3's second part: the passes, and the reader's tree from a lane's cache (2026-11-13)

[buster#2531](https://github.com/buster14a/buster/issues/2531)'s step 3 (`docs/attested-declarations.md` in buster)
takes what a skipped declaration's tokens still cost out of the compile. [Its first part's
record](../attested-step3-2531-2026-11-13/) left the gate unheld. This record measures the second part, the branch
`claude/dazzling-noether-ayffn9` of buster (its pull request has the code): the passes before the reader (a function
definition's own semantic hash, a lane's cache of the declarations' lists, a body's entries each once, fetches ahead),
the reader's tree columns from the same cache, its system tokens from the passes' levels, and the expressions' walk
passing a skipped declaration by. **The gate isn't held**: a skipped token still costs the reader about 50 cycles on
musl and 32 on the glibc units (the gate's 20), and with #2638, as main has it now, the commands are 1.258 and 1.671
times faster than without attested declarations (1.26 and 1.7). Against main the head is 1.020 and 1.046 times faster
by one lane, every object and diagnostic the same.

- **Sources.** Base is buster main's `b7a95eed` (the branch's base). The final head is the branch's `a4377af2`, whose
  `src/` is the host's `head` tree's to the byte (the SHA-256 of every file's SHA-256 under `src/`, `29f013c3…`, the
  same on both; base's, `462a5e79…`, is `b7a95eed`'s; the branch's `95fdb867` after it changes a guide alone).
  `final/env.txt` has the executables' SHA-256; `dev/trees-md5.txt` has each development tree's two changed files' MD5,
  which are those of the branch's `4c62186a` (`h2`), `0818cb3b` (`h3`) and `9a13cba9` (`h4`). Main took
  [buster#2638](https://github.com/buster14a/buster/pull/2638), the preprocessor's
  `-Wreserved-macro-identifier` fix, after the branch's base: the trees `b38` and `h38` are base and head with its
  diff (`a88b7c3c` against `26f0bb0e`, which applies to both as it is), the state main has now. Every tree was built
  on the host by `scripts/build.sh` (Release, the host's native target, `BUSTER_DEBUG_INFO=0`).
- **Host:** the Ryzen 7 9700X, `final/env.txt`. Every step ran in a hold of the lock (`exclusive.sh`), a few short
  steps a hold, from a cloud session (`scripts/bp3b.sh`, `scripts/queue11.sh`); one lane pinned to CPU 2, eight to
  CPUs 0 to 15, all with `setarch -R`. Its TSC is 3,792.9 MHz; the cores ran at about 5.5 GHz in these commands, so
  that a TSC tick is about 1.46 cycles.
- **Workloads:** musl's 1,336 units and the 512 generated units over the host's glibc headers as one `-c` command,
  as [the steps 1 and 2 record](../attested-skip-2531-2026-11-13/) has them; `-c sqlite3.c`; a small unit 50 times a
  round. For the residual, [the design record](../file-scope-design-672-2026-11-12/)'s preprocessed units, as they
  are and with the emulation's skipped tokens gone (`scripts/gone.sh`).

## The probe (`dev/probe/`, `final/probe-*`, `scripts/probe-*.py`)

A measurement patch (`scripts/probe.py`, `probe-b.py`, `probe-c.py`, `probe-d.py`, each on the last; applied to
`c_check_input.c` and `c_check_attested.c` in a tree of its own, never committed) sums the TSC ticks of each phase of
`check_input_run` and of each pass before it, over the command, printed after every unit with
`BUSTER_PROBE_PHASES=1`; `scripts/probe-report2.py` gives them a token of the units. On main (`dev/probe/probe-*-m1`,
`-g1`) and on the final head (`final/probe-*-f1`, `-f2`), in ticks a token:

| | musl, main | musl, head | glibc units, main | glibc units, head |
| --- | ---: | ---: | ---: | ---: |
| the passes | 27.8 | 20.6 | 24.3 | 17.6 |
| … the lists (with the own hashes on the head) | 7.9 + 3.6 | 8.0 | 9.1 + 3.5 | 6.7 |
| … the literals; the chain; the reach | 3.9; 5.6; 4.4 | 2.4; 4.5; 4.0 | 2.7; 5.1; 1.9 | 2.6; 5.1; 1.8 |
| … the tokens' levels | 2.0 | 1.3 | 1.8 | 1.2 |
| the reader's tree columns | 7.9 | 6.2 | 7.4 | 3.3 |
| the reader's system tokens (with three other passes) | 2.4 | 1.4 | 2.3 | 1.3 |
| the reader's expressions' walk | 28.6 | 24.5 | 11.9 | 7.0 |
| the reader, all of it | 157.4 | 148.6 | 76.1 | 66.8 |

The first probe (`dev/probe/probe-*-m*`, `-g1`) located the costs, each development tree's the changes as they were
made (`h1` the definitions' hash and the lists' cache, `h2` and copies and fetches, `h3` the trees from the cache, `h4`
and `h5` the trees as halfwords; `p4`'s split of the clears is in `probe-*-h4a`). The probe's own print, after each
unit, is left out of every figure.

## What a skipped token still costs (`final/gone/`, `scripts/gone-report.py`)

The reader's phases and the passes over the design record's preprocessed units as they are, with the compile's skip,
less the same units with the emulation's skipped tokens gone (both with the probe; the least of two rounds each way),
over the tokens the compile skipped, in ticks (`final/gone/residual.txt`; main's is the base's probe tree):

| | musl, main | musl, head | glibc units, main | glibc units, head |
| --- | ---: | ---: | ---: | ---: |
| the reader | 47.0 | 34.0 | 33.1 | 21.9 |
| … its walk; its expressions' walk | 12.0; 11.4 | 10.4; 4.3 | 5.9; 8.8 | 6.1; 3.1 |
| … its tree columns; the events' test | 7.8; 4.4 | 4.9; 4.3 | 7.3; 1.5 | 2.5; 1.5 |
| the passes | 42.9 | 32.7 | 26.3 | 18.7 |
| both | 89.9 | 66.8 | 59.4 | 40.7 |

- **The two sets differ.** The compile skips 2,895,449 of musl's tokens where the emulation removed 2,954,264: the
  compile reads 58,815 tokens the gone units lack, about 2% of the skipped, and a read token costs the walk about 220
  ticks, about 4.5 of the walk's 10.4 ticks a skipped token. The glibc units' sets differ by 6,894 tokens, whose
  figures stand as they are.
- **In cycles** (1.46 a tick) the reader's residual is about 50 cycles a skipped token on musl (about 43 without the
  sets' difference) and 32 on the glibc units, against the gate's 20; main's was 69 and 48, and the design's
  measurement patch's 68 and 60.

## The batches

| directory | queue | trees | what |
| --- | --- | --- | --- |
| `dev/rounds-h2/` | (by hand, `scripts/bp3b.sh batch "trees …"`) | `base:off`, `base`, `h2` | three rounds, one lane |
| `final/` | `queue11.sh` (`queue9.sh`'s first rounds, stopped for the expressions' change, aren't kept) | `base:off`, `base`, `head`, `b38:off`, `b38`, `h38` | every object compared; the probe; the residual; seven rounds by one lane, seven by eight, five of `sqlite3.c` and the small unit |

`TREE:off` runs TREE with `--attested=off`.

## Results

### Every object and diagnostic (`final/compare.txt`)

By the head, `--attested=on` against `--attested=off` and against `--scalar`: musl's 1,336 objects and 321 warnings,
the glibc units' 512 objects, `sqlite3.c` with `shell.c`, by one lane and by eight, with `-Wall -Wextra` (1,867
warnings), and `--attested=verify` by one lane and eight and with `-g`: the same bytes, no contradiction (`verify`
also makes each unit's tree columns whole and compares them with the cache's), no unlisted event, no unit read
again. musl's command skips 259,860 of 297,004 declarations, the glibc units' 272,239 of 298,334, as on main.

### Times

`final/medians.txt` (`scripts/stats.py`'s medians); "ms" is task-clock, the threads' CPU time.

| one lane, the median of 7 | `--attested=off` | main | the head | head against main | against `off` (gate) |
| --- | ---: | ---: | ---: | ---: | ---: |
| musl, base `b7a95eed`: ms (M cycles) | 1,003.5 (5,558.5) | 833.2 (4,615.1) | 817.3 (4,525.9) | 1.019 | 1.228 |
| musl, with #2638 (main now): ms (M cycles) | 943.0 (5,223.8) | 764.6 (4,234.5) | 749.6 (4,150.8) | 1.020 | **1.258** (1.26) |
| musl: M user instructions, base; with #2638 | 11,528.8; 10,284.2 | 8,973.8; 7,729.2 | 8,603.7; 7,359.1 | | |
| glibc units, base: ms (M cycles) | 835.8 (4,631.5) | 545.9 (3,024.2) | 521.6 (2,890.1) | 1.047 | 1.602 |
| glibc units, with #2638: ms (M cycles) | 796.6 (4,415.2) | 498.9 (2,764.2) | 476.8 (2,641.7) | 1.046 | **1.671** (1.7) |
| glibc units: M user instructions, base; with #2638 | 11,196.7; 10,354.1 | 6,637.6; 5,795.1 | 6,075.6; 5,233.1 | | |

- **Each round's ratio** (the trees alternate within each round's hold): musl's head against main 1.015 to 1.024
  (with #2638, 0.984 to 1.023), against `off` 1.224 to 1.230 (with #2638, 1.210 to 1.262); the glibc units' head
  against main 1.046 to 1.050, against `off` 1.595 to 1.608 (with #2638, 1.668 to 1.672).
- **Eight lanes** (seven rounds, CPUs 0 to 15): musl's command 1,453.1 against 1,455.6 CPU ms and 209.2 against 205.7
  wall ms; the glibc units' 971.1 against 974.1 CPU ms and 136.2 wall ms each. The head's user cycles are main's or
  fewer, its kernel cycles 40 to 60 M more in every round (2,640.3 against 2,683.7 M on musl, 1,288.2 against
  1,341.5 M on the glibc units), with 2,500 to 3,200 more page faults: each lane fills its own caches (the lists',
  the trees' and the bodies' marks), whose arenas take huge pages past their first base pages. By one lane the head's
  kernel cycles are 9 and 2 M more.
- **`-c sqlite3.c`**: 123.9 against 123.3 ms, 1,353.4 against 1,353.6 M user instructions; a small unit's process
  1.3 ms each, 8.5 M instructions (a command of one unit runs no passes).

### The gate

Step 3's gate, as the design states it: a skipped token costs `check-input` at most 20 user cycles, and the
cumulative factor is at least 1.26 on musl's command and 1.7 on the glibc units'.

- **Per skipped token:** the reader's residual above, about 50 cycles on musl (43 without the sets' difference) and 32
  on the glibc units: not held. What it still is, by phase: the walk (its tokens' columns spread among the skipped
  ones', about 6 to 10 ticks), the tree columns copied from the cache (2.5 to 4.9), the events' test (1.5 to 4.3),
  the expressions' walk's remainder (3 to 4), the clears and fills (about 2), and the passes besides (19 to 33 ticks).
- **Cumulative, by one lane:** against main with `--attested=off`, 1.228 on musl and 1.602 on the glibc units at the
  branch's base; with #2638, main's state now, 1.258 (rounds 1.210 to 1.262) and 1.671 (1.668 to 1.672): not held,
  musl's within its rounds' spread of it. The `--attested=off` runs' level moved between batches the day before (the
  first part's record: 1,014.0 and 1,060.6 ms on musl, the same instructions); here they are 1,003.5 ms, and each
  round's trees run in turn within one hold.

## Locally (`local/`)

In a cloud VM, `measure-attested --twins` over musl's units and the glibc units (the VM's headers): the lists' cache
and the walk agree (`twins differences=0`), and every unit's tree columns from the cache are the whole unit's
(`trees … mismatches=0`); the caches' counts (`lists cached=275384 made=21620 kept=3036` on musl). The whole
`test-checker` (829,706 checks), `test-check-units`, `test-check-lanes` and `test-checker-deferred`: no failure; the
scalar baseline's (`BUSTER_HOST_ARCH=x86-64`) build, its `test-checker --attested` and `test-check-units`: no failure.

## Limitations

- The probe's ticks are wall time on CPU 2, the kernel's included; the rounds' figures are `perf stat`'s.
- The residual's sets differ by 2% on musl (above).
- Other holders shared the lock throughout; each step held it for under a minute, and each round's trees run in turn
  within one hold.
