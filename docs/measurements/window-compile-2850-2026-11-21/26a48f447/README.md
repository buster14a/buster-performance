# Release each body's machine records after encoding

The single-lane Tier 0 path retains typed lowering windows and consumes each body's x86 instruction records before starting the next body. It resolves the instruction-end-relative relocation distance to a byte offset and adjusted addend at that point. Symbol targets stay available for later unit-wide remapping. A straight-line body can also take its instruction offsets from the encoder, which avoids a separate instruction sizing pass. The general field checker still handles assembler layouts with data and immediate references to the same instruction. Both builds emit complete native objects during every observation.

A separate local Develop build on the two large inputs recorded each completed window with GDB. On SQLite all 2,668 bodies used the new field handoff, covering 15,795 fields. These bodies released 252,720 bytes of marked machine instructions and 233,932 bytes of encoder-end capacity that the baseline retained until linking. Its 596 straight-line bodies avoided sizing 10,107 records. On compiler main, 1,489 bodies used the handoff, covering 19,062 fields, 304,992 bytes of marked records, and 171,544 bytes of encoder-end capacity. Its 358 straight-line bodies avoided sizing 17,027 records. Counts refer to allocated column contents and exclude arena padding. Timing observations below are from separate uninstrumented native Release builds.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `26a48f447dd1a9d03b7fde6ecd7476fb7de87505`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −1.6744 [−3.8188, +1.8838] | -420,674.5 | +0.0370 [−0.6170, +0.3265] | 1/3 |
| [Lua](lua/paired-summary.tsv) | −0.1466 [−3.5203, +0.8093] | -209,547.5 | +0.2510 [−1.1485, +0.2765] | 1/3 |
| [musl](musl/paired-summary.tsv) | −0.0335 [−0.0953, +1.7205] | -703,563.5 | −2.2280 [−3.9195, +2.4520] | 2/3 |
| [Buster](main/paired-summary.tsv) | +2.4338 [−8.0748, +6.9294] | -308,931.0 | −0.0935 [−4.4815, +1.3575] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [local qualification](qualification/README.md) retains the complete object, diagnostic and runtime comparisons and the body/field counts. SQLite median wall time was 113.483 ms on the baseline and 113.520 ms on the candidate. Each workload's paired wall differences span zero.
