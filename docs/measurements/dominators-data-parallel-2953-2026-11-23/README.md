# Dominator tree and natural-loop construction on Zen 5

## Natural-loop measurements for PR 3455

The original November 23 runs compare revisions `6c67b3b85` (`full4`) and `86e84d6c3` (`full5`) with the same parent, `968a085fe`. Each directory contains three paired SQLite CFG runs and three paired synthetic runs on CPU 2 of the locked Ryzen 7 9700X. The SQLite correctness run checked 7,806 control-flow graphs from 2,602 functions and passed 33,748,419 checks. Both builds, both correctness fixtures and every benchmark process exited successfully. The archive preserves the original author's runner, exact revisions, executable hashes, status records and raw logs.

[Native measurement archive](natural-loop-handoff.tar.xz) · [Original issue handoff](https://github.com/buster14a/buster/issues/2953) · [Natural-loop implementation](https://github.com/buster14a/buster/pull/3455)

## Natural-loop back edges and irreducible components

Every reachable DFS-ancestor edge identifies either a natural-loop header or a source whose SCC needs the conservative irreducibility flag. The first implementation classifies both during one scan and uses the natural-loop body bit to recognize previously absorbed members. The second implementation records witnesses during classification and runs the reverse SCC walk only when a witness exists. The last build includes the source and documentation changes submitted for review.

The Release compilers ran on CPU 2 of the locked Ryzen 7 9700X. Measurements compare each candidate with cc7d4ffb4 in three alternating paired rounds. Every percentage is the median paired change in cycles per block. The current reader accepts the two current IR forms. Removing the third, scalar-promoted form from the historical SQLite export yields 5,204 records from 2,602 functions. For every function its old third graph was byte-identical to its second after the form number. The original SHA-256 is `dde6529090a5641b935330fc8f5632a19651c1999194531dd2d30052740e0d98`, and the two-form fixture is `dfcfc5ff70eb860723668df8214eb7186fa04b0217f550e4d54b6f2ac9e02204`.

| SQLite set | One scan, loops | One scan, full | Witnesses, loops | Witnesses, full | Shipping loops | Shipping full |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| blocks[2,4) | -0.82% | +1.63% | -4.27% | -3.86% | -4.94% | -4.01% |
| blocks[4,8) | +1.74% | +3.47% | -6.68% | -5.17% | -7.77% | -7.58% |
| blocks[8,16) | -9.81% | -7.29% | -15.32% | -15.16% | -18.22% | -17.69% |
| blocks[16,32) | -7.53% | -6.39% | -14.94% | -12.96% | -18.06% | -15.57% |
| blocks[32,64) | -8.27% | -6.99% | -18.07% | -14.95% | -19.26% | -17.30% |
| blocks[64,128) | -7.50% | -6.34% | -21.04% | -18.23% | -22.31% | -20.16% |
| blocks[128,256) | -8.22% | -10.62% | -26.97% | -26.63% | -27.77% | -27.92% |
| blocks[256,512) | -5.10% | -8.39% | -16.25% | -22.16% | -17.61% | -22.46% |
| blocks[512,1024) | -3.36% | -2.46% | -13.57% | -11.47% | -14.00% | -11.90% |
| blocks[1024,2048) | -3.83% | -2.41% | -4.64% | -3.55% | -4.85% | -4.35% |
| largest-1 | -3.80% | -2.65% | -4.36% | -3.62% | -5.11% | -4.40% |
| largest-2 | -4.23% | -3.90% | -4.78% | -3.66% | -5.60% | -4.47% |
| largest-3 | -4.66% | -3.47% | -13.40% | -11.00% | -14.52% | -11.56% |
| largest-4 | -3.73% | -2.87% | -13.14% | -10.90% | -13.40% | -11.70% |
| largest-5 | -2.78% | -2.38% | -13.76% | -10.77% | -14.94% | -12.07% |
| largest-6 | -2.93% | -2.78% | -13.08% | -10.83% | -14.04% | -11.37% |
| largest-7 | -5.32% | -4.36% | -14.70% | -12.89% | -14.30% | -12.99% |
| largest-8 | -5.48% | -5.36% | -13.72% | -12.53% | -14.53% | -12.67% |
| all | -4.77% | -3.92% | -12.97% | -11.83% | -14.10% | -13.33% |

| Synthetic shape | One scan, loops | One scan, full | Witnesses, loops | Witnesses, full | Shipping loops | Shipping full |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| diamonds | -7.90% | -8.10% | -9.17% | -5.33% | -9.77% | -8.52% |
| nested | -9.99% | -1.96% | -18.59% | -3.95% | -19.33% | -3.92% |
| irreducible | -7.00% | -5.49% | -4.40% | -6.13% | -7.08% | -2.88% |
| dispatch | -27.06% | -21.45% | -31.22% | -23.96% | -31.89% | -25.26% |
| ladder | -5.08% | +1.61% | -9.82% | -1.54% | -14.64% | -1.99% |
| nested-ifs | -7.10% | -5.20% | -12.14% | -9.28% | -13.93% | -9.62% |
| fan-in | -6.54% | -4.34% | -7.84% | -5.42% | -11.58% | -7.44% |

The historical random dispatch graph has 2,049 blocks and 8,195 edges. Its loop analysis originally cost 255.658 cycles per block on the pre-3455 revision and 297.801 on the full5 revision. The new paired shipping comparison measured 308.060 on its own parent and 209.812 on the candidate.

Each compiler passed the 46,597,165-check default dominance suite and three additional seeds. The actual IR producer passed 22,641,582 checks over all 5,204 SQLite forms, plus the repository’s source fixture. The independent oracle rejected mutations that dropped natural-loop headers or omitted the conservative component flags.

The uninstrumented full Tier 1 compilation used five paired rounds of three processes per executable in every round. Both pass configurations matched all 1,371 debug objects, stdout and diagnostics. The percentages below measure user cycles.

| Corpus | One scan, default | One scan, all passes | Witnesses, default | Witnesses, all passes | Shipping default | Shipping all passes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | +0.045% | +0.017% | +0.008% | -0.144% | +0.239% | +0.080% |
| sqlite | +0.110% | +0.020% | -0.138% | -0.167% | +0.003% | -0.085% |
| musl | +0.037% | -0.019% | -0.011% | -0.017% | +0.141% | +0.282% |

[Source patches, fixture conversion, full compiler commands, mutation controls, correctness logs and raw measurements](natural-loop-edges.tar.xz)

## Combined tree and natural-loop experiments

The combined executable uses the natural-loop change from PR #3692 and a modified SEMI-NCA tree. DFS installs parents for single-predecessor blocks and collects joins. The solver initializes eight paired parent labels per vector store and resolves only the collected joins. Tree construction uses the existing CSR offsets to fill its children. This experimental tree retains the depth-dependent final climb.

All native samples ran under the exclusive lock on CPU 2 of the 9700X. Each cell shows the median of three paired candidate/baseline cycle ratios. The first three columns compare with cc7d4ffb4 on 5,204 SQLite forms. The final two columns compare against the archived pre-#3455 scalar-loop compiler, SHA-256 `6e60ddafad95813175997cd42db5e2ef686f00d952d4619ab1b97b18b93d14af`, on all 7,806 original forms. For that comparison only, the candidate benchmark reader accepts the archived third form. The ordinary executable was also measured against the historical compiler on the synthetic suite.

| SQLite row | Current tree | Current loops | Current all | Historical tree | Historical all |
| --- | ---: | ---: | ---: | ---: | ---: |
| blocks[2,4) | -1.33% | -8.32% | -8.33% | -5.11% | -9.09% |
| blocks[4,8) | -1.38% | -9.08% | -8.36% | -9.23% | -11.08% |
| blocks[8,16) | -6.94% | -24.40% | -24.53% | -13.14% | -20.76% |
| blocks[16,32) | -11.41% | -25.97% | -22.82% | -11.70% | -19.31% |
| blocks[32,64) | -14.32% | -28.45% | -24.54% | -14.58% | -20.01% |
| blocks[64,128) | -18.52% | -30.68% | -26.84% | -16.23% | -21.64% |
| blocks[128,256) | -7.07% | -32.57% | -36.46% | -11.91% | -30.45% |
| blocks[256,512) | -7.65% | -22.19% | -27.95% | -11.61% | -34.29% |
| blocks[512,1024) | -7.40% | -18.12% | -15.58% | -9.67% | -23.41% |
| blocks[1024,2048) | -7.86% | -9.74% | -7.41% | -10.17% | -11.24% |
| largest-1 | -7.17% | -9.19% | -7.11% | -8.96% | -10.71% |
| largest-2 | -8.23% | -10.71% | -8.28% | -10.83% | -11.30% |
| largest-3 | -5.12% | -17.87% | -15.39% | -10.34% | -11.14% |
| largest-4 | -8.41% | -18.35% | -15.82% | -8.55% | -23.92% |
| largest-5 | -6.48% | -17.46% | -14.72% | -9.46% | -25.84% |
| largest-6 | -6.82% | -17.49% | -14.89% | -9.38% | -25.40% |
| largest-7 | -6.61% | -18.50% | -17.00% | -9.41% | -19.64% |
| largest-8 | -7.38% | -19.11% | -17.27% | -9.64% | -20.97% |
| all | -9.06% | -20.86% | -19.17% | -10.39% | -18.88% |

| Synthetic shape and output | Against current compiler | Against historical compiler |
| --- | ---: | ---: |
| diamonds tree | -11.47% | -10.35% |
| diamonds loops | -19.94% | -19.06% |
| diamonds all | -17.92% | -16.24% |
| nested tree | -13.79% | -12.85% |
| nested loops | -25.43% | -94.79% |
| nested all | -5.24% | -75.70% |
| irreducible tree | -5.38% | -4.56% |
| irreducible loops | -14.66% | -50.77% |
| irreducible all | -6.18% | -44.78% |
| dispatch tree | -0.58% | -0.21% |
| dispatch loops | -32.16% | -17.83% |
| dispatch all | -26.15% | -16.95% |
| ladder tree | +2.30% | +7.64% |
| ladder loops | -10.54% | -5.01% |
| ladder all | +1.26% | +1.40% |
| nested-ifs tree | +4.14% | +3.70% |
| nested-ifs loops | -9.08% | -7.69% |
| nested-ifs all | -9.89% | -8.72% |
| fan-in tree | -3.55% | -0.96% |
| fan-in loops | -13.90% | -10.19% |
| fan-in all | -13.16% | -10.46% |

The combined executable also passed the frozen suite with four seeds and the source producer with 22,641,582 comparisons over 5,204 SQLite forms. All 1,371 debug objects, diagnostic streams and standard output matched per configuration. Complete compile results are the median paired change in user cycles over five rounds of three processes.

| Corpus | Default Tier 1 | All passes |
| --- | ---: | ---: |
| lua | -0.062% | -0.252% |
| sqlite | -0.221% | -0.395% |
| musl | -0.052% | -0.129% |

### Deep DFS children dominated from above

For each h the fixture has a chain numbered 0 through h. Block h and block 1 each have edges to the same h leaves. DFS descends the chain first. Every chain node has its preceding node as immediate dominator, and every leaf has block 1. The driver verifies every answer after every timing batch, outside the timed interval. The table reports timestamp-counter ticks per block for complete tree analysis, using seven warm samples per process and three measured processes.

The first two implementations climb the previously built dominator tree. The next three compute deferred immediate dominators through Lengauer–Tarjan buckets and compressed minimum labels. The last four resolve semidominator thresholds only for vertices whose semidominator differs from their DFS parent. All seven alternatives passed the 46,597,165-check independent definition suite. The deep fixture distinguishes per-leaf climbing from shared computations. Each alternative still needs its own size and production qualification.

| h | Parent | Modified SEMI-NCA | Buckets | Active buckets | Paired labels | Thresholds | Threshold bitmap | Lower links | Lower jumps |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 8 | 56.95 | 52.57 | 61.45 | 72.02 | 63.10 | 56.65 | 60.22 | 52.28 | 54.29 |
| 16 | 58.38 | 54.65 | 55.94 | 66.51 | 56.80 | 52.95 | 54.73 | 49.41 | 49.90 |
| 32 | 68.04 | 67.52 | 55.88 | 57.48 | 54.18 | 51.69 | 52.23 | 46.09 | 47.90 |
| 64 | 103.06 | 104.32 | 55.40 | 56.88 | 55.52 | 51.04 | 51.44 | 45.85 | 46.03 |
| 128 | 188.59 | 228.23 | 51.99 | 54.98 | 53.09 | 49.42 | 50.27 | 44.13 | 45.72 |
| 256 | 485.47 | 484.98 | 50.48 | 51.97 | 50.23 | 47.71 | 47.55 | 42.64 | 44.59 |
| 512 | 923.24 | 922.11 | 49.73 | 50.84 | 49.67 | 46.47 | 46.47 | 42.05 | 43.41 |
| 1024 | 1799.32 | 1799.22 | 52.16 | 52.44 | 51.15 | 46.86 | 48.59 | 42.39 | 43.40 |
| 2048 | 3549.12 | 3550.87 | 50.97 | 51.82 | 51.06 | 46.91 | 47.88 | 41.93 | 43.08 |
| 4096 | 7051.19 | 7053.45 | 51.48 | 52.03 | 51.76 | 47.07 | 48.03 | 42.26 | 44.72 |
| 8192 | 14066.32 | 14071.73 | 59.04 | 59.96 | 59.60 | 50.73 | 52.55 | 45.93 | 49.43 |
| 16384 | 28122.41 | 28109.85 | 64.18 | 61.49 | 63.69 | 56.12 | 56.01 | 48.55 | 51.84 |

[Compiler changes, historical reader adapter, independent deep-graph checks, build commands and paired raw results](combined-and-deep-joins.tar.xz)

## Sparse back-edge sources

DFS now marks a source when an outgoing edge reaches a discovered vertex that has not finished. The mask takes one bit per block and is allocated only for loop output. A candidate target is an ancestor when its preorder and reverse postorder are both at most the source’s. The analysis scans the outgoing edges of marked sources to identify natural headers and irreducibility witnesses. A reverse component walk runs only if a witness was found.

All rows below are median ratios from three alternating pairs on the locked 9700X against the same uninstrumented parent. Each pair processed 5,204 current-form SQLite graphs. The four standalone prototypes mark source blocks, target blocks, target counts, or use reverse postorder directly. Their raw runs are included for comparison.

| SQLite set | Loops | All outputs |
| --- | ---: | ---: |
| blocks[2,4) | -3.55% | -5.14% |
| blocks[4,8) | -11.14% | -12.14% |
| blocks[8,16) | -26.57% | -23.68% |
| blocks[16,32) | -27.56% | -22.79% |
| blocks[32,64) | -29.94% | -24.65% |
| blocks[64,128) | -31.69% | -27.61% |
| blocks[128,256) | -31.35% | -35.71% |
| blocks[256,512) | -21.27% | -26.71% |
| blocks[512,1024) | -18.63% | -15.14% |
| blocks[1024,2048) | -10.50% | -8.95% |
| largest-1 | -10.45% | -8.68% |
| largest-2 | -11.26% | -9.02% |
| largest-3 | -18.50% | -14.73% |
| largest-4 | -18.59% | -15.43% |
| largest-5 | -18.69% | -15.70% |
| largest-6 | -18.64% | -15.55% |
| largest-7 | -18.03% | -15.84% |
| largest-8 | -18.25% | -16.29% |
| all | -21.40% | -19.02% |

| Synthetic shape | Tree | Loops | All outputs |
| --- | ---: | ---: | ---: |
| diamonds | +0.25% | -16.39% | -13.75% |
| nested | +2.15% | -20.90% | -4.60% |
| irreducible | -1.07% | -9.00% | -6.60% |
| dispatch | -1.10% | -17.47% | -15.50% |
| ladder | -2.39% | -26.79% | -0.00% |
| nested-ifs | -4.51% | -27.43% | -19.62% |
| fan-in | +2.49% | -21.39% | -17.35% |

Complete Tier 1 debug compilations ran five pairs of three processes per configuration and corpus. All 1,371 objects in each configuration, standard output and diagnostics matched. The shipping executable passed 46,597,151 checks at seed 174 and seeds 1, 133 and 789. Its SQLite producer passed 22,641,582 checks on 5,204 forms and the checked-in IR producer passed 2,637 on 16 forms.

| Workload | Default | All passes |
| --- | ---: | ---: |
| lua | +0.135% | -0.078% |
| sqlite | +0.009% | -0.023% |
| musl | -0.079% | -0.038% |

[Sparse-source changes, four prototypes, native commands, outputs and raw timing](sparse-sources.tar.xz)
