# The windowed directive tables and long lines (#451 parts 2 and 3), 2026-10-26

[buster14a/buster#451](https://github.com/buster14a/buster/issues/451)'s part 2 asked where the 0.016 ms that
preparing `sqlite3.c` a window at a time added to the directive tables (at #408's head) went, and part 3 whether a
long logical line, which a window's end cuts and the next window lexes again, could be lexed once. Part 1 is
[#462](https://github.com/buster14a/buster/pull/462)'s record.

In short:

- **Part 2.** At main `e7f386c2`, without #439's line pages (which count each window's line ends while it is cached,
  inside the directive phase), the directive tables a window at a time already took less than whole: 217 against
  225 µs for `sqlite3.c`. The windowed path's own costs were the directives' places, taken out of the scan's words a
  bit at a time (45.5 µs), and `pp_finish_directives`' reads after the early windows' columns had left the caches
  (127.7 µs against 106.8 whole). `pp_directive_places` now takes the places by `vpcompressb` (33.3 µs), and
  `pp_finish_directives` prefetches 16 directives ahead (106.5 µs a window at a time, 97.6 whole). `sqlite3.c`'s
  directive tables a window at a time took 0.313 ms against main's 0.343. The phase's remaining difference from whole,
  +0.029 ms, is the line pages' 58 µs less the 30 µs that the rest now takes less than whole.
- **Part 3.** A window whose end would cut a line of more than 4 KB is cut after the line end before it
  (`pp_window_cut`): `x86_64_encoder.c`'s 157 KB macro is lexed once. The frozen `main.c`'s twelve windowed files,
  5,541,811 bytes, were lexed over 5,656,758 bytes at main and are over 5,553,313; lexing them took 5.449 ms against
  5.513 (+0.012 ms over whole files, against +0.049). `sqlite3.c`'s windows lex exactly what they did.
- **The review** ([#486](https://github.com/buster14a/buster/pull/486), below and `review/`). The scan now stops at a
  short tail, a window whose only line end comes before a long line doubles unlexed, the bound is 16 KB, and the places
  skip groups of eight words without a directive. On a generated file of macros spliced over 20 to 200 KB the
  reviewed head's windows lexed 11.70 MB for its 8.02 MB, main's 10.79 MB, and the revised cut's 8.09 MB; in one
  binary, the cut costs nothing where windows end as main's do and spares that file 0.83 ms of lexing.

## Trees

| Name | Source | What it is |
| --- | --- | --- |
| `main451` | `e7f386c2` | main (the build #453's record calls `main453`, linked here) |
| `sub` | `e7f386c2` and `screening/subphases.py` | main with TSC counters around the directive tables' parts and a count of the bytes lexed |
| `sub3` | the first form of the cut and `subphases.py` | the cut whenever the line before is shorter than the tail, no 4 KB bound |
| `sub2` | `e7f386c2`, `subphases.py` and `screening/variants451.py` | `sub` with the places by `vpcompressb` and the prefetch as switches (`BUSTER_451_VARIANT` 1 and 2) |
| `final451` | the pull request's code, as committed in `83145af0` | the 4 KB cut, the places and the prefetch |
| `sub4` | `final451` and `subphases.py` | the pull request's code with the counters |

Each tree was sent by tar; `source-*.sha256` holds the SHA-256 of each of its files, `binaries.sha256` the executables'
(each built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`, `build-*.log`). The counters (`subphases.py`) add
`rdtsc` around each part and per-pass samples; they report the median of a process's passes after the warm-up.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each
round took the shared lock on its own (`EXCLUSIVE_OWNER=claude-perf-451`); the lock's waiting messages, which name other
runs, are removed from the logs.

## Method

`benchmark-preprocessor --only vectorized`, on #408's frozen `sqlite3.c` and `main.c` (the latter in its frozen tree
with `-march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h`; #451 part 1's record has both inputs'
identities), with `SOURCE_DATE_EPOCH=1792454400` and the include-path variables unset, a window at a time (the default
128 KB) and whole (`--window-bytes 2000000000`), pinned to CPU 2. Each round, one hold of the lock, runs every case of
every tree as a process, in an order that rotates by round (`phases.sh`, `variants.sh`):

- `phases.log`: `sub` and `sub3`, five rounds;
- `variants.log`: `sub2`'s switches 0 to 3 a window at a time and 0 and 2 whole, five rounds;
- `ab.log`: `main451` and `final451`, five rounds;
- `sub4.log`: `sub4`, three rounds.

`*-medians.txt` give each case's median of its processes' medians and their range (`parse.py`).

## Results

### Part 2: the directive tables' parts (`sqlite3.c`, `phases.log`)

| Part | A window at a time | Whole |
| --- | ---: | ---: |
| The scans for directives and line starts | 16.4 µs, per window | 90.0 µs, a pass to count and one to place |
| The directives' places out of the scan's words | 45.5 µs | |
| `pp_finish_directives`: kinds and line ends | 127.7 µs | 106.8 µs |
| `pp_finish_directives`: pairing and notes | 27.7 µs | 27.9 µs |
| All but the line pages | 217 µs | 225 µs |
| The line pages (#439) | 57.8 µs | |
| The phase | 0.350 ms | 0.297 ms |

The windowed path's main loop took 5.395 ms against 5.864 whole: it answers line queries from the pages, where a whole
file's counts from a cursor (and more differs between the two there than that).

### Part 2: the switches (`variants.log`)

| `sqlite3.c`, a window at a time | Places | Kinds and line ends | The phase |
| --- | ---: | ---: | ---: |
| main's code (0) | 46.4 µs | 126.6 µs | 0.353 ms |
| places by `vpcompressb` (1) | 33.2 µs | 129.1 µs | 0.341 ms |
| the prefetch (2) | 46.2 µs | 106.7 µs | 0.334 ms |
| both (3) | 33.2 µs | 107.3 µs | 0.322 ms |

Whole, with the prefetch: kinds and line ends 98.9 against 106.9 µs, the phase 0.294 against 0.296 ms. `main.c`, whose
windowed files hold few directives: 0.422 ms a window at a time and 0.386 whole, with each switch the same to within
4 µs.

### Part 3: the cut (`phases.log`, `sub4.log`)

| The frozen `main.c`'s windowed files (5,541,811 bytes) | Bytes lexed | Lexing, a window at a time against whole |
| --- | ---: | ---: |
| main's windows (`sub`) | 5,656,758 | 5.505 against 5.445 ms |
| the first form of the cut (`sub3`) | 5,553,665 | 5.487 against 5.459 ms |
| the pull request's (`sub4`) | 5,553,313 | |

`sqlite3.c`'s windows lexed 9,546,812 bytes for its 9,515,341 at main and with the pull request's cut, and 9,548,746
with the first form, which moved ordinary windows' ends too: the 4 KB bound leaves those as they were.

### The pull request against main (`ab.log`, `sub4.log`)

| Phase | `main451` | `final451` |
| --- | ---: | ---: |
| `sqlite3.c` directive tables, a window at a time | 0.343 ms (0.341-0.347) | 0.313 ms (0.311-0.316) |
| `sqlite3.c` directive tables, whole | 0.287 ms (0.287-0.296) | 0.284 ms (0.283-0.288) |
| `main.c` lexing, a window at a time | 5.513 ms (5.479-5.524) | 5.449 ms (5.430-5.458) |
| `main.c` lexing, whole | 5.464 ms (5.429-5.469) | 5.437 ms (5.412-5.461) |

Every other phase moved less than its rounds' range (`ab-medians.txt`). With the counters (`sub4`), `sqlite3.c`'s
tables but the line pages took 183.7 µs a window at a time (places 33.3, kinds and line ends 106.5) against 213.7 whole
(kinds and line ends 97.6).

## Correctness

On the laptop (Ryzen 9 7940HS, `laptop/`), with the pull request's code: `test-preprocessor` (the windows check: 240
sources in windows of 1 byte to 8 KB, 0 differing; the cut against a byte-at-a-time one in 119,616 checks, tails of 0, 3,
40 bytes and 4 KB, at `PROT_NONE` pages on both sides; the places against their twin in 976 checks, outputs ending at a
`PROT_NONE` page; the directive tables against their oracle), `test-files` and `test-refinement src`; and
`test-preprocessor --window-bytes 64` and the default windows on `sqlite3.c` and on `main.c`, which agreed with the
scalar twins. Mutants of the cut (no "\r\n", no look-behind across a chunk, no look-ahead, the comparisons loosened, no
bound) and of the places (one lane too many, no offset, no fallback past 16) each failed those checks.

## Files

- `builds.sh`, `builds.log`, `build-*.log`: the builds.
- `phases.sh`, `phases-round.sh`, `variants.sh`, `variants-round.sh`, `chain2.sh`, `chain4.sh`, `chain5.sh`: the runs.
- `phases.log`, `variants.log`, `ab.log`, `sub4.log` and their `*-medians.txt`, made by `parse.py`.
- `screening/`: the counters and the switches.
- `laptop/`: the acceptance runs.
- `source-*.sha256`, `binaries.sha256`: the identities.
- `review/`: the review's runs (below).

## The review ([#486](https://github.com/buster14a/buster/pull/486)), 2026-10-26

The review of the pull request's head `ec7b8cc3` asked that the cut's scan stop at the last line end when the part of
the line after it is no longer than the bound, since the window is then lexed to its end whatever comes before, and
that sources of sparse line ends be measured against main: a window whose only line end is near its start is scanned
whole from its end, where main's forward scan stopped at its first chunk. The pull request was revised in two commits:

- `25e41a2e`: the scan stops there; and a window whose only line end comes before a long part (more than the bound)
  is doubled unlexed, as one without a line end is. The reviewed head lexed such a window to its end, and the next
  window lexed the long line's start again.
- `94ae0608`: the bound is 16 KB rather than 4 KB, and `pp_directive_places` skips groups of eight words without a
  directive. It was pushed as `1a33796b`, the same tree with its message corrected: separate builds of the two bounds
  took `long-lines.c` alike (5.027 and 5.021 ms in all, `review2.log`), so the 4 KB bound's cost against main that the
  first message gave was the builds' layout and the places' compress.

Its files are in `review/`.

### Inputs

`generate451.c` writes C sources of sparse line ends from a seed (its comment has their shapes), here built with
`clang -O2 -Wall -Wextra -Werror -std=c17` and run as `generate451 long-lines long-lines.c 8000000 451` and
`generate451 spliced spliced.c 8000000 451` (`inputs.sha256`):

- `long-lines.c`, 8,002,841 bytes: declarations on lines of 5,000 to 12,000 bytes, one short line in eight, and no
  directive;
- `spliced.c`, 8,018,225 bytes: 74 macros defined over 20 to 200 KB of lines continued by splices, as
  `x86_64_encoder.c`'s `BUSTER_X86_VECTOR_FORMS` is, with one to six short lines between them.

### Trees

| Name | Source | What it is |
| --- | --- | --- |
| `rbase` | `dd982dfb` | main, the pull request's base |
| `rprev` | `ec7b8cc3` | the reviewed head (the cut of `final451` above, 4 KB) |
| `rhead` | `25e41a2e` | the scan's stop and the doubling, 4 KB |
| `rhead16` | `25e41a2e`, `BUSTER_PP_WINDOW_TAIL_BYTES` at 16 KB | |
| `rhead2` | `94ae0608` | the revised pull request: 16 KB and the groups' skip |
| `switch451` | `94ae0608` and `switch451.py` | one binary: main's window rule and main's places loop as switches |
| `sub5`, `sub6` | `25e41a2e` and `rhead16`, with the record's `screening/subphases.py` | the counters, laptop |

Each tree was sent by tar (`source-*.sha256`); the 9700X's executables (`binaries.sha256`) were built as above
(`builds.log`, `build-*.log`), the laptop's (`laptop/binaries.sha256`) with `cores -n 4` (`laptop/build-*.log`).

### Method

On the 9700X, `review.sh`, `review2.sh`, `review3.sh` and `review4.sh` run `benchmark-preprocessor --only vectorized` as
the record's runs do, on `sqlite3.c`, `main.c` and the two generated sources, a window at a time and (`review.sh`,
`review3.sh`) whole: each round one hold of the shared lock, every case of every tree a process pinned to CPU 2, in an
order that rotates by round; `chain6.sh` to `chain9.sh` queued the builds and the runs.

- `review.log`: `rbase`, `rprev` and `rhead`, five rounds;
- `review2.log`: `rbase`, `rhead` and `rhead16`, five rounds, windows only;
- `review3.log`: `rbase`, `rhead16` and `rhead2`, five rounds;
- `review4.log`: `switch451` with `BUSTER_451_MAIN` at 0 (the pull request), 1 (main's window rule), 2 (main's places
  loop) and 3 (both main's), seven rounds, windows only.

`*-medians.txt` are `parse.py`'s, which also reads each run's total (`vectorized`). `strip_lock.py` took the lock's
waiting messages, which name other runs, out of the 9700X's logs, and the cores queue's waiting lines were taken out of
the laptop's build logs.

On the laptop, counts rather than times: `lexed.sh` (`laptop/lexed.log`) counts the bytes the windows lex, by the
counters' builds, of main (`sub`, above), the first form of the cut (`sub3`), the reviewed head (`sub4`), `sub5` and
`sub6`; `lexed-x86.sh` (`laptop/lexed-x86.log`) the same for `x86_64_encoder.c` alone, its `#include` lines blanked to
the same length so that its windows are the same.

### Results: bytes lexed (`laptop/lexed.log`, `laptop/lexed-x86.log`)

A window at a time, against the bytes of the windowed files:

| | `sqlite3.c` | `main.c`'s windowed files | `x86_64_encoder.c` | `long-lines.c` | `spliced.c` |
| --- | ---: | ---: | ---: | ---: | ---: |
| The files | 9,515,341 | 5,541,811 | 582,021 | 8,002,841 | 8,018,225 |
| main (`sub`) | 9,546,812 | 5,656,758 | 692,720 | 8,247,914 | 10,789,105 |
| the first form of the cut, no bound (`sub3`) | 9,548,746 | 5,553,665 | 589,218 | 8,218,793 | 11,819,573 |
| the reviewed head, 4 KB (`sub4`) | 9,546,812 | 5,553,313 | 589,275 | 8,223,521 | 11,697,027 |
| the scan's stop and the doubling, 4 KB (`sub5`) | 9,546,812 | 5,553,313 | 589,275 | 8,223,521 | 8,027,302 |
| the same at 16 KB (`sub6`), the revised cut | 9,546,812 | 5,553,313 | 589,275 | 8,247,914 | 8,094,259 |

On `spliced.c`, main lexes a window that holds a macro's start, and the next window lexes it again. The reviewed head
cut such a window after its last line end before the macro, which left the next window one line end, before the
macro's start: lexed to its end, that window lexed up to 128 KB of the macro, which the window after it lexed again.
Doubled unlexed, such windows lex the macro once. At 4 KB, `long-lines.c`'s windows were cut before the line their
end cut whenever the line before was the shorter, and lexed that line again instead; at 16 KB they lex what main's
do, every window to its end.

### Results: separate builds (`review.log`, `review2.log`, `review3.log`)

A window at a time, the median of five processes (`*-medians.txt` have the ranges and the other phases), in ms:

| | `rbase` | `rprev` | `rhead` | `rhead16` | `rhead2` |
| --- | ---: | ---: | ---: | ---: | ---: |
| `long-lines.c`: lexing | 1.956, 1.961, 1.964 | 2.000 | 1.972, 1.974 | 1.972, 1.972 | 1.963 |
| `long-lines.c`: the directive tables | 0.092, 0.093, 0.092 | 0.110 | 0.113, 0.113 | 0.113, 0.113 | 0.095 |
| `long-lines.c`: in all | 4.974, 4.978, 5.043 | 5.042 | 5.029, 5.027 | 5.021, 5.025 | 5.012 |
| `spliced.c`: lexing | 2.843, 2.850, 2.836 | 2.699 | 1.844, 1.869 | 1.865, 1.867 | 1.875 |
| `spliced.c`: the directive tables | 0.112, 0.112, 0.112 | 0.127 | 0.128, 0.131 | 0.128, 0.129 | 0.114 |
| `spliced.c`: in all | 5.739, 5.758, 5.731 | 5.615 | 4.776, 4.822 | 4.802, 4.815 | 4.846 |
| `sqlite3.c`: the directive tables | 0.345, 0.345, 0.344 | 0.314 | 0.317, 0.318 | 0.315, 0.315 | 0.314 |
| `sqlite3.c`: in all | 10.142, 10.142, 10.126 | 10.180 | 10.164, 10.202 | 10.153, 10.159 | 10.130 |
| `main.c`: lexing | 5.479, 5.473, 5.464 | 5.476 | 5.491, 5.483 | 5.512, 5.537 | 5.482 |
| `main.c`: in all | 45.988, 45.980, 45.991 | 46.162 | 46.211, 46.072 | 46.264, 46.198 | 45.884 |

Each cell lists a tree's medians in the campaigns that ran it, in order. Whole files, which take neither the cut nor
the places, differed from `rbase`'s by -0.8 to +1.1% in all (`rprev`'s `main.c`, 46.315 against 45.804 ms in
`review.log`): the builds' layout. The reviewed head lexed `spliced.c` over more bytes than main yet in less time;
its `long-lines.c` took 1.4% more than main's in all, 0.044 ms lexing and 0.018 ms in the directive tables, where the
places' compress ran for each word of 64 tokens.

### Results: one binary (`review4.log`)

`switch451` with `BUSTER_451_MAIN` at 0, 1, 2 and 3, a window at a time, the median of seven processes (ms):

| | the pull request | main's window rule | main's places loop | both main's |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`: lexing | 2.366 | 2.360 | 2.364 | 2.353 |
| `sqlite3.c`: the directive tables | 0.315 | 0.315 | 0.327 | 0.326 |
| `sqlite3.c`: in all | 10.155 | 10.181 | 10.197 | 10.153 |
| `main.c`: lexing | 5.479 | 5.519 | 5.479 | 5.533 |
| `main.c`: the directive tables | 0.387 | 0.388 | 0.392 | 0.392 |
| `main.c`: in all | 46.142 | 46.366 | 46.136 | 46.322 |
| `long-lines.c`: lexing | 1.969 | 1.964 | 1.967 | 1.970 |
| `long-lines.c`: refining | 0.499 | 0.501 | 0.503 | 0.499 |
| `long-lines.c`: the directive tables | 0.099 | 0.099 | 0.096 | 0.097 |
| `long-lines.c`: in all | 5.016 | 5.009 | 5.011 | 5.009 |
| `spliced.c`: lexing | 1.886 | 2.715 | 1.861 | 2.720 |
| `spliced.c`: the directive tables | 0.117 | 0.115 | 0.111 | 0.114 |
| `spliced.c`: in all | 4.863 | 5.654 | 4.782 | 5.656 |

Where the windows end as main's do, the cut costs nothing: `sqlite3.c`'s and `long-lines.c`'s lexing differ by less
than their rounds' ranges, and so does `long-lines.c`'s refining, which the separate builds had put 0.018 to 0.026 ms
apart. It spares `main.c` 0.040 to 0.054 ms of lexing and `spliced.c` 0.83 to 0.86 ms, with either places loop. The
places spare `sqlite3.c`'s directive tables 0.011 to 0.012 ms and `main.c`'s 0.004 to 0.005, with either rule, and cost
`long-lines.c`, which has no directive, 0.002 to 0.003 ms, and `spliced.c`, which has 74, 0.001 to 0.006 ms.

### Correctness

On the laptop, with `94ae0608` (`laptop/`, `accept.sh`): `test-preprocessor` (the windows check: 240 sources in windows
of 1 byte to 8 KB, 0 differing; the cut against a byte-at-a-time one in 119,625 checks, tails of 0, 3, 40 bytes and
16 KB at `PROT_NONE` pages on both sides, and 9 windows worked out by hand, one whose bytes before its line end's chunk
are in a `PROT_NONE` page; the places against their twin in 976 checks), `test-files` and `test-refinement src`; and
`test-preprocessor` on `sqlite3.c`, `main.c`, `long-lines.c` and `spliced.c` with windows of 128 KB and of 64 bytes,
which agreed with the scalar twins; and `switch451`'s four settings on the same four files with 128 KB windows
(`laptop/switch451-check.log`). `mutants/mutants.sh` builds each mutant of the cut and of the places with the windows
check's tests of them, from `94ae0608`'s sources (`mutants/results.txt`): the unchanged code passes, and each mutant
fails or faults: the cut without its stop at a short tail (faults at the guard page), with a window of one line end
before a long tail lexed (2 fixtures, 1 random), with the bound taken with `>=` (6 random); the places with the groups'
test inverted (10 of 32), a last group read whole (faults), a store one place wider (faults), and no fallback past 16
places (7 of 32).

### Files

- `generate451.c`, `inputs.sha256`: the generated inputs.
- `builds.log`, `build-*.log`: the 9700X's builds (the record's `builds.sh`); `binaries.sha256`, `source-*.sha256`.
- `review.sh` to `review4.sh`, `review*-round.sh`, `chain6.sh` to `chain9.sh` and their logs: the runs;
  `review*.log` and their `*-medians.txt` (`parse.py`); `strip_lock.py`.
- `switch451.py`: the one-binary switches.
- `lexed.sh`, `lexed-x86.sh`, `accept.sh`, and `laptop/`: the counts, the acceptance runs and the laptop's builds.
- `mutants/`: the mutants' script and results.
