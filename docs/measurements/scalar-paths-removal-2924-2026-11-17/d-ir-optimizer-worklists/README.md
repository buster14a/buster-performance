# IR dead-code removal on Zen 5

Sixteen-instruction root classification compresses live instruction numbers directly into the existing worklist. An instruction changes from dead to live once, so roots and newly live operands each enter the linear queue once. The shipping source and the timed source have identical executable text (SHA-256 `e1fc7c67055c7973d4f9baddd0a3b04c7c20b4ce0de7034b6ab1dcfc4065de70`).

## Real Tier 1 pipelines

The untouched parent is buster14a/buster@cc7d4ffb449c1f57d8d867c2ad2bf6dc6bfebc7f. Clang Release builds ran on CPU 2 of the locked Ryzen 7 9700X. The same probe at each revision brackets the verified optimizer and DCE, using fenced TSC reads. A run measures all 34 Lua, one SQLite and 1,336 musl translation units with one compiler lane and debug information. All five paired rounds presented the same function shapes in the same order and emitted identical objects, stdout and stderr for each mode. Each bin divides summed candidate ticks by summed parent ticks within a round, then takes the median of the five ratios. Counts are per round.

| Input instructions | Default functions | Default pipeline | Default DCE | All-pass functions | All-pass pipeline | All-pass DCE |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 0–31 | 3,345 | 0.9623 | 0.7238 | 3,618 | 0.9551 | 0.6993 |
| 32–127 | 3,222 | 0.9529 | 0.6897 | 3,353 | 0.9549 | 0.6743 |
| 128–511 | 2,625 | 0.9513 | 0.6555 | 2,414 | 0.9526 | 0.6503 |
| 512–2,047 | 788 | 0.9501 | 0.6311 | 651 | 0.9523 | 0.6267 |
| 2,048–8,191 | 136 | 0.9513 | 0.6223 | 82 | 0.9542 | 0.6186 |
| 8,192+ | 8 | 0.9509 | 0.5982 | 6 | 0.9577 | 0.6117 |
| Total | 10,124 | 0.9514 | 0.6478 | 10,124 | 0.9537 | 0.6442 |

## Full compiler processes

Uninstrumented compilers ran five paired rounds, with three fresh processes per executable in each round. The table gives median paired changes in user cycles. Every debug object, stdout and stderr matched in both configurations.

| Corpus | Objects | Default | All passes |
| --- | ---: | ---: | ---: |
| lua | 34 | -0.401% | -0.582% |
| sqlite | 1 | -0.441% | -0.574% |
| musl | 1336 | -0.125% | -0.366% |

## Synthetic optimizer inputs

Each table entry compares the benchmark’s `large-dag` TSC ticks per input instruction, using 11 samples in each process. The block parameter also changes the jump-chain fixture in the raw logs. The emitted graph sizes matched. Small synthetic inputs include timing overhead outside root classification as well as the DCE work. The default-seed optimizer suite passed all 358,076 checks, including its frozen optimize digest `0x292b130a5600b0e5`. Seeds 1, 133 and 789 also passed.

| Requested instructions | 1 block, DCE | 1 block, all | 8 blocks, DCE | 8 blocks, all |
| ---: | ---: | ---: | ---: | ---: |
| 32 | 1.0134 | 1.0073 | 1.0174 | 0.9884 |
| 128 | 0.9806 | 0.9859 | 0.9805 | 0.9874 |
| 512 | 0.9571 | 0.9603 | 0.9515 | 0.9740 |
| 2048 | 0.9503 | 0.9928 | 0.9769 | 0.9753 |
| 8192 | 0.9749 | 0.9850 | 0.9481 | 0.9821 |
| 16384 | 0.9580 | 0.9845 | 0.9744 | 0.9748 |

[Source patches, compiler flags, probes, object and output hashes, raw per-function measurements, synthetic results and correctness logs](dce-native.tar.xz)

## Sparse conditional constant propagation

Newly executable blocks enqueue up to sixteen instructions per packet. An additional incoming edge revisits only the block’s leading phi nodes. When propagation stalls, masked loads find remaining unknown values in reachable blocks, sixty-four at a time. Each packet fits in the current contiguous span of the ring. The implementation uses the existing queue and scratch space.

The instrumentation brackets SCCP and the complete verified pipeline. The parent is buster14a/buster@cc7d4ffb449c1f57d8d867c2ad2bf6dc6bfebc7f. Five alternating paired rounds on CPU 2 of the locked Ryzen 7 9700X processed all 34 Lua, one SQLite and 1,336 musl translation units. Each row sums ticks within a paired round and takes the median ratio over the five rounds. Every pair had identical function shapes, debug objects, stdout and diagnostics. The six size bins in each configuration are the acceptance workload from issue 3445.

