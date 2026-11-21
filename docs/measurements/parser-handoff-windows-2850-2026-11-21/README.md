# Parser handoff and declaration-window experiments for #2850

Experiments on Buster main `6e9c51b9d238734468dccc03ab1b6c715449804e` on the locked Ryzen 7 9700X, CPU 2. Each patch in [source](source) applies independently to that revision. The untouched baseline was built by the normal Release toolchain. The frozen SQLite primary is 9,507,037 bytes. Its actual default stream in the row dump has 716,136 PP tokens, the same number of grammar tokens and no pragma events. The normal vector parse sends six declarations, 8,391 tokens, to its fallback.

Three fresh baseline processes each ran seven interleaved passes over the parser benchmark. Their median cycle costs per token were 3.748 for conversion alone, 2.262 for the warm combined keyword/conversion entry, 29.690 for the whole vector path, 9.214 for K6 alone, 11.310 for traversal and 11.686 for traversal including subtree sizes. The rows time different entry points and cache states. The C driver’s `tree_only` parse leaves traversal to the checker. Three real fresh `--time-stages -c` processes took median 9.537 ms in preprocessing, 7.109 ms in parsing, 45.008 ms in check-input and 120.607 ms in total. [Baseline samples](native/baseline.tar.xz)

## K6 produces two masks for fallback

The first candidate keeps K6's attribute lookback classes within the original 64-token block. It writes the parameter-role mask and top-level declaration-end mask to one 16-byte record, and consumes it when visiting the flags for fallback. This deletes the ordinary full class and group byte columns and the separate role-publication pass. The test oracle still requests full classes and groups and compares every window against the dense group/depth/role columns under ordinary, full-depth and forced scalar-block K6. On frozen SQLite the two old columns reserve 1,432,784 bytes with padding. The window column reserves 179,104 bytes, saving 1,253,680 logical bytes. [Measured patch](source/pp-parser-window-final.patch)

Seven independently locked, pinned rounds ran ABBA, reversing the order every other round. For each process the consume benchmark ran seven passes, the fresh compile reported its stages and PMU, and external wall was taken by the normal time-runs driver with one warmup and two measured children under each page policy. The table uses medians within a round and median over paired round changes. The two absolute columns are each arm’s median across rounds.

| SQLite measure | Original | Candidate | Paired change | Seven-round range |
| --- | ---: | ---: | ---: | ---: |
| Whole warmed vector path, cycles/token | 29.611 | 29.447 | −0.565% | −0.907% to +0.097% |
| K6, cycles/token | 9.189 | 9.287 | +0.926% | 0.000% to +1.714% |
| Fallback, cycles/token | 1.362 | 1.376 | +0.401% | −0.548% to +2.077% |
| Fresh parse stage, ms | 7.079 | 7.111 | +0.445% | −0.296% to +1.596% |
| Complete external wall, ordinary pages, ms | 120.802 | 120.661 | −0.153% | −0.418% to +0.096% |
| Complete external wall, huge allowed, ms | 120.891 | 120.865 | +0.114% | −0.169% to +0.318% |
| Ordinary wait4 peak, KiB | 243,656 | 245,576 | +0.788% | +0.787% to +0.790% |

The reduction in logical storage did not reduce measured resident peak or establish a fresh-compile throughput gain. The normal compiler retains its current K6 path. [Full locked samples and object hashes](native/timing-windows.tar.xz)

## Consume the final tree in cache-sized declaration groups

Each ordinary file-scope declaration in a successful C parse is its own ordered tree with its root at the last token. The general traversal supports ordered forests that put a root earlier. The first separate candidate groups complete declaration trees, explicitly checks all parents in each candidate window, and falls back to the original whole range for any crossing edge. Widths 256, 1,024, 4,096 and 16,384 and the same binary’s width zero were compared with untouched main. Small windows lost. The 16,384-row sizes kernel was 1.649% below the original, while check-input was 0.995% longer, measured over six rounds. [Initial range implementation](source/pp-parser-tree-tiles.patch) · [Width sweep](native/tile-study.tar.xz)

The second version reuses its temporary count, start and last-child storage across windows. The third retains the mandatory whole last-child pass and uses those published last children to find closed cuts. A root with no later child ends its subtree at its own source position, since each subtree occupies a contiguous source interval. Other roots are skipped, so the existing pass supplies the proof without a second validation scan. Its remaining backward and forward passes publish each closed window in full while its temporary data is hot. [Shared scratch](source/pp-parser-tree-reuse.patch) · [Last-child proof](source/pp-parser-tree-passes.patch)

Six rounds at width 4,096 ran three repeated kernels per seven-pass process, and separately charged the whole fresh compile. Relative to untouched main, the last-child version took 9.864 → 8.631 cycles/token without sizes (−12.735%, every round between −15.721% and −6.541%) and 11.698 → 11.066 with sizes (−4.908%, every round between −5.931% and −3.819%). The complete check-input stage took 44.856 → 45.059 ms (+0.452%, −0.738% to +1.071%), and total stage time took 120.459 → 120.701 ms (+0.117%, −0.036% to +0.564%). Standalone traversal and full checking therefore need distinct measurements. [Four-way locked runs](native/tile-followup.tar.xz)

## Exact checks

A standalone witness builds the actual preprocessor and parser at each tested source. It writes counts, fallback verdicts, PP kinds, flags, values, byte locations and history runs, grammar kinds, flags, identifier IDs, source indices and pragma events, followed by roles, depth, parents, postorder, positions, subtree ends, first children, next siblings and subtree sizes. The original and each candidate’s complete initialized byte streams were compared with cmp on 1,372 files, 478,615,991 bytes apiece. The hashes, per-TU counts, test commands and exact byte lengths are retained for all arms. Each sample alone uses the same inherited source bytes and compiler arguments. [Witness source](scripts/pp-parser-dump.c) · [Native checks](native/oracles.tar.xz)

| Corpus | Files | PP rows | Grammar rows | Compared bytes |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 1 | 716,136 | 716,136 | 38,662,680 |
| Lua | 34 | 571,543 | 571,543 | 31,202,147 |
| musl | 1,336 | 5,039,639 | 5,039,561 | 272,256,169 |
| Buster main | 1 | 2,440,352 | 2,439,993 | 136,494,995 |

The K6 candidate passed the native Clang-backed parser suite and 41 explicit depth, tail, attribute and parameter-boundary translation units. Ordinary versus candidate marker text, diagnostics, statuses and complete objects matched on all four corpora’s representative sources, and full -Wall -Wextra syntax diagnostics matched across the input sets. Each tree variant also passed the frozen Clang-backed checks with 3-token windows and all 41 boundary files at widths 1, 63 and 1,024. [Compiler and test receipts](native/checks.tar.xz) · [Replay scripts](scripts)
