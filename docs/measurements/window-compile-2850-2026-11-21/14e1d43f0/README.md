The compiler marks known syntactic identifier operands during the existing source census. The binder preflights consecutive live ordinary names against scope and semantic barriers and emits the canonical ordered binding rows in one batch.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `40ae34f9d77afc42face58eff3338b7b1d1ba469`. The candidate used `14e1d43f07a38fa8beea37c1520c31f6f989dbba`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −1.2479 [−5.7408, +2.1928] | -11,426,209.0 | −0.0500 [−0.5455, +0.4360] | 4/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler contributed two PMU samples and two elapsed-time samples to each round. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source and local proof](source-use-proof.tar.xz) includes the signed patch, guarded source-run comparisons, 3,096 directed declaration-family and 4,116 frozen source-policy comparisons, the GDB programs, and the actual unmodified reference compiler’s 4,666,856-byte SQLite and 10,281,578-byte Buster binding streams. The candidate matched both streams byte for byte.

Each PMU command and each elapsed-time wrapper acquired a separate 9700X lease. Each elapsed-time wrapper ran one warm-up compiler process and one timed compiler process under that lease. Only the timed child contributes to elapsed time.
