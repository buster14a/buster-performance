# Scanning directives once for whole files and windows

The default preprocessor scans a whole file or refines it in windows. The whole-file implementation counts directive tokens and then reads their kinds again to publish positions. The candidate collects start-of-line and directive masks together while reading each 64-token block, allocates the final table, and emits positions from those masks. The reach counters below came from the ordinary preprocessor process on the native Ryzen 7 9700X. They count each prepared file including included headers.

| Mode | Corpus | Whole files | Whole tokens | Whole directives | Whole files below 64 tokens | Windowed files | Windowed tokens | Windowed directives |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| default | lua | 3,135 | 1,551,479 | 169,017 | 1,404 | 0 | 0 | 0 |
| default | sqlite | 159 | 68,425 | 8,589 | 71 | 1 | 1,166,437 | 12,548 |
| default | musl | 23,502 | 16,498,273 | 2,168,328 | 6,773 | 0 | 0 | 0 |
| whole | lua | 3,135 | 1,551,479 | 169,017 | 1,404 | 0 | 0 | 0 |
| whole | sqlite | 160 | 1,234,862 | 21,137 | 71 | 0 | 0 | 0 |
| whole | musl | 23,502 | 16,498,273 | 2,168,328 | 6,773 | 0 | 0 | 0 |

## Size and density comparisons

The whole-file harness checked token counts 0–130 and 28 additional boundaries through 16,384 tokens. Seven directive distributions and both page placements give 2,226 comparisons. Each candidate was checked against independently generated positions and line masks. Each size entry uses the median of three seeded candidate/baseline ratios. Baseline and candidate were interleaved in nine rounds per seed.

| Whole-file scan | Sizes meeting baseline | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Shared eight-word extractor | 684/2,226 | 1.346 | 55.041 |
| Per-word masks | 1,912/2,226 | 0.882 | 26.826 |
| Single-marker shortcut | 2,141/2,226 | 0.756 | 26.965 |
| Dense compressed stores | 2,112/2,226 | 0.730 | 27.473 |
| Bounded stores | 2,200/2,226 | 0.536 | 1.164 |
| Four-position groups | 1,662/2,226 | 0.859 | 60.118 |
| Compact one- and two-marker emission | 2,222/2,226 | 0.523 | 1.164 |
| Local masks with per-word emission | 2,011/2,226 | 0.514 | 1.200 |
| Local masks with bounded stores | 1,912/2,226 | 0.524 | 1.159 |

The compact one- and two-marker implementation met baseline on all 2,212 nonempty-token comparisons. Four zero-token cases exceeded baseline. The complete compiler bypasses scratch acquisition on empty files.

A separate gate compares equivalent extraction from retained window masks with the shipping grouped vector compressor. It covered 57 word counts through 4,096, all 65 popcounts, three mixed distributions, and both ends of protected mappings.

| Window extraction | Cases meeting shipping | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Per word, exact output | 3,194/7,752 | 1.300 | 3.700 |
| Grouped nonzero words, vector compression | 1,080/7,752 | 1.188 | 1.925 |
| Grouped nonzero words, exact output | 2,945/7,752 | 1.288 | 3.934 |

## Complete preprocessor commands

The second compiler keeps up to eight mask pairs in local storage and obtains scratch for longer files. Each version passed the native Clang-backed preprocessor tests. Both versions matched the complete output and diagnostics in all nine mode and corpus combinations. For each command the table gives the median ratio across five paired rounds of three fresh invocations. Positive values mean more user cycles.

| Mask storage | Corpus | Default | Whole files forced | 4,096-byte windows | Isolated scan, baseline → candidate cycles/token |
| --- | --- | ---: | ---: | ---: | ---: |
| Scratch | lua | +0.290% | +0.168% | +0.481% | 0.126 → 0.076 |
| Scratch | sqlite | +0.735% | +0.296% | +1.042% | 0.140 → 0.085 |
| Scratch | musl | +0.141% | -0.149% | +0.163% | 0.423 → 0.164 |
| Local buffer and scratch | lua | -0.260% | -0.323% | +0.417% | 0.127 → 0.075 |
| Local buffer and scratch | sqlite | +0.488% | -0.002% | +0.350% | 0.152 → 0.083 |
| Local buffer and scratch | musl | +0.430% | +0.497% | +0.692% | 0.426 → 0.159 |

