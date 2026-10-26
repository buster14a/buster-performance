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
