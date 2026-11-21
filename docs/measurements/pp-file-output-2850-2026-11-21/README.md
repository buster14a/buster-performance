# Reading immutable file runs at the preprocessor output

Both experiments start at the already selected file-text run in `pp_copy_file_text_vector`. They retain the ordinary preprocessor's macro admission, history, include processing and diagnostics. The location experiment omits a copied column for eligible complete blocks. The digit experiment publishes a normalized value while the prepared file's token and spelling are available together. It feeds the ordinary checker's literal consumer. [Issue and bounded claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7064809835) · [Earlier three-token return experiment](../pp-return-windows-2850-2026-11-21/README.md)

## Measured starting point

The frozen compiler source is `6e9c51b9d238734468dccc03ab1b6c715449804e`. In 100 normal SQLite PP lifetimes within one process, a frame-pointer profile captured 22 thousand user-cycle samples, with zero lost. It attributed 43.67% inclusive to preparation, 23.49% to tokenization, 14.33% to refinement, and 8.26% to the inlined final file-text copy and selection. These are inclusive costs with overlapping callees. The 8.26% includes macro checks and direct replacement handling. The two experiments below leave that selection in place and target duplicated output work. The source had 9,507,037 bytes and produced 716,136 PP and grammar tokens. [Profile, build and command](raw/profile.tar.xz) · [Original focused profile script](scripts/pp-source-profile.sh)

## Borrow original file starts for location words

A complete selected 64-token file block with no direct macro replacement maps monotonically onto its prepared file's starts and one inclusion base. The producer records the destination span, first source-start address and base and omits those absolute location stores. It coalesces adjacent compatible spans. Short runs, macro substitutions, inserted tokens and buffer outputs retain their dense locations. Each span uses 24 bytes. Output capacity remains reserved. Earlier partial vectors may touch a word that a full block subsequently borrows. [Producer and complete-read experiment](patches/pp-source-locations.patch)

| Corpus | PP rows | Eligible rows | Spans | Eligible original location bytes |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 716,136 | 133,440 | 1,173 | 533,760 |
| Lua, 34 files | 571,543 | 33,472 | 371 | 133,888 |
| musl, 1,336 files | 5,039,639 | 1,158,592 | 7,121 | 4,634,368 |
| Buster main | 2,440,352 | 417,216 | 2,985 | 1,668,864 |

The SQLite span allocation reached 2,048 records or 49,152 bytes, including unused capacity. An independent full-stream comparison checked all 478,615,991 initialized PP, grammar and tree bytes over 1,372 files. It checked the untouched compiler, record-only, restored, borrowed, and deliberately poisoned missing locations. Each borrowed location was read from the original prepared run in source order. [Raw row witness and early failures](raw/location-early.tar.xz)

The normal `-E -P` printer now reads a location block directly from the original run into a 64-entry temporary. It falls back to the dense complement for the other positions. That complete printer produced 35,043,096 identical bytes across all 1,372 inputs, with identical per-file lengths, when every omitted location was overwritten with a poison value. Marker-aware printing materializes dense locations on entry. The normal C compiler already gives prepared file columns back after preprocessing. It reconstructs the borrowed runs before releasing the source starts, charging that cost to compilation. This experiment never holds the full prepared file columns through the checker. [Final printer and release patch](patches/pp-source-location-final.patch) · [Complete printer output receipts](raw/location-final.tar.xz)

A full parser-byte match missed an actual warning replay dependency. The first direct consumer caused the SQLite warning build to report that the replay produced a different translation unit. The first stream's locations had been materialized before releasing file columns, while the fresh replay still held unwritten locations. The corrected route materializes both streams at the real replay comparison and retires the descriptors once their canonical array exists. The error is retained in the early data. The corrected representative ordinary and warning object, `-E` and `-E -P` comparisons, plus the 1,372-source syntax-diagnostic twin, cover this reader. [Initial failing implementation](patches/pp-source-location-print.patch) · [First replay correction and controls](raw/location-replay.tar.xz)

## Supply ordinary checker literals from selected source

The second producer recognizes original one-byte decimal spellings in selected final file-text lanes, excluding direct macro replacements. It uses the file's already prepared kind, start and end. A source-indexed byte encodes zero for ordinary lookup and 1–10 for values 0–9. The ordinary checker's vector input gathers these bytes for literal source indices and removes covered lanes before the usual PP-kind, source-location, end, range, byte gather and digit conversion. The source bytes and canonical PP columns keep their original meaning. Other literals and the out-of-range scalar path keep ordinary decoding. [Producer and actual checker read](patches/pp-source-decimal.patch)

