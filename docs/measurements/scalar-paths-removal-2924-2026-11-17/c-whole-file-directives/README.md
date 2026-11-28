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