The current extractor still wins on most window distributions. The complete preprocessor also uses more cycles for several workloads. The replacement remains experimental.

[Harnesses, patches, per-size measurements, process logs, Clang results and output hashes](native-directive-measurements.tar.xz)

## Directive masks, column placement and eight-lane line ends

The retained-mask implementation scans the token kinds once and shares position extraction with the windowed compiler. It also records which directive kinds occurred. A file with no conditionals can finish without visiting the pairing and note scans. The second layout places the byte-sized kinds between the 32-bit end and link columns. The third layout resolves eight line ends at a time.

The timing driver compared all table fields, notes and guard results at 159 lengths and nine token distributions. Each cell is the median paired candidate/baseline timing ratio for three seeds. In this four-way run, two layouts met baseline at all 1,431 cells. The earlier two-way run of the retained-mask layout missed two alternating inputs at 4,095 and 4,096 tokens.

| Layout | Cells meeting baseline | Median cycle ratio | Slowest cycle ratio |
| --- | ---: | ---: | ---: |
| Retained masks and adjacent 32-bit columns | 1431/1,431 | 0.5852 | 0.9602 |
| Kinds between end and link columns | 1431/1,431 | 0.5899 | 0.9637 |
| Eight simultaneous line-end searches | 1340/1,431 | 0.7166 | 3.8360 |

The first layout also ran in the complete compiler. All nine preprocessing configurations matched the original's output SHA-256 and diagnostics. Each percentage is the median of five paired rounds with three processes per binary. The last two columns give the median complete directive-table benchmark over three runs.

| Corpus | Default | Forced whole file | 4 KiB windows | Parent cycles/token | Retained cycles/token |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | -1.255% | -1.152% | -0.803% | 0.424 | 0.334 |
| sqlite | +0.103% | -0.442% | +0.326% | 0.329 | 0.248 |
| musl | -0.847% | -0.825% | -0.405% | 2.681 | 2.195 |

[Source, native table sweep, Clang-backed suite, compiler outputs and cycle logs](retained-masks-and-line-ends.tar.xz)

## Line ends at the final unsigned token

When a directive has no later line start in the last bitmap word, the line cursor can advance past the largest 32-bit token position. The updated implementation widens the cursor. A sparse-bitmap fixture checks the last marked line, exhaustion in the same word and a directive on the last logical token. The native Clang suite passed its 240 windowed sources, 24 complete units and 64 generated C17 and C23 cases each. A second table oracle passed 52 fixed fixtures and rejected nine deliberate changes to positions, ends, kinds, links, notes and guards.

The updated table builder met baseline at 1,431 of 1,431 cells, across 159 lengths and nine distributions on the 9700X. The median paired ratio over three seeds was 0.5851 and the slowest was 0.9637.

[Compiler patches, native Clang and fixed-oracle results, mutation outcomes and all per-size samples](directive-tables-unsigned-cursor.tar.xz)

## Interleaved directive columns in complete preprocessing

Each configuration matched the untouched parent’s preprocessor output and diagnostics. The first three columns give the median paired change in complete preprocessing user cycles over five rounds with three fresh processes per executable. The last two columns time the directive-table benchmark in cycles per token across three runs.

| Corpus | Default | Forced whole file | 4 KiB windows | Parent table | Candidate table |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | -0.040% | -0.131% | +0.047% | 0.422 | 0.334 |
| sqlite | +1.024% | +0.605% | +0.954% | 0.328 | 0.247 |
| musl | +0.465% | +0.328% | +0.890% | 2.687 | 2.204 |

[Compiler source, output digests, directive-table measurements and process logs](interleave-preprocessing.tar.xz)

## Interleaved columns with an unsigned line cursor in complete preprocessing

