# Tier 0's row on main, cold and warm, by pass and by cause (buster#2874), 2026-11-23

[buster#2874](https://github.com/buster14a/buster/issues/2874) is step 4 of
[buster#2850](https://github.com/buster14a/buster/issues/2850): Tier 0's row at 10 cycles a token. Under
[this claim](https://github.com/buster14a/buster/issues/2874#issuecomment-7097009963) the row is measured again on
today's main, before its next pieces are chosen. No compile changes: the experiment patch logs ticks and runs knobs, and
every object below is main's byte for byte (`object.sha256` and `objects.sha256` in each result: `ea9b6d14…8088`).

## What was measured

- **Revision:** buster main `9d927943` (2026-11-23), Release, `BUSTER_HOST_ARCH=znver5`, built in a cloud container
  with CI's staged toolchain (LLVM 23.1.4) and copied to the 9700X stripped. SHA-256s of the stripped executables:
  main `e1870edc…0e98`, the row log `fced00dd…5617`, the row log with the fresh-memory mode `cea0f922…c77e`, the row log
  with the calls' knob `99d7d356…2920` (`binaries.sha256`).
- **The runs:** the 9700X, CPU 2, each set under the lock as one hold (`scripts/*.sh`); `results/*/busy-*.txt` has the
  busiest processes before and after each hold.
- **The input:** the frozen corpus of `tools/ci/fetch-corpus.sh` (archive `ceb39bf9…`), `sqlite3.c` with
  `--predefines provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc` and the corpus's three
  `-isystem` directories: 706,216 tokens, 2,602 bodies, 371,237 typed entries.
- **Cycles** are TSC ticks times 5.45 / 3.7928 (the 9700X's TSC is 3,792.8 MHz; the compile runs at about 5.45 GHz).
- **The experiment patch** (`scripts/row-log-experiment.patch`, on main `9d927943`) is
  [the row record's](../tier0-row-2874-2026-11-21/) row log rebased, with two knobs: `BUSTER_ROW_WARM=1` compiles each
  body with Tier 0 once more first and pops its output, so that the logged run is warm (its first run's ticks in lap
  13); `=2` keeps the first run's output, so that the logged run writes fresh memory; and `BUSTER_ROW_CALLS=N` counts
  and emits each deferred `CALL` entry N more times, its results discarded.

## The stage clock

`-c sqlite3.c`, main, medians of 7 runs (`results/main`):

| stage | ms | cycles a token |
| --- | ---: | ---: |
| `tier0` | 4.870 | 37.6 |
| `emit-setup` | 1.034 | 8.0 |
| `branch-sizing` | 0.446 | 3.4 |
| `encode` | 0.336 | 2.6 |
| `unwind` | 0.222 | 1.7 |
| `code-atoms` | 0.309 | 2.4 |
| `publish-data` | 0.497 | 3.8 |
| `object-build` | 0.401 | 3.1 |
| `object-write` | 0.156 | 1.2 |
| **the row** | **8.271** | **63.8** |
| `lower.validate` (Tier 0's check of the stream) | 1.151 | 8.9 |
| the compile | 115.411 | 890.6 |

The row's stages take no minor fault and no system time (the stage clock's columns): the row is user-mode work.

## A body at a time (`results/rowlog`, 5 runs, a body's median)

| part | cycles an entry | a: cycles a body | b: cycles an entry |
| --- | ---: | ---: | ---: |
| Tier 0 | 71.44 | 1,629 | 59.80 |
| branch sizing | 5.92 | 357 | 3.31 |
| the encoder | 4.94 | 362 | 2.38 |
| `-g`'s rows | 0.31 | 44 | 0.00 |
| the unwind rows | 1.96 | 270 | 0.04 |
| the rest | 0.51 | 66 | 0.05 |

Tier 0 by pass, cold (the compile as it runs) and warm (`BUSTER_ROW_WARM=1`: the same body compiled again at once):

| pass | cold, cycles an entry | warm | a: cycles a body (cold) |
| --- | ---: | ---: | ---: |
| the columns' room | 2.79 | 1.11 | 234 |
| the labels | 1.48 | 0.97 | 66 |
| the values' predicates (P0) | 2.05 | 1.86 | 14 |
| fusion (P1 to P3) | 6.89 | 5.05 | 306 |
| the depths (P4) | 1.49 | 1.31 | 93 |
| selection | 10.50 | 6.75 | -97 |
| the homes and the frame | 6.52 | 4.12 | 608 |
| measuring and the output's room | 12.36 | 9.04 | 36 |
| emission | 21.14 | 15.08 | -189 |
| the immediates' forms | 3.33 | 2.91 | 158 |
| the rest | 1.43 | 1.37 | |
| **Tier 0** | **71.44** | **50.92** | |

- **A warm Tier 0 takes 50.9 cycles an entry where the compile's takes 71.4**: 7.6 M of its 26.5 M cycles come from
  running each body once, after other work. The gap is in bodies of every size, not a body's fixed part: 54.3 against
  39.5 an entry at 512 to 1,023 entries.
- **Not the output's fresh memory:** with the first run's output kept, so that the logged run writes fresh memory
  (`BUSTER_ROW_WARM=2`, `results/rowlog-warm2`), the warm run takes 52.25 cycles an entry, 1.3 more.
- **Not the interleave with the lowering, nor the stream's age:** `--emit-window=` 0 (one window: every body lowered
  before any is compiled), 2,048 (the default), 8,192 and 32,768 tokens give `tier0` 4.70, 4.78, 4.79 and 4.82 ms
  (`results/windows`, medians of 5).
- **What is left of the cold part** is the predictors and the caches of Tier 0's own code and tables, between one body's
  Tier 0 and the next's.

## The calls (`results/calls`, the knob at 0, 1, 2 and 4, 5 runs each)

Tier 0's cycles, the sum of the bodies' medians: 27.31, 29.77, 32.02 and 36.37 M cycles. Counting and emitting every
`CALL` entry once more costs **2.27 M cycles** (0.42 ms), measuring's share 0.86 M and emission's 1.41 M: about 175
cycles a call, warm. The stage clock's `tier0`: 4.94, 5.39, 5.81 and 6.58 ms.

## Profiles (`results/prof-*`)

User-mode samples of 8 runs each (`scripts/profile.sh`), the sampled addresses symbolized with their inline chains
(`scripts/attribute.py`, `inner.py`, `lines.py`): `cycles:u` at period 20,011 (`prof-main`), with branch stacks and libc's
samples given to their callers (`profb2-main`, period 100,003, `scripts/brips.c` from
[the census](../tier0-census-2874-2026-11-16/scripts/tools/brips.c) with the static executable's `.iplt` stubs added to
its transparent ranges), `instructions:u` at 400,009 (`prof-ins`) and `ex_ret_brn_misp:u` at 1,009 (`prof-misp`). The
samples are in `samples.zst` (an address a line; `profb2-main`'s in brips' format).

Instructions and mispredicted branches a typed entry, by function (the sample counts times the period, over 8 runs and
371,237 entries):

| function | instructions | mispredicted |
| --- | ---: | ---: |
| `tier0_generate` | 97.5 | 0.32 |
| of which emission | 33.4 | 0.08 |
| measuring | 26.4 | 0.09 |
| selection | 14.6 | 0.05 |
| the immediates' forms applied | 6.1 | 0.00 |
| the references' count, homes, frame | 11.2 | 0.08 |
| `tier0_compile_entries` (the front) | 41.2 | 0.13 |
| of which fusion | 20.7 | 0.08 |
| the values | 7.0 | 0.01 |
| the depths | 6.1 | 0.01 |
| `tier0_emit_deferred` | 18.7 | 0.05 |
| Tier 0's other functions | 6.9 | 0.02 |
| `tier0_validate_accepts` (`lower.validate`) | 23.2 | 0.09 |
| `x86_encode_16` | 15.6 | 0.01 |
| `size_branches` and `x86_measure` | 10.2 | 0.02 |
| `check_program_emit_timed` (`emit-setup`, `code-atoms`) | 23.0 | 0.05 |
| `object_build` | 10.9 | 0.04 |

- **Tier 0 is about 165 instructions and 0.52 mispredicted branches a typed entry.** Warm, at 50.9 cycles, that is about
  3.2 instructions a cycle.
- **Measuring's hottest lines are the deferred entries' count** (`tier0_count_deferred`'s call site and the line after
  it: 50% of measuring's cycles); **selection's, its gather** of the slot words from a 256 KB table and the instruction
  after it (24%); **emission's**, the branch targets' gather, the B local's home lookup and the choice requests'
  compressed stores.
- **`emit-setup`:** in `check_program_emit_timed`, the names' loop (`check_program_emit_makes_name` twice a symbol,
  `check_program_emit_given_name`'s hash and `link_add_name_hashed`) is 45% of the function's own samples, the
  attributed declarations' scan (`check_input_attributed_next`/`_group`) 13%, the windows 11%.
- **libc's memory functions** are 2.5% of the compile's cycles; with their samples given to their callers, nearly all of
  them are the front end's and the checker's, not the row's.

## Files

- `scripts/row-log-experiment.patch`: the experiment patch on main `9d927943`.
- `scripts/stages.sh`, `table.sh`: the stage clock; `rowlog.sh`: the row log (`warm` 1 or 2); `windows.sh`: the
  emission windows; `calls.sh`: the calls' knob; `profile.sh`, `profile-post.sh`, `profile-b.sh`, `profile-b-post.sh`:
  the profiles (run on the 9700X under `exclusive.sh`, a hold a set).
- `scripts/rowtables.py COLD WARM`: the row log's tables; `attribute.py`, `inner.py`, `lines.py`: a profile by symbol,
  by inlined pass and by source line (llvm-symbolizer over the unstripped executable, which is not kept).
- `results/*/rowlogs.tar.zst`: the row logs (a body a line: body, entries, records, branches, references, bytes, then
  ticks: Tier 0, sizing, encoder, `-g`, unwind, rest, then Tier 0's 16 pass laps), and each run's `--time-stages`.
