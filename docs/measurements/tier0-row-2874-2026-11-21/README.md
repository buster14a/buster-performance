# Tier 0's row by body, by entry and by pass: the one-core path's step 4, its design's measurements (buster#2874), 2026-11-21

[buster#2874](https://github.com/buster14a/buster/issues/2874) asks for step 4's design, "its selection on the same
bytes", after [the census](../tier0-census-2874-2026-11-16/) counted the row an entry at a time. This record is the
claim's item 1: each part of the row as a body's fixed cost and as an entry's, and Tier 0 by pass, on `-c sqlite3.c`.
It changes no compile: the experiment patch logs ticks and is not for main.

## What was measured

- **Revision:** buster main `e77b3eba4752` (2026-11-21), Release, `BUSTER_HOST_ARCH=znver5`, built in a cloud container
  with CI's staged toolchain (LLVM 23.1.4) and copied to the 9700X. SHA-256s: main `263256f6…bdf0`, the per-body log
  `8ed643c6…41c9`, the per-pass log `22a8537f…9774` (`binaries.sha256`).
- **The logs** (`scripts/row-log.patch`, on top of main): with `BUSTER_ROW_LOG=FILE`, each body's TSC ticks for Tier 0
  (`tier0_compile` with Tier 0's inlining splice and `emitted_from_tier0`), branch sizing, the encoder, `-g`'s rows, the
  unwind rows and the rest of `check_program_emit_code`, and inside Tier 0 a lap after each pass of
  `tier0_compile_entries` and `tier0_generate`. The objects are byte for byte main's (`rowlog.sh` compares them).
- **The runs:** the 9700X, CPU 2, each set under the lock as one hold: `stages.sh` (main, 7 runs of `--time-stages`),
  `rowlog.sh` (5 runs each of the two logs). `results/*/busy.txt` has the busiest processes before and after each hold.
- **The input:** the frozen corpus of `tools/ci/fetch-corpus.sh` (archive `ceb39bf9…`), `sqlite3.c` with
  `--predefines provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc` and the corpus's three
  `-isystem` directories.
- **Cycles** are TSC ticks times 5.45 / 3.7928 (the 9700X's TSC is 3,792.8 MHz; the compile runs at about 5.45 GHz).
  A body's figure is the median of its runs. A part's fit is cycles = a + b × the body's typed entries, least squares
  over the bodies but the first (its cold start). `python3 scripts/tables.py results` prints every table below.

## The stage clock

`-c sqlite3.c`, main, medians of 7 runs, 706,204 tokens:

| stage | ms | cycles a token at 5.45 GHz |
| --- | ---: | ---: |
| `tier0` | 5.093 | 39.3 |
| `emit-setup` | 1.080 | 8.3 |
| `branch-sizing` | 0.448 | 3.5 |
| `encode` | 0.341 | 2.6 |
| `unwind` | 0.483 | 3.7 |
| `code-atoms` | 0.339 | 2.6 |
| `publish-data` | 0.494 | 3.8 |
| `object-build` | 0.457 | 3.5 |
| `object-write` | 0.372 | 2.9 |
| **the row** | **9.107** | **70.3** |
| `lower.validate` (Tier 0's check of the stream) | 1.159 | 8.9 |
| the compile | 118.890 | 917.5 |

## A body at a time

2,602 bodies, 371,246 typed entries, 295,057 records, 26,324 branches, 15,599 references, 1,037,699 bytes of code.

| part | cycles an entry | a: cycles a body | b: cycles an entry | the bodies' a, share |
| --- | ---: | ---: | ---: | ---: |
| Tier 0 (`tier0_compile`, `emitted_from_tier0`) | 75.9 | 2073 | 60.90 | 19.3% |
| branch sizing | 6.2 | 394 | 3.39 | 44.9% |
| the encoder | 5.0 | 365 | 2.38 | 51.8% |
| `-g`'s rows | 0.3 | 45 | 0.00 | 99.7% |
| the unwind rows | 5.8 | 757 | 0.47 | 91.8% |
| the rest of the body's emission | 0.5 | 67 | 0.04 | 92.9% |
| **all** | **93.7** | | | |

By the body's typed entries, the median cycles an entry:

| entries | bodies | Tier 0 | branch sizing | the encoder | the unwind rows | all |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 to 1 | 1 | 2185.6 | 162.4 | 109.2 | 56.0 | 2674.1 |
| 2 to 3 | 37 | 1038.2 | 55.3 | 54.6 | 28.0 | 1257.3 |
| 4 to 7 | 175 | 545.8 | 32.8 | 26.9 | 54.6 | 669.3 |
| 8 to 15 | 272 | 327.7 | 22.0 | 16.4 | 42.1 | 415.4 |
| 16 to 31 | 396 | 188.3 | 15.6 | 10.5 | 27.3 | 246.3 |
| 32 to 63 | 554 | 120.6 | 10.0 | 7.6 | 17.6 | 160.1 |
| 64 to 127 | 509 | 88.3 | 8.1 | 5.1 | 11.4 | 114.4 |
| 128 to 255 | 360 | 67.1 | 6.4 | 3.9 | 6.8 | 85.5 |
| 256 to 511 | 182 | 57.5 | 4.9 | 3.1 | 3.6 | 69.9 |
| 512 to 1023 | 75 | 54.2 | 4.1 | 2.7 | 2.1 | 62.5 |
| 1024 to 2047 | 24 | 45.6 | 3.7 | 2.5 | 1.2 | 52.9 |
| 2048 to 4095 | 10 | 48.7 | 3.3 | 2.4 | 0.8 | 55.3 |
| 4096 to 8191 | 4 | 54.5 | 3.5 | 2.6 | 0.6 | 63.5 |
| 8192 to 16383 | 1 | 71.0 | 3.1 | 2.7 | 0.5 | 77.4 |
| 16384 to 32767 | 1 | 65.1 | 3.3 | 2.1 | 0.3 | 70.9 |

## Tier 0 by pass

| pass | cycles an entry | a: cycles a body | b: cycles an entry | bodies of 256 entries or more: cycles an entry |
| --- | ---: | ---: | ---: | ---: |
| the columns' room | 2.6 | 181 | 1.31 | 0.8 |
| the labels | 1.5 | 66 | 1.02 | 1.1 |
| the values' predicates (P0) | 2.1 | 19 | 1.97 | 1.7 |
| fusion (P1 to P3) | 6.9 | 297 | 4.85 | 5.4 |
| the depths (P4) | 1.4 | 87 | 0.84 | 1.0 |
| selection (the words, the frame's alignment) | 10.7 | -124 | 11.41 | 9.2 |
| the homes and the frame | 6.5 | 610 | 2.23 | 3.3 |
| measuring and the output's room | 12.4 | 38 | 12.15 | 10.6 |
| emission (`tier0_emit_vector`) | 21.4 | -194 | 22.62 | 18.9 |
| the immediates' forms | 3.3 | 150 | 2.29 | 2.4 |
| the rest of `tier0_generate` | 0.3 | 49 | -0.00 | 0.1 |
| labels' and tails' records, the close | 0.4 | 49 | 0.04 | 0.1 |
| `emitted_from_tier0` | 4.8 | 662 | 0.10 | 1.1 |
| **Tier 0** | **74.5** | | | **55.7** |

297 bodies have 256 entries or more, with 221,285 of the entries. The passes' laps cost about 300 cycles a body; the
per-body log without them reads Tier 0 at 75.4 cycles an entry (`results/rowlog`).

## Reading it

- **The row is work an entry.** Tier 0's fitted b is 60.9 of its 75.9 cycles an entry, and bodies of 256 entries or
  more still take 55.7 in Tier 0 alone. A small body costs more an entry (4 to 7 entries: 669 cycles an entry in all),
  but such bodies hold few entries.
- **After an entry's template is known,** measuring, emission, the immediates' forms, branch sizing and the encoder take
  48.4 cycles an entry (12.4 + 21.4 + 3.3 + 6.2 + 5.0), half of the body's 93.7. They handle each entry as a word, as a
  64-byte line of records, as a form's request, as a length (`x86_measure` in sizing) and as bytes.
- **Before it,** the columns' room, the labels, the values, fusion, the depths and selection take 25.3; the homes and
  the frame 6.5, 610 cycles of them a body.
- **The unwind rows are a body's,** not an entry's: `emitted_from_tier0`'s frame events and the rows after sizing are
  662 + 757 cycles a body, 10.6 an entry.
- **Outside the bodies,** `emit-setup`, `publish-data` and the object are 18.5 cycles a token, and `lower.validate`, a
  check of Tier 0's input, 8.9.

## Files

- `scripts/row-log.patch`: the experiment patch on main `e77b3eba4752`.
- `scripts/stages.sh`, `scripts/rowlog.sh`: the runs on the 9700X (under `exclusive.sh`, a hold a set).
- `scripts/tables.py`: every table here from `results/`; `scripts/rowfit.py`, `scripts/passfit.py`: the same fits as
  first printed, with a core clock and TSC given.
- `results/main/stages-*.txt`: main's `--time-stages`; `results/rowlog/`, `results/rowlog2/`: the two logs (a body a
  line: body, entries, records, branches, references, bytes, then ticks: Tier 0, sizing, encoder, `-g`, unwind, rest,
  and in `rowlog2` Tier 0's sixteen pass laps) and their runs' `--time-stages`.
