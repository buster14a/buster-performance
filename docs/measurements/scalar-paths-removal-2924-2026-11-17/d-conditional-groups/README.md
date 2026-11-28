# Preprocessor conditional grouping on Zen 5

## Reach in actual preprocessing

A file-backed process-shared counter in the original compiler counts each prepared file, its directives, a refusal by the vector pairer, the directives in refused files, and successful pairings that require conditional notes. Default and whole-file windows gave the same counts for all three corpora. These include all 34 Lua, one SQLite and 1,336 musl translation units and their headers.

| Corpus | Prepared files | Directives | Refusals | Directives in refused files | Successful pairings requiring notes |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 3135 | 169017 | 0 | 0 | 0 |
| sqlite | 160 | 21137 | 0 | 0 | 0 |
| musl | 23502 | 2168328 | 0 | 0 | 0 |

Seven fixtures exercise whole-compiler preprocessing and Clang on real source files. In both window configurations every candidate output, diagnostic and exit status matched the parent. Clang returned the same exit status and byte-identical stderr on all seven, including multiple diagnostics in the same translation unit. The balanced source with 30,032 open conditionals successfully reproduces the old 16-bit depth refusal. The successful pairer handles extra elses and unterminated groups by asking the notes pass to inspect them.

| Source | Refusals | Directives in refused files | Successful pairings requiring notes | Exit status |
| --- | ---: | ---: | ---: | ---: |
| balanced | 0 | 0 | 0 | 0 |
| depth-30032 | 1 | 60064 | 0 | 0 |
| late-orphan | 1 | 68 | 0 | 1 |
| orphan-else | 1 | 2 | 0 | 1 |
| orphan-endif | 1 | 1 | 0 | 1 |
| second-else | 0 | 0 | 1 | 1 |
| unclosed | 0 | 0 | 1 | 1 |

## Pairing cost by shape and size

The locked Ryzen 7 9700X measured 89 widths from zero through 60,005 directives, including every width through 65. Three seeds each measured 979 size and shape combinations. Each repetition uses the same generated input for the original scalar stack, the shipped vector dispatcher with its fallback, and two candidates. Nine measurements rotate the order of those four functions. Ratios compare median ticks for the same seed and input, then take the median of three paired ratios. The original scalar stack only computes the links. The candidates also decide whether the file requires a notes pass.

Each table cell gives the number of widths meeting the scalar stack, the number meeting the original dispatcher, and the median candidate/stack ratio over the 89 widths. The checks compare all final links against the shipped stack and the note bit against a separate expectation. Each of three seeds also passed all 15,516 randomized, deep and boundary checks for each pair of candidates.

| Shape | 16-lane conflicts | Runs | 64-bit local stack | Sparse stack writes |
| --- | ---: | ---: | ---: | ---: |
| Other directives | 89/89 · 89/89 · 0.09 | 89/89 · 89/89 · 0.10 | 89/89 · 89/89 · 0.07 | 88/89 · 89/89 · 0.07 |
| Only orphan ends | 89/89 · 89/89 · 0.07 | 88/89 · 89/89 · 0.16 | 89/89 · 89/89 · 0.05 | 88/89 · 89/89 · 0.05 |
| Only orphan middles | 89/89 · 89/89 · 0.14 | 86/89 · 89/89 · 0.29 | 87/89 · 89/89 · 0.09 | 88/89 · 89/89 · 0.09 |
| Last directive is an orphan end | 89/89 · 89/89 · 0.10 | 88/89 · 89/89 · 0.13 | 89/89 · 89/89 · 0.07 | 88/89 · 89/89 · 0.07 |
| Orphan end, open, else, end | 2/89 · 5/89 · 2.79 | 1/89 · 7/89 · 7.42 | 29/89 · 84/89 · 1.05 | 32/89 · 84/89 · 1.02 |
| Deep opens followed by ends | 6/89 · 52/89 · 1.70 | 62/89 · 89/89 · 0.74 | 48/89 · 89/89 · 0.99 | 38/89 · 88/89 · 1.02 |
| Open, elif, else, end | 1/89 · 54/89 · 2.57 | 1/89 · 10/89 · 8.55 | 1/89 · 75/89 · 1.69 | 0/89 · 76/89 · 1.63 |
| Open followed by else directives | 1/89 · 52/89 · 2.13 | 63/89 · 89/89 · 0.96 | 0/89 · 66/89 · 1.73 | 0/89 · 69/89 · 1.60 |
| Sparse regular groups | 3/89 · 33/89 · 2.16 | 1/89 · 33/89 · 2.36 | 85/89 · 89/89 · 0.48 | 87/89 · 89/89 · 0.40 |
| Dense random conditionals | 2/89 · 27/89 · 2.86 | 2/89 · 25/89 · 5.65 | 1/89 · 74/89 · 1.50 | 1/89 · 71/89 · 1.58 |
| Sparse random conditionals | 51/89 · 72/89 · 0.89 | 86/89 · 88/89 · 0.45 | 88/89 · 89/89 · 0.22 | 87/89 · 89/89 · 0.18 |

## Complete preprocessing

The conflict-detection compiler passed all 419 frozen fixtures, 128 Clang fuzz comparisons and the one-, two-, three- and eight-lane determinism suite. Its `-E` comparisons used five paired rounds of three fresh processes and verified stdout hashes and stderr. The table construction benchmark separately timed 21 passes over representative source files per invocation, with three paired invocations. Percent changes are candidate over parent in user cycles for the three driver columns and cycles per token for the final column.

| Corpus | Default | Whole file | 4 KiB windows | Directive tables |
| --- | ---: | ---: | ---: | ---: |
| lua | -0.502% | -0.438% | -0.421% | -5.463% |
| sqlite | -0.148% | -0.371% | -0.373% | +4.615% |
| musl | +0.187% | +0.276% | +0.269% | -10.887% |

Several mixed or dense inputs still take more cycles than the scalar stack. These results qualify individual inputs and leave the per-size gate open.

[Source changes, original baselines, independent checks, per-size samples, paired commands and raw native process measurements](pairing-native.tar.xz)
