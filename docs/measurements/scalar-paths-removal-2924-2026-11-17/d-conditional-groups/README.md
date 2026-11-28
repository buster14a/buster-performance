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

## Pair links and complete directive notes

The new pairer uses the carry bits of a 64-bit add to find continuations following their last local opener. Packed conditional ranks match writers to their following directives, and masked stores write the link columns at the original directive indices. Groups extending beyond a packet use a stack of unsigned indices. The implementation records whether a file contains an unterminated group or a middle directive following an else.

Pairing alone and complete pairing with diagnostic notes have different contracts. The isolated link-only control below uses the original stack, which produces links but lacks the flag that selects the notes pass. In the complete stage the forced scalar path calls the notes pass after its stack walk, as the production fallback does. The original dispatcher takes its usual fast path or scalar escape. Every complete stage produces exactly the same links, sorted note indices and note bytes at each of 89 lengths and 11 input shapes. The three seeds use the same input across all four interleaved implementations.

Each cell gives the number of per-size/input ratios at or below one, followed by the median ratio. Three independently seeded rounds run nine rotating interleaved batches per cell on CPU 2 of the locked 9700X. The last two columns cover the 572 cells in which at least one seed actually refused the original vector implementation. All 979 cells remain in the first two columns.

| Complete stage | Forced scalar with notes | Original dispatcher with notes | Reached versus scalar | Reached versus dispatcher |
| --- | ---: | ---: | ---: | ---: |
| Carry links with the original notes pass | 926/979 · 0.302× | 979/979 · 0.189× | 542/572 · 0.140× | 572/572 · 0.108× |
| Traverse notes by group links | 961/979 · 0.216× | 979/979 · 0.180× | 568/572 · 0.139× | 572/572 · 0.109× |
| Reuse the pairing scratch for note bytes | 971/979 · 0.209× | 979/979 · 0.202× | 572/572 · 0.134× | 572/572 · 0.112× |
| Count notes when recording them | 976/979 · 0.200× | 979/979 · 0.199× | 572/572 · 0.134× | 572/572 · 0.112× |
| Allocate both final note columns together | 979/979 · 0.213× | 979/979 · 0.191× | 572/572 · 0.150× | 572/572 · 0.119× |
| Also batch unterminated openers in files without an endif | 977/979 · 0.215× | 979/979 · 0.193× | 572/572 · 0.147× | 572/572 · 0.116× |

| Final implementation by shape | Forced scalar with notes | Original dispatcher with notes |
| --- | ---: | ---: |
| Other directives | 89/89 · 0.041× | 89/89 · 0.196× |
| Only orphan ends | 89/89 · 0.031× | 89/89 · 0.026× |
| Only orphan middles | 89/89 · 0.041× | 89/89 · 0.029× |
| Trailing orphan end | 89/89 · 0.041× | 89/89 · 0.027× |
| Orphan end, open, else, end | 89/89 · 0.234× | 89/89 · 0.144× |
| Deep opens, then closes | 89/89 · 0.380× | 89/89 · 0.257× |
| Open, elif, else, end | 89/89 · 0.394× | 89/89 · 0.249× |
| Open and repeated else | 89/89 · 0.727× | 89/89 · 0.487× |
| Sparse regular groups | 89/89 · 0.252× | 89/89 · 0.224× |
| Dense random conditionals | 89/89 · 0.538× | 89/89 · 0.383× |
| Sparse random conditionals | 89/89 · 0.236× | 89/89 · 0.189× |

For links alone, the carry implementation beat the original dispatcher in all 979 cells and met the bare scalar stack in 863. The note-aware comparison includes the work performed by the fallback's actual caller. Each seed also passed 15,516 independent link and note-presence checks over randomized inputs, deep groups, boundary sizes and orphan directives.

The submitted full compiler passed 419 frozen cases, all 128 Clang fuzz comparisons, and the 1/2/3/8-lane determinism suite. The native corpus reached the original escape on four of the seven targeted source fixtures, including legally balanced 30,032-level nesting.

[Implementations, paired stage measurements, checks and full-compiler build](pairing-notes.tar.xz)

## Complete preprocessor and conditional diagnostics

The compiler containing the joint note allocation and the earlier sparse bit-stack compiler were each measured against the uninstrumented parent on the locked 9700X. The preprocessing columns are paired changes in median user cycles over five rounds of three processes. The directive-table column gives the paired change in cycles per token across three alternating rounds. Output hashes and diagnostics matched for every workload and window size.

| Implementation | Corpus | Default | Whole file | 4 KiB window | Directive table |
| --- | --- | ---: | ---: | ---: | ---: |
| pool | lua | -1.501% | -1.571% | -1.499% | -20.567% |
| pool | sqlite | -0.352% | -0.304% | -0.347% | -13.678% |
| pool | musl | -0.633% | -0.853% | -0.905% | -26.451% |
| bits | lua | -1.412% | -1.418% | -1.315% | -21.277% |
| bits | sqlite | -0.190% | -0.286% | -0.521% | -6.854% |
| bits | musl | -0.448% | -0.186% | -0.228% | -26.572% |

The seven source cases include a 30,032-level nest and unmatched, unclosed or duplicate directives. Both compilers matched parent output, diagnostics and exit status in the default and whole-file modes. Diagnostics and exit status also matched Clang on all seven. The counters below report the original dispatcher’s reach. Each compiler passed all 419 fixed fixtures, the determinism check across 1/2/3/8 lanes, and 128 Clang fuzz comparisons.

| Source | Refusals | Refused records | Successful pairings requiring notes | Clang exit status |
| --- | ---: | ---: | ---: | ---: |
| balanced | 0 | 0 | 0 | 0 |
| depth-30032 | 1 | 60064 | 0 | 0 |
| late-orphan | 1 | 68 | 0 | 1 |
| orphan-else | 1 | 2 | 0 | 1 |
| orphan-endif | 1 | 1 | 0 | 1 |
| second-else | 0 | 0 | 1 | 1 |
| unclosed | 0 | 0 | 1 | 1 |

[Compiler sources, commands, streams, hashes and timings](compiler-corpus.tar.xz)