| Input instructions | Default functions | Default pipeline | Default SCCP | All-pass functions | All-pass pipeline | All-pass SCCP |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 0–31 | 3,345 | 0.9854 | 0.8883 | 3,618 | 0.9830 | 0.8880 |
| 32–127 | 3,222 | 0.9676 | 0.8446 | 3,353 | 0.9701 | 0.8518 |
| 128–511 | 2,625 | 0.9569 | 0.7999 | 2,414 | 0.9610 | 0.8174 |
| 512–2,047 | 788 | 0.9517 | 0.7771 | 651 | 0.9587 | 0.7945 |
| 2,048–8,191 | 136 | 0.9506 | 0.7632 | 82 | 0.9576 | 0.7787 |
| 8,192+ | 8 | 0.9494 | 0.7504 | 6 | 0.9583 | 0.7671 |
| Total | 10,124 | 0.9579 | 0.7929 | 10,124 | 0.9627 | 0.8129 |

### Complete compilation and dense inputs

The shipping revision includes 26,608 ring-buffer checks that cover every ring position and every leading-phi count at ten block sizes. All 384,684 checks passed at the frozen seed, including the optimizer digest `0x292b130a5600b0e5`. Seeds 1, 133 and 789 passed as well. The production-only build and the final build with the extra tests each ran five paired rounds of three processes against the uninstrumented parent. Percentages give the paired change in user cycles. The results include matching debug objects, stdout and diagnostics in both configurations.

| Corpus | Objects | Production-only default | Production-only all passes | Shipping default | Shipping all passes |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | -0.064% | -0.135% | -0.095% | -0.240% |
| sqlite | 1 | -0.181% | -0.260% | -0.282% | -0.302% |
| musl | 1336 | -0.030% | -0.039% | -0.054% | -0.074% |

The optimizer benchmark also timed large DAGs with eleven samples per executable. The table gives candidate ticks per input instruction divided by parent ticks across the six requested input sizes. The command’s block argument changes the jump-chain shape as well. All emitted graph shapes matched.

| Requested instructions | 1 block, SCCP | 1 block, all | 8 blocks, SCCP | 8 blocks, all |
| ---: | ---: | ---: | ---: | ---: |
| 32 | 0.9757 | 0.9644 | 0.9308 | 0.9484 |
| 128 | 0.9266 | 0.9259 | 0.9230 | 0.9406 |
| 512 | 0.9230 | 0.9065 | 0.9075 | 0.9098 |
| 2048 | 0.9148 | 0.9261 | 0.9202 | 0.9091 |
| 8192 | 0.9201 | 0.9110 | 0.9266 | 0.9007 |
| 16384 | 0.9271 | 0.9191 | 0.9294 | 0.9101 |

Three further alternating pairs used the final shipping executable on the 16,388-instruction single-block DAG. Its median ratios were 0.9330 with SCCP alone and 0.9191 with all passes.

[SCCP source changes, probes, native commands, correctness checks, raw cycles and object hashes](sccp-native.tar.xz)

## CFG target resolution and layout ranks

Five alternating paired rounds ran the complete verified Tier 1 pipeline on a locked Ryzen 7 9700X, using buster14a/buster@cc7d4ffb449c1f57d8d867c2ad2bf6dc6bfebc7f as the parent. Each input ran in one lane. Each cell reports the median of the five ratios of summed TSC ticks for that bin. Cleanup brackets thread-target resolution and layout ordering. Each pair produced identical function shapes, objects, standard output and diagnostics.

| Input instructions | Pass configuration | Functions | Pipeline | Cleanup | Target resolution | Layout |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 0–31 | default | 3,345 | 0.9837 | 0.8158 | 0.5729 | 0.9716 |
| 0–31 | all | 3,618 | 0.9826 | 0.8121 | 0.5667 | 0.9552 |
| 32–127 | default | 3,222 | 0.9883 | 0.8268 | 0.4457 | 0.9751 |
| 32–127 | all | 3,353 | 0.9878 | 0.8330 | 0.4370 | 0.9800 |
| 128–511 | default | 2,625 | 0.9898 | 0.8608 | 0.3922 | 0.9893 |
| 128–511 | all | 2,414 | 0.9903 | 0.8595 | 0.3862 | 0.9893 |
| 512–2,047 | default | 788 | 0.9924 | 0.8844 | 0.3662 | 0.9960 |
| 512–2,047 | all | 651 | 0.9920 | 0.8829 | 0.3616 | 0.9955 |
| 2,048–8,191 | default | 136 | 0.9942 | 0.8933 | 0.3201 | 0.9987 |
| 2,048–8,191 | all | 82 | 0.9939 | 0.8870 | 0.3162 | 0.9955 |
| 8,192+ | default | 8 | 0.9978 | 0.8831 | 0.2784 | 0.9971 |
| 8,192+ | all | 6 | 0.9926 | 0.8849 | 0.2793 | 1.0026 |
| Total | default | 10,124 | 0.9912 | 0.8617 | 0.4182 | 0.9889 |
| Total | all | 10,124 | 0.9907 | 0.8579 | 0.4181 | 0.9865 |

