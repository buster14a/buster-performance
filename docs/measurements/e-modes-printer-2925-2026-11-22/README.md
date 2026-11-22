# `-E`'s output modes after main's merge (buster#2925), 2026-11-22

[buster#2925](https://github.com/buster14a/buster/pull/2925) adds `-C`, `-CC`, `-dD`, `-dI` and `-dN` to `-E`
([buster#1380](https://github.com/buster14a/buster/issues/1380)). Its branch `claude/gallant-mccarthy-83mog5` was merged
with main `d5fbf14e` on 2026-11-22. #2924 had removed the scalar printer, so the merge also moved `-CC`'s printing into
`pp_print_vector_mode`. That adds a mask a chunk, under `-C` and `-CC` only, and an OR into the chunk's line starts.

This record is a short A/B of the branch against its merge base, without `-C`, plus one `-C` run of the branch for
information. The earlier record of this PR, before the merge, is
[e-output-modes-1380-2026-11-17](../e-output-modes-1380-2026-11-17/README.md).

## How it was measured

- **Host:** the 9700X (`benchpress`), CPU 2. Every build and every run held the host's lock alone (`exclusive.sh`).
- **Trees** (`~/buster-fast-bench/1380-claude-2925/`):
  - `base` is main `d5fbf14ee609dd306f6efc607bb556833b2e9c83`, the branch's merge base;
  - `head` is the branch at `570138a079c3bdf428581d1a89742d08a7d49706`.

  Both are `./build.sh --config Release` builds with CI's Clang 23.1.4 (`results/build-*.log`, `scripts/builds.sh`).
  The executables' hashes are in `results/executables.sha256`.
- **Runs:** `scripts/measure.sh` runs `head/build/compiler ab --rounds 6 --cpu 2 --lock scripts/lockps.sh ../base ../head`
  with three lists, from the head tree, so both builds read the same inputs:
  - AGENTS.md's smoke, `benchmark-preprocessor --clang -march=native -Isrc -fwrapv -funsigned-char src/buster/compiler/main.c`.
    Its `-E -P with printing` is the printer without line markers. Its `clang -E` is the host's clang 23.1.1.
  - The same with `--markers` in place of `--clang`: `-E`'s default printing, with line markers.
  - `benchmark-preprocessor --tables src`.
- **Order:** `ab` runs the trees in a Williams order, so each tree goes first in half the rounds.
- **Load and processes:** `lockps.sh` takes the lock for each run. Inside the hold it writes the load and the busiest
  processes before and after the run (`results/ab.log`). Only kernel workers, at 0.1% CPU or less, were listed.
  `exclusive.sh` listed no busy process.
- **The `-C` run:** one `benchmark-preprocessor -E -C` run of the head, under the same lock wrapper (`results/head-C.log`).
- **Each run:** each `benchmark-preprocessor` run reports the medians of 21 passes after a warm-up. `scripts/extract.awk`
  takes the vectorized arm's medians into `results/runs.tsv`. Its columns are round, tree, list, run (ms), instructions
  an input token, the run with printing (ms) and the printing (ms). For `--tables` they are the tables' ms and cycles a
  token.

## Results

The table gives the medians over the 6 rounds. Each spread is the largest round's median over the smallest's.

| `main.c` (2,175,202 input tokens) | base | head | head against base |
| --- | ---: | ---: | ---: |
| `-E -P` run without printing | 44.466 ms (spread 0.29%) | 45.060 ms (0.62%) | +1.34% |
| instructions an input token | 388.55 | 388.99 | +0.11% |
| `-E -P` with printing | 50.698 ms (0.33%) | 51.535 ms (0.57%) | +1.65% |
| printing alone, `-P` | 6.236 ms (0.90%) | 6.463 ms (1.18%) | +3.64% |
| `-E` run without printing (`--markers`) | 37.764 ms (0.52%) | 37.977 ms (0.59%) | +0.56% |
| instructions an input token (`--markers`) | 327.17 | 327.57 | +0.12% |
| `-E` with printing, line markers | 46.320 ms (0.41%) | 46.618 ms (0.57%) | +0.64% |
| printing alone, line markers | 8.577 ms (0.79%) | 8.613 ms (0.41%) | +0.42% |
| `--tables src` | 0.285 ms (1.76%) | 0.287 ms (1.41%) | +0.70% |

- **Every row but `--tables`:** head is slower than base in all 6 rounds, and the two builds' ranges don't overlap.
  - That is beyond the rounds' spread for `-E -P` (+1.65% with printing) and for `-E` with line markers (+0.64%).
  - It is one placement of each build's code, with no shifts and no copies. So this A/B can't tell code from
    placement: on this host a placement alone has moved a compile by up to 2% (buster#502).
- **The runs without printing** take 0.11% to 0.12% more instructions, which the branch's preprocessor changes add.
  Their time rises 0.56% to 1.34%, more than the instructions do.
- **Printing without line markers** is 3.6% slower: 0.23 ms of `main.c`'s 6.2 ms.
- **`--tables`:** within its spread.
- **`-E -C`, head alone, for information:**
  - 75.937 ms without printing, with lex 24.596 ms against 4.05 ms without `-C`;
  - 83.548 ms with `-P`'s printing, of which printing is 7.638 ms;
  - 2,233,584 input tokens and 2,499,063 output tokens, comments among them.

Nothing was optimized after this measurement.

## Second section: placement controls, and the default path's fix

The first section's runs used one placement of each build. Every run here holds the lock alone and is pinned to CPU 2,
with the load and the busiest processes logged inside each hold (`scripts/lockps.sh`). The scripts are in
`placements/scripts`, the readings in `placements/results`, and the patches the trees were built from in
`placements/patches`.

### How it was measured

- **Placements:** `scripts/shifts.sh` links each tree's Release executable at six placements of the `-E` unit's code,
  `./build.sh shifts DIR main_unit_frontend.c 0 704 1408 2112 2816 3520`.
- **Whole processes** (`scripts/placements.sh`): `time-runs --runs 3 --copies 3` of `-E -P` (list 1) and `-E` (list 2)
  of `main.c` with `-march=native -Isrc -fwrapv -funsigned-char`.
  - Each run takes the six placements of `base`, the tree measured and `base` again (`base-again`, the comparison's own
    floor), three fresh copies of each, in a Williams order.
  - `ab --rounds 3` runs it three times, each under the lock alone. Its output is `placements/results/placements-*.log`.
- **In-process** (`scripts/inproc.sh`): `benchmark-preprocessor --only vectorized` of the same `main.c`, plain (`P`:
  `-E -P`'s printing) and `--markers` (`-E`'s printing with line markers).
  - Each run takes one of the 18 placement executables of `base`, the tree measured and `base-again`, in a Williams
    order, over 2 rounds.
  - `scripts/extract2.awk` and `scripts/summary2.awk` give the medians over the 12 runs of each build, and the range of
    its placements' medians (`placements/results/inproc-*.tsv`).
- **Trees:** `base` is main `d5fbf14e`; `head` is the branch `570138a07`. `fix1` to `fix4` are `570138a07` with
  `patches/fixN.patch`. `fix4` is the commit pushed to the branch, `13e20bb17` (its source equals `fix4.patch`), which
  was then merged with main `ef3d3769a` (`638b77a09`).

### Before: `head` against `base`, over placements

In-process, each build's median, with the range of its placements' medians in brackets:

| `main.c` | base | head | base-again |
| --- | ---: | ---: | ---: |
| `-E -P` run | 44.567 ms [44.456–44.731] | 45.028 [44.879–45.094], +1.03% | 44.520 [44.361–44.593], -0.10% |
| `-E -P` printing | 6.181 ms [6.154–6.219] | 6.418 [6.407–6.509], +3.83% | 6.176 [6.132–6.190], -0.08% |
| `-E -P` with printing | 50.758 ms [50.631–50.948] | 51.448 [51.319–51.551], +1.36% | 50.711 [50.499–50.809], -0.09% |
| `-E` run (`--markers`) | 37.884 ms [37.656–38.138] | 38.229 [38.062–38.366], +0.91% | 37.952 [37.862–38.132], +0.18% |
| `-E` printing, markers | 8.555 ms [8.499–8.584] | 8.589 [8.484–8.706], +0.40% | 8.556 [8.532–8.623], +0.01% |
| `-E` with printing | 46.447 ms [46.249–46.683] | 46.784 [46.733–46.931], +0.73% | 46.508 [46.421–46.714], +0.13% |
| instructions an input token (`P` / markers) | 388.55 / 327.17 | 388.99 / 327.57 | 388.55 / 327.17 |

- **In-process:** the regression is code, not placement. `head`'s placements don't overlap `base`'s in the `-E -P`
  run, the printing or the total.
- **Whole processes, by round:** `head` against `base`, user cycles:
  - `-E -P`: -0.57%, -0.72%, -0.62%;
  - `-E`: -0.41%, -0.70%, -0.80%;
  - `base-again`: between -0.25% and +0.13%.

  The `-E` driver defers the expansion history (`defer_history`), which the benchmark records. A cycles profile
  (`perf-base.report.txt`, `perf-head.report.txt`) put the largest rise in `pp_history_fill`, +283 of about 32,000
  cycle samples.

### What cost, and the fix

`layout-*.txt` (gdb) and the executables' symbol sizes showed three causes:

- **Struct layout:** the new fields moved the fields after them. `PPOptions` grew from 816 to 824 bytes,
  `Preprocessor` from 15,552 to 15,616, `PPPrepare` from 24 to 32 and `PPMarkers` from 96 to 112.
- **The printer's default instances** kept the modes' work: the `-CC` mask and its line starts, and the directives'
  tests.
- **Inlining:** the compiler's inlining changed where the modes' code went into hot functions. `pp_spelling` grew from
  347 to 1,131 bytes, and the printer's helpers were called out of line once the modes' instance became a second caller.

The patches, in turn:

- `fix1`: restores the layouts (new fields in holes or at the end) and gives the modes an instance of the printer of
  their own (`pp_print_modes`).
- `fix2`: also makes the printer's helpers `BUSTER_INLINE`, and moves the modes' work in `pp_paste`,
  `pp_collect_step`, `pp_without_splices`, the include guard and preparation out of line, behind a test of the option.
- `fix3`: guards the directives' cursor by the instance's `modes`, splits `pp_paste` (`pp_paste_with`), and moves
  `pp_without_splices`' comment test to its callers.
- `fix4`: `fix3` with `fix2`'s `pp_without_splices`.

In-process, against `base`, with `base-again` in the same runs in brackets:

| `main.c` | fix1 | fix2 | fix3 | fix4 |
| --- | ---: | ---: | ---: | ---: |
| `-E -P` run | +1.10% (-0.01%) | -0.21% (-0.21%) | +0.38% (+0.15%) | +0.18% (-0.02%) |
| `-E -P` printing | -0.13% (-0.09%) | -0.68% (+0.14%) | -0.09% (+0.14%) | -0.60% (-0.21%) |
| `-E -P` with printing | +0.97% (-0.04%) | -0.19% (-0.10%) | +0.38% (+0.12%) | +0.16% (-0.12%) |
| `-E` run | +0.90% (-0.04%) | +0.19% (+0.02%) | +0.11% (+0.08%) | -0.23% (-0.03%) |
| `-E` printing, markers | +1.60% (+0.37%) | +0.12% (+0.48%) | -0.11% (+0.16%) | -0.47% (+0.31%) |
| `-E` with printing | +1.12% (+0.07%) | +0.21% (+0.06%) | +0.03% (+0.06%) | -0.35% (-0.03%) |
| instructions (`P` / markers) | +0.11% / +0.12% | +0.19% / +0.20% | -0.56% / -0.63% | -0.56% / -0.64% |

Whole processes, user cycles against `base` in each of the 3 rounds, with `base-again` in brackets:

| | `-E -P` | `-E` |
| --- | --- | --- |
| fix1 | -0.57, -0.65, -0.79 (-0.04, +0.14, -0.18) | -0.59, -0.52, -0.36 (+0.04, +0.03, +0.26) |
| fix2 | -0.44, -0.52, -0.43 (+0.02, +0.10, -0.14) | -0.80, -0.94, -0.68 (-0.10, -0.28, -0.10) |
| fix3 | +0.43, +0.15, +0.23 (+0.12, -0.06, -0.12) | -0.10, -0.33, +0.21 (+0.12, -0.28, +0.03) |
| fix4 | +0.10, -0.08, +0.06 (+0.09, +0.01, -0.05) | +0.04, -0.18, -0.12 (-0.09, -0.06, -0.08) |

- **`fix4`, the pushed fix,** is within `base-again`'s floor on every row, in-process and in whole processes.
- **Instructions:** its whole processes run 779,269,783 against `base`'s 776,572,071 for `-E -P` (+0.35%), and
  825,240,863 against 831,525,020 for `-E` (-0.76%), at the same cycles.
- **Disassembly** (`disasm-fix4.txt`, `scripts/disasm.sh`, with addresses and rip-relative offsets normalized):
  - These are instruction for instruction main's: `pp_print_spellings`, `pp_history_fill`, `pp_history_change`,
    `pp_append_tokens`, `pp_emit_simple_write`, `pp_expand_current`, `pp_continue_invocation`, `pp_compile_macro`,
    `pp_stringize`, `tokenize_c_raw_no_separators`, `refine_pass_b_64_plain` and `pp_scan_arguments`.
  - These still differ, each inlining one test of an option: `pp_print` (the default instances call
    `pp_comment_as_written` behind `keep_comments` and `pp_trailing_splice` out of line, but no `pp_print_events`),
    `pp_substitute`, `pp_paste_in_place`, `pp_run_contexts`, `pp_invoke`, `pp_spelling` and `pp_without_splices`.

### Correctness on the 9700X

Each tree's Develop build ran `scripts/tests.sh` with CI's Clang 23.1.4: 17 CI blocks (`tests-final.list`: the
preprocessor's, the carets', the lexers' and the frozen preprocessor corpus's), `test-preprocessor` and
`test-checker --requests`. On `fix4` and on the merge with main (`final`):

- 15 of the 17 blocks pass.
- `test-preprocessor`: 0 of 419 cases fail.
- The lexer's kept comments: 0 of 80,020 inputs fail, in each of the 7 lexer blocks.
- `test-checker --requests`: 227 checks, 0 failures.
- The two blocks that fail, the repository's units against clang and the cases part 2 of 4, give the same failing
  items with main `ef3d3769a`'s Develop build (`two-maindev.log`, `two-final.log`):
  - 45 of 66 files;
  - 41 of 41 taken option sets.

  The cause is the resource directory's path in the line markers: clang's staged toolchain is under `~/.cache`.
- `build/dco audit` of the merge: 7 signed, 0 missing (`dco-final.log`).
