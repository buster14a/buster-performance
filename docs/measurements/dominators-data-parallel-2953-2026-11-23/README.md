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
