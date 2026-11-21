# Avoiding a unit-wide search for `__clang__` attribute scopes

Across the six SQLite rotations the fused admission reduced warmed conversion and normalization by 19.957%. Ordinary parse wall moved −0.095% with both signs across the six rounds, and complete compile wall moved −0.010% with both signs. The measured improvement is confined to the prepared-input kernel.

After conversion the ordinary parser reads kinds and flags to find macro numbers in front of attribute scopes. A source with no adjacent opening square brackets cannot need the normalization. The earlier #1574 avoided history replay for these files while retaining their scan. This experiment checks what it costs to remove that scan, preserving the old treatment of commas past the first attribute opening. [Bounded claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7066417314) · [Earlier history fix](https://github.com/buster14a/buster/pull/1574)

The frozen parent is `ec320d42bbe10f34fc62bf6d0072ba8898da2df0`. The same experimental compiler offers four modes. Off keeps the original conversion and normalization. Publish records a conservative adjacent-bracket fact while the real conversion holds each vector of PP kinds, and still runs the original normalization. Fused permits that fact to skip normalization. Any token that sends the ordinary conversion through its special-token path conservatively triggers normalization. Read instead tests just the converted kinds and skips normalization on all streams without an opening, including those transformed by pragmas and doubled colons. On a positive candidate both alternatives execute the original normalizer unchanged. Each includes adjacency across vector boundaries. [Exact candidate source](source/pp-parser-scopes.patch)

## Real compilation and replay

| Corpus | Files | Actual grammar rows | Fused files omitting normalization | Read files omitting normalization | Bytes compared in each of three semantic PP/tree/history comparisons |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | 1 | 716,136 | 1 | 1 | 37,955,328 |
| lua | 34 | 571,543 | 34 | 34 | 30,295,859 |
| musl | 1,336 | 5,039,561 | 1,323 | 1,336 | 267,257,937 |
| main | 1 | 2,439,993 | 0 | 1 | 129,323,691 |

Both consuming arms produced the parent’s exact 1,372 complete objects, warnings, stdout and statuses for each of the default and extra warning policies. The independent front witness compared 464,832,815 bytes three times with the original under semantic pragmas and deferred history. It includes PP output, initial or materialized history state, expansion/substitution/generated/source records, grammar columns, source identities, pragma events, tree roles and traversal. The ordinary `-c` admission table uses the driver’s own records. [Source-level witness](scripts/pp-scope-dump.c) · [Native receipts](raw/locked.tar.xz)

All 1,024 directed source/policy combinations compared the parent’s complete result to each of three experimental arms, including preprocessing macros, digraphs, an intervening pragma, nested or malformed input, boundaries around 64/128 and large token counts. With the pinned Clang and seed 133 the ordinary parser tests passed in all four modes from the repository root. The preserved initial run from the scratch directory could not locate `tests/parser-kernels/digests.tsv`. The four corrected runs include that oracle. [Directed cases](scripts/pp-scope-boundaries.py) · [Exact commands](scripts/pp-scope-focus.sh)

The 108 additional C23 scopes crossed 12 token alignments with each of nine spellings. Seventy-two required a recorded history and physically transformed a preprocessor numeric constant into a grammar identifier named `_Clang`. Twelve recorded history while retaining their ordinary grammar token, and 24 retained deferred history. All three candidates matched these observations and all 539,334 bytes of PP/history/grammar/tree output. [C23 semantic witness](scripts/pp-scope-positive.py)

## Isolated parser action

Each of six 9700X CPU 2 processes ran thirteen measured, alternating, mixed-order repetitions on freshly prepared SQLite PP output after the first warmup pass. The conversion and normalization run anew on the same writable grammar destination. Every resulting row contributes to a separate checksum. The two changed actions do not include the preceding source processing or the rest of the parser. [Consume-only meter](scripts/pp-scope-meter.c)

| Comparison | Conversion TSC ticks/token | Normalization TSC ticks/token | Combined TSC ticks/token | Paired combined change |
| --- | ---: | ---: | ---: | ---: |
| 0 → 1 | 0.486 → 0.466 | 0.094 → 0.095 | 0.580 → 0.561 | -3.503% |
| 1 → 2 | 0.466 → 0.465 | 0.095 → 0.000 | 0.561 → 0.465 | -17.031% |
| 0 → 2 | 0.486 → 0.465 | 0.094 → 0.000 | 0.580 → 0.465 | -19.957% |
| 0 → 3 | 0.486 → 0.486 | 0.094 → 0.025 | 0.580 → 0.511 | -11.940% |

Mode 0 is off, 1 publishes, 2 consumes the fused result, and 3 reads the grammar kinds for admission.

## Source-to-object cost

Six rotated sets on the locked 9700X compare an untouched compiler and four modes on the same candidate executable. The source-front probe uses actual semantic pragmas and deferred history with tree-only parsing. Its process metric includes setup and release, user and kernel hardware cycles. The staged ordinary compiler requests huge pages, and the externally timed complete compiles use ordinary allocation, one warmup and two measured children per arm. Every timed object matched its frozen reference. [Paired samples](raw/paired.tsv) · [Exact run procedure](scripts/pp-scope-time.sh)