### End-to-end compilation

The ordinary executables ran five paired rounds of three processes per side. Values are the paired changes in median user cycles. All objects with debug information and both output streams matched in every configuration.

| Workload | Objects | Default | All passes |
| --- | ---: | ---: | ---: |
| lua | 34 | +0.060% | -0.023% |
| sqlite | 1 | +0.037% | +0.114% |
| musl | 1336 | -0.015% | +0.047% |

### Independent target checks and captured inputs

The probe captured 20,248 successor graphs in each pass configuration. Three randomized orders replayed the original and all four candidates against every target. The gathered component walk won all 61 populated block-count bins and workload totals over the two configurations.

| Configuration | Workload | Graphs | Block references | Target cycles / parent |
| --- | --- | ---: | ---: | ---: |
| default | lua | 3,448 | 64,980 | 0.3005 |
| default | sqlite | 9,036 | 308,626 | 0.2989 |
| default | musl | 7,764 | 82,204 | 0.2747 |
| all | lua | 3,448 | 65,998 | 0.3050 |
| all | sqlite | 9,036 | 309,720 | 0.3132 |
| all | musl | 7,764 | 83,052 | 0.2837 |

The independent functional-graph oracle constructs nine shapes at 88 widths from zero to 8,192, including long cycles and chains feeding cycles. Under each of three seeds the five implementations passed 3,960 graph checks, 11,880 overlapping-output checks, 3,915 invalid-input checks and 425 exhausted-arena rollbacks. The guarded input ends immediately before an unreadable page. The gathered component walk beat the parent in 244 of 792 guarded shape/width timings. The compiler's synthetic IR benchmark won 98 of 120 measured shape/configuration rows. Full ratios are available in the archive. The optimizer passed the frozen seed with 358,076 checks and seeds 1, 133 and 789 with zero failures.

[Source changes, instrumentation, commands, captured graphs, synthetic inputs, timings and checksums](cfg-native.tar.xz)

## Resolving components inside a vector register

A packet contains sixteen block IDs. When every successor stays inside its own packet, four pointer doublings determine which cycle each lane reaches. The minimum ID on that cycle is its canonical representative. The pass validates all successors before writing output, processes overlapping packets in memmove order, and keeps the linear component walk for cross-packet graphs. Three other implementations also compress internal paths in mixed packets. They carry the minimum interior ID through each compressed edge so a cycle crossing packets keeps its original representative.

Each run used a locked 9700X. Independent guard-page oracles covered nine graph shapes at 88 widths from zero through 8,192. At each of three seeds the four implementations and the parent passed 3,960 target checks, 11,880 shifted/aliased outputs and 3,915 invalid-input rollbacks. In 369 exhausted-arena cases the call failed and restored the arena and output. Self-contained inputs could complete without an allocation. Captured default and all-pass graphs also matched the parent target at every block.

| Implementation | Guarded timings at or below parent | Captured bins and totals at or below parent | Median captured ratio |
| --- | ---: | ---: | ---: |
| Packet-contained graphs | 391/792 | 61/61 | 0.219 |
| Compress within packets, walk components | 449/792 | 61/61 | 0.309 |
| Compress within packets, use stack | 445/792 | 61/61 | 0.310 |
| Compress within packets, select walk by component | 450/792 | 61/61 | 0.300 |

The first implementation also ran through the complete compiler. Each row below contains the five-round paired median, summing ticks over all functions in each instruction-count bin. Timings use the same stage boundaries as the earlier CFG comparison.