| Corpus | PP rows | Source values supplied | Sum of allocated byte capacities |
| --- | ---: | ---: | ---: |
| SQLite | 716,136 | 19,537 | 1,048,576 |
| Lua | 571,543 | 3,417 | 798,720 |
| musl | 5,039,639 | 39,507 | 7,537,664 |
| Buster main | 2,440,352 | 43,571 | 4,194,304 |

The capacity column sums the peak reservation for each unit independently. Each allocated buffer has four additional bytes for masked gathers. The independent oracle looked up the canonical final PP spelling and kind for every emitted value, and compared the original PP/grammar/tree bytes over all 1,372 inputs. Twenty directed cases additionally cover vector alignments, parameter expansion, token paste, suffixes, octal, hexadecimal, line splices, inactive text, pragmas, and generated line numbers.

The SQLite default checker actually consumed 17,850 source-supplied literal instances. A one-bit change to the first consumed value caused a directed linked fixture to exit 254 instead of zero. The first consumed SQLite value, at PP token 35,072, produced the same complete ELF after perturbation. The targeted control below selects independent known lowered returns by both statement and leaf position to distinguish a carried value from a value discarded before object output. [Targeted fault variant](patches/pp-source-decimal-fault.patch) · [Native run, corpus and control receipts](raw/digit.tar.xz)

Each of eight separately chosen, source-indexed one-bit flips changed the complete SQLite ELF. The original, same-binary off and read controls matched. The source leaves spanned PP tokens 41,693 to 711,109, and every one had an independently lowered whole-return match from the prior source-root experiment. All ten representative source/policy normal objects and warning output streams matched with the enabled reader. SQLite consumed 17,850 instances under both policies, Lua lvm 107, musl vfprintf 201 and Buster main 42,622. The full-corpus warning-diagnostic twin also matched. [Eight individual targets and object hashes](raw/digit.tar.xz)

## Charged comparisons

The location screen used five rotated rounds of untouched compiler, same-binary off, record-only, eager restoration and real direct consumption on the frozen 9700X, pinned to CPU 2. The standalone raw PP process reports user and kernel core cycles across source read, preprocessing, setup and release. The consume-only checksum reads every logical location and excludes PP. The real no-marker printer includes source processing, span consumption, text output and process cost. Fresh normal compilation charges the expiry of prepared file starts and the necessary reconstruction. Staged compiler runs requested huge pages; external compiler children used ordinary allocation, two measured children after one warmup. Each comparison uses within-round pairs. [All absolute medians, ranges and digests](raw/location-final-pairs.txt)

| SQLite location metric | Same binary off | Direct view | Median paired change | Range |
| --- | ---: | ---: | ---: | ---: |
| Raw PP user + kernel cycles/token | 85.941 | 88.582 | +0.960% | −1.124% to +4.649% |
| First consume-only pass, ns/token | 0.068 | 0.154 | +120.775% | −17.688% to +160.527% |
| Warm consume-only pass, ns/token | 0.051 | 0.051 | −0.136% | −0.844% to +0.408% |
| Real no-marker printer user + kernel cycles/token | 96.352 | 97.052 | +0.349% | −1.885% to +3.097% |
| Normal external compile wall, ms | 121.205 | 120.947 | −0.106% | −1.004% to +0.309% |

The raw producer-only record→view control saved 0.029% user instructions on SQLite, yet its process-cycle pairs spanned both signs. Normal staged compile user instructions rose 0.009% in every off→view pair. The corresponding whole-wall change was +0.636% on Lua lvm, −1.388% on musl vfprintf and +0.195% on Buster main, each spanning both signs. Buster main's real printer cycles increased 1.160% in all five pairs. The 88.582-cycle raw PP process exceeds the 35-core-cycle front target even before the parser consumes the result.

The independent digit experiment used four rotated arms, untouched, same-binary off, writer only and writer plus real checker reader. It charged ordinary complete compilation, PP and check-input stages, the one-byte index, and its release. [All paired observations](raw/digit-final-pairs.txt)

| Same-binary off → reader | External wall, ms | Paired wall change | User instructions | Check-input time change |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 121.258 → 122.217 | +0.790% | +0.076% | +0.294% |
| Lua lvm | 14.960 → 15.064 | +0.415% | +0.034% | −0.510% |
| musl vfprintf | 4.034 → 4.163 | +1.894% | +0.061% | +0.487% |
| Buster main | 692.258 → 693.156 | +0.150% | +0.040% | +0.025% |

SQLite's external wall increased in every round, +0.341% to +0.939%. Against the writer alone the actual checker read added 0.005% instructions and 0.494% check-input time in every pair. Omitting real work on individual lanes still submits their original vector groups on the ordinary path. Neither the borrowed-location route nor this byte-indexed digit route earns a production change on these results.
