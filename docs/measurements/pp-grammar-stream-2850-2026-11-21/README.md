# Produce the parser's input in the PP keyword window

The ordinary compiler can consume a complete straight-stream parser input directly from the preprocessor's existing keyword-resolution blocks. On the frozen SQLite source the producer published all 716,136 grammar rows. Its downstream parser omitted the entire ordinary token conversion. The sized inline version reduced the post-PP interval by 5.768% but increased the combined PP-through-parse interval by a paired median 0.829%, with changes spanning both signs. Its seven directly paired normal-driver readings gave 88.573 user and 125.420 user-plus-kernel cycles per token. The front’s target is 35. All three producers remain experiments. [Claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7065970375) · [Earlier #335 experiment and original consumer contract](https://github.com/buster14a/buster/blob/ec320d42bbe10f34fc62bf6d0072ba8898da2df0/docs/c-parser.md#consumer-contract-for-the-preprocessing-to-parser-handoff-335)

The candidate attaches after normal compiler initialization and writes parser-owned padded, writable grammar kinds, keyword/identifier names and flags as each PP keyword block is finalized. A straight stream has #3242's implicit PP source indices. A removed pragma, doubled colon, reversed or oversized callback, bounded address-space configuration or unsuccessful allocation uses ordinary conversion. The research limit is 1,048,576 input tokens. A separate parser arena reserves up to twice that limit plus the normal token/sentinel capacity so later parser views retain writable room. All original preprocessor columns stay live for the rest of the compiler.

The four arms are the untouched `ec320d42bbe10f34fc62bf6d0072ba8898da2df0` parent, one candidate executable with the feature off, producing but retaining the ordinary parser conversion, and producing plus consuming. The initial version calls the parser's block writer once per PP keyword vector and reads the identifier values from final PP columns. [Callback source](patches/pp-grammar-stream-final.patch)

## Output and real compilation

| Corpus | Input files | Files taking the direct columns | PP rows written before completion or fallback |
| --- | ---: | ---: | ---: |
| sqlite | 1 | 1 | 716,136 |
| lua | 34 | 34 | 571,543 |
| musl | 1,336 | 1,318 | 5,035,186 |
| main | 1 | 0 | 0 |

The full 1,372-file PP output/history, grammar source map and pragma events, grammar roles, bracket depths, parents and traversal witness matched the parent byte for byte (478,615,991 bytes). All 1,372 complete objects, diagnostics and statuses matched under default and extra warnings. The 680 source/policy cases compared parent with both writer-only and adopted columns for normal/debug objects or syntax (1,360 candidate comparisons). They cover malformed recovery, empty input, colons, pragma packs, attributes, macros, typo handling and offsets adjacent to the vector and 16k-token chunk boundaries. The adoption-only fault changed an accepted file and SQLite into diagnosed failures in the ordinary compile. The same fault switch with production off or without consumption retained the fixture's complete original ELF. [Native proof, cases and hashes](raw/grammarfinal.tar.xz)

## Six one-core rotations

For each source and arm, one locked 9700X CPU 2 standalone process measured actual raw-source PP plus tree-only parsing with user and kernel PMU, including setup and release. It uses the public option parser's defaults, which retain eager expansion history and omit the semantic-driver pragma mode. The ordinary compiler below enables semantic pragmas and defers history on these normal compiles. It used the frozen files and precise command options, with separate nanosecond totals for PP and parsing. Each independent huge-page-allowed `--time-stages -c` run measured complete native compilation. Two ordinary-allocation external children after one warmup measured real wall. All values are within-round paired and each complete output object matched. SQLite is the amalgamation, Lua lvm and musl vfprintf are the respective single-unit timing representatives, and Buster main is the frozen self-host source. [Absolute and paired metrics](raw/paired.tsv)