| Instructions | Configuration | Functions | Verified pipeline | Cleanup | Targets | Layout |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 0–31 | default | 3,345 | 0.9932 | 0.8105 | 0.5445 | 0.9751 |
| 0–31 | all | 3,618 | 1.0023 | 0.9114 | 0.5581 | 1.1163 |
| 32–127 | default | 3,222 | 0.9890 | 0.8154 | 0.3756 | 0.9850 |
| 32–127 | all | 3,353 | 0.9975 | 0.8847 | 0.3898 | 1.0704 |
| 128–511 | default | 2,625 | 0.9910 | 0.8543 | 0.3599 | 0.9906 |
| 128–511 | all | 2,414 | 0.9959 | 0.8857 | 0.3890 | 1.0226 |
| 512–2,047 | default | 788 | 0.9937 | 0.8918 | 0.3684 | 1.0016 |
| 512–2,047 | all | 651 | 0.9957 | 0.8958 | 0.3879 | 1.0050 |
| 2,048–8,191 | default | 136 | 0.9957 | 0.8938 | 0.3351 | 0.9970 |
| 2,048–8,191 | all | 82 | 0.9958 | 0.8924 | 0.3423 | 0.9983 |
| 8,192+ | default | 8 | 0.9976 | 0.8871 | 0.2844 | 0.9980 |
| 8,192+ | all | 6 | 0.9949 | 0.8880 | 0.2836 | 1.0005 |
| Total | default | 10,124 | 0.9926 | 0.8588 | 0.3912 | 0.9922 |
| Total | all | 10,124 | 0.9963 | 0.8926 | 0.4119 | 1.0337 |

| Complete compiler | Debug objects | Default | All passes |
| --- | ---: | ---: | ---: |
| lua | 34 | -0.208% | -0.021% |
| sqlite | 1 | -0.068% | +0.082% |
| musl | 1,336 | -0.119% | -0.025% |

All six output manifests matched. Five of six ordinary compilation cells improved. All-pass SQLite used +0.082% more user cycles. The frozen optimizer seed passed 358,076 checks with zero failures, and three further seeds passed. The verified optimizer's synthetic benchmarks improved in 114 of 120 shape and size cells. The remaining misses keep the replacement under qualification.

[Source, commands, guarded oracles, per-stage samples, debug object hashes and ordinary compilation timings](cfg-packet-components.tar.xz)

## Kept blocks and competing layout edges

The builder compresses reachable canonical blocks into their original order. It gathers dominator ranks for up to sixteen candidates and installs each winning outgoing edge immediately. An equal rank keeps the earlier source. Cycle detection visits kept blocks in order. Five alternating paired rounds used the same per-function instrumentation on the 9700X. Across 10,124 functions per configuration, each output object, diagnostic stream and sequence of function shapes matched the parent. Each ratio below divides the summed candidate ticks in that bin by the corresponding parent ticks, then takes the median of the pairs.

| Instructions | Passes | Functions | Verified pipeline | CFG cleanup | Target resolution | Layout |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 0–31 | default | 3,345 | 0.9888 | 0.7773 | 0.5829 | 0.8997 |
| 0–31 | all | 3,618 | 1.0172 | 0.7579 | 0.5796 | 0.8636 |
| 32–127 | default | 3,222 | 0.9792 | 0.6655 | 0.4227 | 0.7598 |
| 32–127 | all | 3,353 | 0.9961 | 0.6657 | 0.4159 | 0.7597 |
| 128–511 | default | 2,625 | 0.9789 | 0.6636 | 0.3857 | 0.7422 |
| 128–511 | all | 2,414 | 0.9840 | 0.6648 | 0.3861 | 0.7411 |
| 512–2,047 | default | 788 | 0.9806 | 0.6630 | 0.3826 | 0.7226 |
| 512–2,047 | all | 651 | 0.9812 | 0.6594 | 0.3783 | 0.7200 |
| 2,048–8,191 | default | 136 | 0.9823 | 0.6521 | 0.3434 | 0.7090 |
| 2,048–8,191 | all | 82 | 0.9830 | 0.6513 | 0.3385 | 0.7119 |
| 8,192+ | default | 8 | 0.9842 | 0.6370 | 0.2966 | 0.7018 |
| 8,192+ | all | 6 | 0.9856 | 0.6378 | 0.2851 | 0.7040 |
| Total | default | 10,124 | 0.9812 | 0.6722 | 0.4190 | 0.7456 |
| Total | all | 10,124 | 0.9879 | 0.6710 | 0.4196 | 0.7452 |

Ordinary compilers without probes ran five rounds of three processes. Debug objects, diagnostics and stdout matched on all six workloads.

| Corpus | Default passes | All passes |
| --- | ---: | ---: |
| lua | +0.041% | -0.053% |
| sqlite | -0.031% | -0.060% |
| musl | +0.032% | +0.027% |

The layout improved in 12 of twelve bins, the verified pipeline in 11 of twelve, and the synthetic optimizer in 70 of 120 comparisons. Seed 139 passed 358,076 frozen checks. Three further seeds passed.

[Patch, harnesses, complete compiler samples, per-function ticks and object manifests](cfg-layout-proposals.tar.xz)