Each configuration matched the untouched parent’s preprocessor output and diagnostics. The first three columns give the median paired change in complete preprocessing user cycles over five rounds with three fresh processes per executable. The last two columns time the directive-table benchmark in cycles per token across three runs.

| Corpus | Default | Forced whole file | 4 KiB windows | Parent table | Candidate table |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | -0.784% | -0.944% | -0.552% | 0.422 | 0.331 |
| sqlite | +0.137% | -0.221% | +0.199% | 0.333 | 0.249 |
| musl | -0.490% | -0.334% | +0.023% | 2.683 | 2.180 |

[Compiler source, output digests, directive-table measurements and process logs](bounded-preprocessing.tar.xz)

## Complete bitmap words and an end-of-file line marker in complete preprocessing

The logical end of the token stream is a marked line start. This also gives the final complete bitmap word its own terminating slot. The full-width scanner uses ordinary loads for complete words and a masked load for the last partial word. A fixed-answer table oracle checked 52 fixtures and rejected 13 changes, including a load that crossed the protected end of its input. The Clang comparisons passed. The table gives median paired ratios across three seeds on the 9700X.

| Scanner | Cells meeting parent | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Bounded cursor | 1431/1,431 | 0.5873 | 0.9662 |
| End marker | 1431/1,431 | 0.5289 | 0.9672 |
| End marker and unmasked complete words | 1431/1,431 | 0.5053 | 0.9697 |

Each configuration matched the untouched parent’s preprocessor output and diagnostics. The first three columns give the median paired change in complete preprocessing user cycles over five rounds with three fresh processes per executable. The last two columns time the directive-table benchmark in cycles per token across three runs.

| Corpus | Default | Forced whole file | 4 KiB windows | Parent table | Candidate table |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | -0.979% | -1.158% | -0.672% | 0.425 | 0.297 |
| sqlite | +0.889% | +0.092% | +0.464% | 0.324 | 0.233 |
| musl | -0.534% | -0.584% | -0.377% | 2.678 | 1.986 |

[Compiler source, output digests, directive-table measurements and process logs](fullscan-preprocessing.tar.xz)

## Directive ends from consecutive line ranks

The line-rank experiments derive each directive end by projecting marked hashes into ordered line-start bits, shifting by one and projecting back. An outstanding directive carries across empty bitmap words. The paired implementations materialize the position and end columns together.

Fourteen token distributions span 159 lengths, including zero, every packet boundary in the original matrix, and 16,384 tokens. Each candidate was checked at every cell against the parent for positions, ends, kinds, conditional links, notes and the include guard. Per-cell times are the median of three paired ratios from the locked Ryzen 7 9700X.

| Builder | Original distributions | Five mixed line-start distributions | All | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: | ---: | ---: |
| Current PR, rank experiment | 1,431/1,431 | 794/795 | 2,225/2,226 | 0.7200 | 1.0398 |
| Ends during scan | 1,429/1,431 | 756/795 | 2,185/2,226 | 0.5650 | 1.2750 |
| Ends after scan | 1,429/1,431 | 765/795 | 2,194/2,226 | 0.5866 | 1.2937 |
| Sparse line ranks | 1,431/1,431 | 751/795 | 2,182/2,226 | 0.5637 | 1.2201 |
| Current PR, paired experiment | 1,431/1,431 | 794/795 | 2,225/2,226 | 0.7069 | 1.0352 |
| Paired words | 1,430/1,431 | 778/795 | 2,208/2,226 | 0.5780 | 1.0724 |
| One-bit fast path | 1,422/1,431 | 773/795 | 2,195/2,226 | 0.5755 | 1.1261 |
| Enumerated bits | 1,419/1,431 | 771/795 | 2,190/2,226 | 0.7026 | 1.1465 |

The current PR builder exceeded scalar in the following expanded-harness cells. Shape 11 places a line start every 521 tokens and marks two of each three starts as directives.

- line-ranks, 16,384 tokens, shape 11, ratio 1.0398.
- paired-lines, 16,384 tokens, shape 11, ratio 1.0352.

[Source, commands, checks and every timing sample](directive-line-ranks.tar.xz)