| Callback arm | Comparison | Raw PP+parser process cycles/token | Staged PP+parse wall | Complete external wall, ms | Paired external wall, range | Whole user instructions |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | write → take | 151.362 → 148.300 | -1.236% | 117.828 → 117.172 | -0.453% (-0.719% to +0.390%) | -0.067% |
| sqlite | off → take | 149.014 → 148.300 | +1.052% | 117.440 → 117.172 | -0.191% (-0.722% to +0.203%) | +0.046% |
| sqlite | parent → take | 146.886 → 148.300 | +0.829% | 117.147 → 117.172 | +0.110% (-0.491% to +0.774%) | +0.034% |
| lua | write → take | 429.666 → 433.294 | -0.606% | 11.084 → 11.340 | +2.528% (+1.908% to +3.207%) | -0.075% |
| lua | off → take | 416.656 → 433.294 | +5.336% | 11.033 → 11.340 | +2.687% (+0.228% to +3.662%) | +0.051% |
| lua | parent → take | 413.584 → 433.294 | +4.759% | 10.959 → 11.340 | +3.784% (+2.949% to +4.497%) | +0.075% |
| musl | write → take | 581.633 → 607.792 | +4.194% | 4.057 → 4.197 | +2.981% (+0.947% to +4.862%) | -0.054% |
| musl | off → take | 579.863 → 607.792 | +7.683% | 4.030 → 4.197 | +3.305% (+1.388% to +7.175%) | +0.034% |
| musl | parent → take | 574.254 → 607.792 | +7.428% | 4.016 → 4.197 | +4.221% (+2.026% to +5.895%) | +0.003% |
| main | write → take | 156.476 → 156.330 | +0.031% | 681.076 → 681.465 | +0.047% (-0.161% to +0.463%) | +0.000% |
| main | off → take | 156.426 → 156.330 | +0.332% | 681.745 → 681.465 | +0.064% (-0.194% to +0.240%) | +0.000% |
| main | parent → take | 155.274 → 156.330 | +0.442% | 679.981 → 681.465 | +0.265% (+0.054% to +0.697%) | +0.015% |

On SQLite the callback changed the fresh preprocessor stage from 9.489 → 10.025 ms and the fresh parse stage from 6.846 → 6.489 ms. Peak resident wait4 memory changed +1.205%. An independently allocated prepared destination separately measured the real conversion or adoption/padding before an identical grammar checksum over all rows. Eleven warm repetitions per arm in each of six processes cost 0.437 → 0.001 TSC ticks per token for that action. The subsequent checksum cost 1.379 → 1.372 TSC ticks per token. Those prebuilt-input figures exclude source processing. [Meter](scripts/pp-grammar-meter.c)

## Writing from the existing live identifier values

The integrated version calls the parser only to bind storage. The PP loop itself then uses its existing masked identifier load for both keyword resolution and the parser's name field, writes flags and grammar kind, and advances the producer's progress. Other PP paths retain their ordinary keyword routine. The stopped remaining portion of a range uses normal keyword classification. [Integrated source](patches/pp-grammar-inline.patch) · [Independent full corpus, fault and measured results](raw/grammarinline.tar.xz)

| Integrated arm | Comparison | Raw PP+parser process cycles/token | Staged PP+parse wall | Complete external wall, ms | Paired external wall, range | Whole user instructions |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | write → take | 149.185 → 148.418 | -1.587% | 117.614 → 117.136 | -0.543% (-0.807% to -0.176%) | -0.067% |
| sqlite | off → take | 148.158 → 148.418 | +1.276% | 117.344 → 117.136 | -0.198% (-0.541% to +0.109%) | -0.019% |
| sqlite | parent → take | 146.774 → 148.418 | +1.571% | 117.225 → 117.136 | -0.215% (-0.684% to +0.647%) | -0.019% |
| lua | write → take | 424.449 → 432.549 | +0.726% | 11.070 → 11.304 | +1.996% (+0.546% to +2.690%) | -0.075% |
| lua | off → take | 414.180 → 432.549 | +5.821% | 10.899 → 11.304 | +3.644% (+0.925% to +4.571%) | -0.021% |
| lua | parent → take | 412.214 → 432.549 | +5.495% | 10.919 → 11.304 | +3.535% (+2.210% to +4.203%) | -0.019% |
| musl | write → take | 591.298 → 604.099 | +3.300% | 4.043 → 4.164 | +3.660% (+1.162% to +13.445%) | -0.053% |
| musl | off → take | 582.090 → 604.099 | +6.640% | 4.000 → 4.164 | +4.543% (+2.761% to +13.120%) | -0.016% |
| musl | parent → take | 580.009 → 604.099 | +7.437% | 4.002 → 4.164 | +4.015% (-0.450% to +13.786%) | -0.010% |
| main | write → take | 155.571 → 156.208 | +0.077% | 679.116 → 679.870 | -0.076% (-0.263% to +0.248%) | -0.000% |
| main | off → take | 155.338 → 156.208 | +0.513% | 680.386 → 679.870 | -0.223% (-0.299% to +0.148%) | +0.000% |
| main | parent → take | 155.823 → 156.208 | +0.407% | 679.702 → 679.870 | -0.160% (-0.601% to +0.319%) | -0.001% |