| Source | Change | Standalone source front cycles/token | Ordinary parse ms | Paired parse | Complete wall ms | Paired wall and range | Whole retired user instructions |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| sqlite | off → publish | 137.232 → 138.957 | 6.809 → 6.934 | +2.023% | 116.664 → 116.993 | -0.084% (-0.523% to +1.609%) | +0.006% |
| sqlite | publish → fused | 138.957 → 138.012 | 6.934 → 6.810 | -0.867% | 116.993 → 116.957 | +0.049% (-1.729% to +0.492%) | -0.044% |
| sqlite | off → fused | 137.232 → 138.012 | 6.809 → 6.810 | -0.095% | 116.664 → 116.957 | -0.010% (-0.530% to +1.266%) | -0.038% |
| sqlite | off → read | 137.232 → 138.264 | 6.809 → 6.807 | -0.605% | 116.664 → 117.048 | -0.039% (-0.438% to +1.039%) | -0.035% |
| sqlite | parent → fused | 137.324 → 138.012 | 6.873 → 6.810 | -0.721% | 117.098 → 116.957 | -0.092% (-8.904% to +0.340%) | -0.036% |
| sqlite | parent → read | 137.324 → 138.264 | 6.873 → 6.807 | -0.793% | 117.098 → 117.048 | -0.047% (-9.170% to +0.351%) | -0.032% |
| lua | off → publish | 357.203 → 359.697 | 1.044 → 1.042 | +0.193% | 10.904 → 10.863 | -0.420% (-0.935% to +0.142%) | +0.008% |
| lua | publish → fused | 359.697 → 357.334 | 1.042 → 1.037 | -0.478% | 10.863 → 10.898 | +0.258% (-0.266% to +1.009%) | -0.050% |
| lua | off → fused | 357.203 → 357.334 | 1.044 → 1.037 | -0.287% | 10.904 → 10.898 | -0.080% (-0.706% to +0.248%) | -0.045% |
| lua | off → read | 357.203 → 357.051 | 1.044 → 1.049 | +1.271% | 10.904 → 10.913 | +0.078% (-1.081% to +0.468%) | -0.040% |
| lua | parent → fused | 358.485 → 357.334 | 1.040 → 1.037 | -0.192% | 10.919 → 10.898 | -0.545% (-1.601% to +0.647%) | -0.041% |
| lua | parent → read | 358.485 → 357.051 | 1.040 → 1.049 | +0.775% | 10.919 → 10.913 | -0.511% (-0.880% to +0.473%) | -0.037% |
| musl | off → publish | 534.229 → 535.270 | 0.281 → 0.274 | -0.313% | 3.984 → 3.992 | -0.056% (-2.198% to +3.461%) | +0.004% |
| musl | publish → fused | 535.270 → 535.483 | 0.274 → 0.279 | +0.555% | 3.992 → 3.956 | -0.420% (-2.772% to +4.668%) | -0.033% |
| musl | off → fused | 534.229 → 535.483 | 0.281 → 0.279 | +1.475% | 3.984 → 3.956 | +0.082% (-3.082% to +6.230%) | -0.028% |
| musl | off → read | 534.229 → 528.757 | 0.281 → 0.276 | -1.762% | 3.984 → 3.999 | +0.398% (-2.873% to +1.911%) | -0.026% |
| musl | parent → fused | 533.358 → 535.483 | 0.269 → 0.279 | +2.805% | 3.996 → 3.956 | -0.661% (-5.733% to +6.335%) | -0.024% |
| musl | parent → read | 533.358 → 528.757 | 0.269 → 0.276 | +2.383% | 3.996 → 3.999 | +0.096% (-5.530% to +1.347%) | -0.023% |
| main | off → publish | 138.733 → 138.861 | 21.346 → 21.360 | +0.067% | 678.829 → 677.196 | -0.241% (-12.154% to +2.501%) | +0.002% |
| main | publish → fused | 138.861 → 138.582 | 21.360 → 21.316 | -0.297% | 677.196 → 677.978 | +0.157% (-2.343% to +0.976%) | +0.000% |
| main | off → fused | 138.733 → 138.582 | 21.346 → 21.316 | -0.271% | 678.829 → 677.978 | -0.085% (-12.200% to +1.336%) | +0.002% |
| main | off → read | 138.733 → 138.885 | 21.346 → 21.337 | +0.280% | 678.829 → 679.564 | +0.187% (-12.010% to +0.642%) | -0.015% |
| main | parent → fused | 137.910 → 138.582 | 21.284 → 21.316 | +0.167% | 678.631 → 677.978 | -0.051% (-0.756% to +1.108%) | +0.013% |
| main | parent → read | 137.910 → 138.885 | 21.284 → 21.337 | +0.642% | 678.631 → 679.564 | +0.132% (-0.532% to +0.387%) | -0.004% |

Two ordinary-page wall observations included unusually large minor-fault counts. The third-indexed round’s SQLite parent had a median 31,368 faults versus about 5,746 in most children. The second round’s Buster off arm had 164,504 versus about 16,910 in most children. The table retains all observations. The source-front and ordinary-compile results leave both admission strategies experimental.
