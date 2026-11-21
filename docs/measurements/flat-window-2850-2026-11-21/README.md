# Flat window producer on the Ryzen 7 9700X

A flat chunk independently supplied the window kernel’s inputs on 50,067 SQLite expressions. When both producers paid to decode literals and intern declaration records in separate arenas, neither implementation reduced the SQLite producer-plus-kernel cost in both execution orders. The second independent implementation took 51.93 or 56.05 estimated core cycles per SQLite token in its producer alone, above Step 3’s budget of 35. This experiment keeps the production compile path on its existing implementation. [Compiler issue and experiment claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7061082317)

## Source and correctness

The compiler base was `cb920fe5712dda47c069649dd6d71059561285cc`. Each variant adds to its predecessor. The exact patches sent to the benchmark host, measured binary digests and native compiler outputs accompany the raw readings.

| Variant | Compiler commit | Change |
| --- | --- | --- |
| first | `29073cf69` | Compact live records by gathering their operator fields. Write the admitted records’ kernel inputs. |
| permute | `3482b7310` | Use consecutive loads and register permutes to compact sixteen records at once. |
| literals | `b171e61d6` | Decode literal tokens from the flat producer’s own compacted columns. |
| declarations | `1ee279989` | Intern declaration lines in a separate arena and compare all four quadwords of each line. |
| names | `6bf9fbbc9` | Resolve names in batches in that private arena. Pin the distance and chunk boundaries in the checker fixture. |

Each variant ran five paired rounds on three corpora. All 150 commands exited successfully. The inputs matched the reference on every admitted record, including expression positions, operator classes, both operand distances, parent distances, literal and declaration lines, and call arguments. The regular T, tests, C and X sweeps consumed these inputs. Parent distances at the root belong to the surrounding expression. A dedicated position mutation made all 20 records in a four-expression fixture differ. The long-expression fixtures require exactly one byte-distance refusal or one cross-chunk refusal. The benchmark for `names` preceded those test-only edits. [Experiment code](https://github.com/buster14a/buster/tree/6bf9fbbc9)

| Corpus | Expressions admitted | Records supplied | Cross-chunk | Distance saturated | Unmapped |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 50,067 | 283,284 | 899 | 4 | 23 |
| Lua | 10,605 | 73,175 | 234 | 0 | 0 |
| musl | 42,684 | 214,915 | 730 | 1 | 0 |
| Buster compiler main (native correctness) | 50,936 | 360,442 | 1,183 | 16 | 36 |

A refusal leaves that expression on the lean producer. The experiment still uses the reader’s existing expression enumeration and the reference chunk’s start to match the two windows. It builds its own packed fields and its own leaf data on accepted expressions. Switching the real compilation front requires resolving the outstanding expressions and eliminating the shadow’s coordination.

## Locked CPU 2 measurements

Each cell contains the median of five paired percentage changes in flat versus lean producer-plus-kernel TSC ticks, flat **after / before** the walk. Both costs are from the same invocation, so each pays for the same admitted kernel records. Lower percentages take fewer ticks.

| Variant | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| first | −4.30% / +3.94% | −8.01% / −2.63% | −4.29% / +2.54% |
| permute | −6.60% / +3.35% | −6.20% / −1.51% | −3.14% / +1.61% |
| literals | −11.55% / −2.63% | −11.56% / −7.46% | −4.15% / −1.33% |
| declarations | +0.53% / +8.50% | −2.16% / +1.64% | +16.85% / +24.81% |
| names | −5.16% / +2.30% | −3.07% / +2.21% | +19.60% / +26.57% |

The first three variants reused declaration lines already interned by the reference. Only the last two charge both producers for that work. In the last variant the range of SQLite paired changes was −5.91% to −4.72% flat-after and +0.86% to +2.95% flat-first. Excluding the common kernel, the producer took 35.87 / 38.72 TSC ticks per one of 716,136 preprocessed SQLite tokens. The approximate core-cycle equivalents above use a 3.7928 GHz TSC and a 5.49 GHz core clock.

For each row of `9700x/stages.tsv`, the lean cost is its compact, identifier-preparation and literal-preparation ticks plus its structural front with the window, the names pass, and the admitted kernel. The flat cost adds its token compaction, its structural passes, the kernel-input writing pass and the same admitted kernel. Variants one and two also include the shared literal preparation as a cost estimate. Variants three through five decode literals in their structural pass, which already includes that cost. Producer counts include construction for the entire corpus, including chunks with a refusal. The admitted-kernel figure comes from a second sweep on just the mutually covered expressions.

Both producers start from an existing parsed and checked input. The stage sums exclude raw lexing, preprocessing, parsing, construction of shared type and declaration rows, the shadow’s reference comparison and fallback evaluation. The whole-command `perf stat` also includes the shadow’s reference work. Neither metric measures ordinary raw-source-to-object throughput. Earlier-than-walk order moves the structural producer, while the assembled window and kernel comparisons still run after the lean window has established its retained prefix.

The five archives in `9700x` contain every command’s stdout, cycles, instructions, branch misses, exit status and completion time. `source-patches.tar.gz` contains the compiler patches as built. The accompanying build, locking and corpus scripts record the command shape. All variants used the same machine, frozen inputs, CPU and compiler settings. In `stages.tsv`, `flat_first=1` selects earlier-than-walk order.

The locked A/A stage-control series provides an ordinary-compile reference for the excluded upstream work. Sixteen invocations of the identical Release binary at the experiment's base `cb920fe57` reported median preprocessing plus parsing of 17.1075 ms on SQLite. At 5.49 GHz that is about 131.15 core cycles per raw preprocessed token. The individual medians were 9.884 ms for preprocessing (including 2.5685 ms lexing) and 7.2185 ms for parsing. The following check-input stage took 45.375 ms and includes additional actions beyond building shared rows. These are ordinary sequential stage timings on the same named corpus. The compiled per-stage file lists all sixteen readings. [Full A/A stage receipts](../switch-selector-2850-2026-11-21/9700x/lanes.tar.gz)

## Native acceptance

The private-declaration producer ran the full shadow campaign. All 8,009 directed probes exited zero. Six generator seeds produced 90,000 programs, with 73,203 accepted, 16,797 rejected and zero findings. Of 93 warning sources, 92 had a trigger and all 92 agreed under their tested policies. In each of three warning policies, 13,889 extracted inline programs gave 6,639 clean and 7,250 rejected. For 1,246 repository files the counts per policy were 416 clean, 829 rejected and one existing difference on the conditional pointer initializer in `tests/checker/sources/pointer-constant-equality.c`. The reference window also reports that difference on the base. The checker shard containing the mask and boundary fixtures passed 210,478 checks on every variant. Raw campaign results are in `native/declarations-campaign.tar.gz`.