## Price the storage reservation

A third implementation retains the inline producer while reserving its buffer using input facts already available. When the preprocessor's final output size is known the exact row count bounds it. When it binds an earlier chunk it estimates the remaining room from the main file's byte size, with a floor of 8,192 and a ceiling of 1,048,576 input rows. If headers or expansion exceed the estimate the untouched conversion runs. This isolates the price of the original fixed reservation on smaller translation units. [Adaptive reservation patch](patches/pp-grammar-sized.patch) · [Separate qualification and raw samples](raw/grammarsized.tar.xz)

| Sized inline arm | Comparison | Raw PP+parser process cycles/token | Staged PP+parse wall | Complete external wall, ms | Paired external wall, range | Whole user instructions |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | write → take | 149.560 → 148.180 | -1.882% | 117.790 → 117.021 | -0.621% (-0.874% to -0.148%) | -0.067% |
| sqlite | off → take | 148.619 → 148.180 | +1.139% | 117.529 → 117.021 | -0.336% (-8.435% to +0.960%) | -0.019% |
| sqlite | parent → take | 146.710 → 148.180 | +0.188% | 117.091 → 117.021 | -0.091% (-0.543% to +0.848%) | -0.019% |
| lua | write → take | 418.050 → 417.245 | -2.166% | 10.979 → 10.896 | -1.128% (-1.509% to +0.073%) | -0.075% |
| lua | off → take | 414.323 → 417.245 | +0.089% | 10.863 → 10.896 | +0.220% (-0.433% to +0.627%) | -0.021% |
| lua | parent → take | 412.152 → 417.245 | +0.113% | 10.917 → 10.896 | -0.368% (-1.039% to +0.492%) | -0.018% |
| musl | write → take | 586.162 → 576.462 | -0.769% | 4.057 → 4.006 | -1.343% (-3.680% to +0.408%) | -0.055% |
| musl | off → take | 586.273 → 576.462 | +2.483% | 4.000 → 4.006 | -1.046% (-4.331% to +2.420%) | -0.014% |
| musl | parent → take | 575.496 → 576.462 | +2.141% | 3.992 → 4.006 | -0.116% (-1.241% to +1.891%) | -0.007% |
| main | write → take | 155.864 → 155.997 | -0.462% | 680.311 → 680.692 | +0.148% (-0.493% to +3.205%) | +0.000% |
| main | off → take | 156.110 → 155.997 | -0.240% | 681.049 → 680.692 | -0.105% (-0.278% to +3.376%) | +0.000% |
| main | parent → take | 156.313 → 155.997 | -0.183% | 680.271 → 680.692 | +0.035% (-0.423% to +3.275%) | -0.000% |

The sized producer changed frozen SQLite PP from 9.488 → 9.881 ms and parsing from 6.811 → 6.450 ms. Against the untouched build, the six paired PP-plus-parse differences had a median of +0.188% (-0.518% to +1.406%). Complete SQLite wall changed -0.091% (-0.543% to +0.848%) and whole retired user instructions changed -0.019%. In the same candidate executable the off-to-take median complete wall change was -0.336% (-8.435% to +0.960%). These ranges show the price of writing the columns in the preceding stage alongside the conversion removed from parsing. The complete compiles also charge the reservation and surviving PP columns. The independently instrumented driver below counts the actual on-CPU work.

## Admission inside actual complete compiles

These are records from the ordinary single-lane compiler using its semantic pragmas, deferred-history policy and the default or extra warning policy. Removing the instrumentation lines leaves stdout and stderr byte-identical to the exact parent, and the entire object manifest is compared again for each policy. The earlier admission table specifically describes the independent full-front witness.

