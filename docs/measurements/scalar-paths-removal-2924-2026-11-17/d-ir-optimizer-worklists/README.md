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