| Producer | Source and warning policy | Actual compile units | Direct inputs | Input rows | Rows produced before completion/fallback |
| --- | --- | ---: | ---: | ---: | ---: |
| grammarfinal | sqlite default | 1 | 1 | 716,136 | 716,136 |
| grammarfinal | sqlite extra | 1 | 1 | 716,136 | 716,136 |
| grammarfinal | lua default | 34 | 34 | 571,543 | 571,543 |
| grammarfinal | lua extra | 34 | 34 | 571,543 | 571,543 |
| grammarfinal | musl default | 1,336 | 1,318 | 5,039,639 | 5,035,186 |
| grammarfinal | musl extra | 1,336 | 1,318 | 5,039,639 | 5,035,186 |
| grammarfinal | main default | 1 | 0 | 2,440,352 | 0 |
| grammarfinal | main extra | 1 | 0 | 2,440,352 | 0 |
| grammarinline | sqlite default | 1 | 1 | 716,136 | 716,136 |
| grammarinline | sqlite extra | 1 | 1 | 716,136 | 716,136 |
| grammarinline | lua default | 34 | 34 | 571,543 | 571,543 |
| grammarinline | lua extra | 34 | 34 | 571,543 | 571,543 |
| grammarinline | musl default | 1,336 | 1,318 | 5,039,639 | 5,035,186 |
| grammarinline | musl extra | 1,336 | 1,318 | 5,039,639 | 5,035,186 |
| grammarinline | main default | 1 | 0 | 2,440,352 | 0 |
| grammarinline | main extra | 1 | 0 | 2,440,352 | 0 |
| grammarsized | sqlite default | 1 | 1 | 716,136 | 716,136 |
| grammarsized | sqlite extra | 1 | 1 | 716,136 | 716,136 |
| grammarsized | lua default | 34 | 34 | 571,543 | 571,543 |
| grammarsized | lua extra | 34 | 34 | 571,543 | 571,543 |
| grammarsized | musl default | 1,336 | 1,317 | 5,039,639 | 4,913,559 |
| grammarsized | musl extra | 1,336 | 1,317 | 5,039,639 | 4,913,559 |
| grammarsized | main default | 1 | 0 | 2,440,352 | 0 |
| grammarsized | main extra | 1 | 0 | 2,440,352 | 0 |

## Writable columns and bounded reservations

The accepted fixture produced a complete identical object and the damaged fixture reported the same two source locations with status 1. Each producer passed under ordinary and poisoned arenas, unbounded and 2 GiB process address space. A separate traced ordinary compile confirmed direct consumption without the bound and fallback under the finite limit. Each arm's raw archive includes both compilers' status, streams and object hashes.

## Actual hardware cycles between the driver’s PP entry and completed parse

The in-driver probes count current-thread user and kernel hardware cycles on 9700X CPU 2, with one lane and verified ordinary semantic pragmas and deferred history. The first snapshot follows the actual `pp_run_input` return. The second is immediately after `parse_translation_unit`, before diagnostics. The interval between them includes lane admission and release of the file columns. Counter setup starts after the driver/PP/parser initialization and the candidate’s option binding. Complete-process and complete-compile rows above charge those costs separately. Every reading records enabled and running times and the expected ELF hash. Seven separately scheduled rounds per executable alternate allocation order. Round-index differences here match the same source and page policy, although the two builds’ PMU subprocesses were scheduled separately. The four-arm stage and external comparisons above used directly rotated compiler arms. The instructions observation includes printing the first counter at the end. [Exact counters](raw/driver-front.tsv) · [Unrounded native snapshots and binary hashes](raw/front-pmu.tar.xz) · [Parent probe](patches/pp-front-pmu.patch) · [Sized-producer probe](patches/pp-grammar-sized-pmu.patch)

| Source | Page policy | Phase | Parent cycles/PP token | Sized producer cycles/PP token |
| --- | --- | --- | ---: | ---: |
| lua | huge | PP-entry-through-parse | 291.332 | 291.209 |
| lua | huge | PP-through-return | 211.208 | 216.841 |
| lua | huge | after-PP-through-parse | 81.190 | 74.738 |
| lua | normal | PP-entry-through-parse | 292.100 | 292.996 |
| lua | normal | PP-through-return | 210.910 | 216.476 |
| lua | normal | after-PP-through-parse | 81.700 | 75.508 |
| main | huge | PP-entry-through-parse | 131.156 | 131.059 |
| main | huge | PP-through-return | 82.786 | 83.144 |
| main | huge | after-PP-through-parse | 48.049 | 48.215 |
| main | normal | PP-entry-through-parse | 131.235 | 130.786 |
| main | normal | PP-through-return | 83.002 | 82.858 |
| main | normal | after-PP-through-parse | 48.215 | 47.960 |
| musl | huge | PP-entry-through-parse | 296.354 | 294.568 |
| musl | huge | PP-through-return | 194.433 | 198.807 |
| musl | huge | after-PP-through-parse | 101.921 | 95.593 |
| musl | normal | PP-entry-through-parse | 292.359 | 287.109 |
| musl | normal | PP-through-return | 192.746 | 195.238 |
| musl | normal | after-PP-through-parse | 102.150 | 92.971 |
| sqlite | huge | PP-entry-through-parse | 127.618 | 126.609 |
| sqlite | huge | PP-through-return | 74.674 | 76.742 |
| sqlite | huge | after-PP-through-parse | 52.979 | 49.867 |
| sqlite | normal | PP-entry-through-parse | 127.592 | 127.780 |
| sqlite | normal | PP-through-return | 73.902 | 78.363 |
| sqlite | normal | after-PP-through-parse | 53.255 | 49.722 |

The sized SQLite producer consumed 78.363 hardware cycles per output token through the end of preprocessing and 127.780 through parsing, before any additional flat-window producer. Step 3 budgets 35 for the full front.

## User and kernel cycles in the real source front

A separate pair of instrumented compilers enabled one hardware group immediately before the same PP entry and disabled it immediately after the parser returned. The group counted user cycles, kernel cycles and total instructions together, including a single intermediate snapshot at PP return. Compiler variants and allocation policies rotated together, giving seven directly paired runs of each combination for each frozen source. The measured compiler retained ordinary output and every full ELF matched the frozen hash. All snapshots passed the 99.5% hardware-running threshold. The ordinary-page-policy row below shows each counter’s own median. The total is the median of the summed user and kernel cycles within each run. [Grouped event measurements](raw/driver-privilege.tsv) · [Raw group reads](raw/grouped-driver.tar.xz) · [Comparison procedure](scripts/pp-front-group.sh)

| Frozen SQLite ordinary allocation | Parent user cycles/token | Sized user cycles/token | Parent kernel cycles/token | Sized kernel cycles/token | Parent total cycles/token | Sized total cycles/token |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| PP-through-return | 58.586 | 59.719 | 13.701 | 16.402 | 72.243 | 76.177 |
| after-PP-through-parse | 30.304 | 28.855 | 22.098 | 20.650 | 52.473 | 49.576 |
| PP-entry-through-parse | 88.848 | 88.573 | 35.588 | 37.219 | 124.940 | 125.420 |

The directly paired sized arm reached 88.573 user cycles and 125.420 user-plus-kernel cycles per token through parsing. The 35-cycle target includes the front’s resulting window. The ordinary PP and parse measured here still precede any additional flat-window construction.

## Are macro arguments scanned twice?

A source-only census uses the ordinary preprocessor’s semantic pragmas and deferred history. It records a file fast-path scan and counts a repeated scan only when the regular collector sees the identical immutable file buffer, opening token, limit, variadic status and parameter count. Every matched second result was compared to the first closing token and every separator before it was counted. The second-scan TSC includes timestamp overhead. [Census with all per-file results](raw/argument-rescans.tar.xz) · [Source and exact match](scripts/pp-scan-census-gen.py)

| Corpus | File fast-path scans | Ordinary collector scans | Repeated scans | Tokens across repeated complete ranges | Repeated-scan TSC ticks |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | 8,767 | 12,416 | 322 | 2,019 | 13,340 |
| lua | 2,195 | 33,503 | 132 | 1,196 | 6,632 |
| musl | 1,932 | 45,469 | 160 | 877 | 5,506 |
| main | 12,971 | 58,774 | 905 | 8,305 | 29,491 |

The 322 matched SQLite calls touched 2,019 tokens, with 13,340 TSC ticks measured across the repeats. Input and output counters disqualify this duplication as an explanation for the remaining per-token budget.
