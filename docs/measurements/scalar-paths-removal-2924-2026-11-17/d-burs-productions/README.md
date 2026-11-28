# Tier 1 instruction selection and maximal munch

The native parent is buster14a/buster@cc7d4ffb449c1f57d8d867c2ad2bf6dc6bfebc7f. A capture at the production pattern selector records the function size, node number, IR operator and type, grammar rule, candidate count, chosen candidate number, fallback flag and every candidate’s machine rule. Each compiler ran in Release on the locked Ryzen 7 9700X with one compilation lane. Within each paired run, both compilers wrote debug objects from the same working directory. The comparison checks every node in order, including its full candidate-rule list and the exact selected index.


## Classifying supported single-pattern leaves

A zero-child goal selects the single concrete machine pattern. It covers unconditional branches, lifetime markers, symbol addresses, stack saves, fences, unreachable blocks and the directly supported parameter, phi and return cases. The ABI, machine operands and cost still come from the original candidate generator. The original precedence of unsupported-node errors is preserved.

| Passes | Corpus | Selected nodes | Parent maximal munch | Candidate maximal munch | Reduction |
| --- | --- | ---: | ---: | ---: | ---: |
| default | lua | 77,839 | 30,699 | 12,357 | 59.7% |
| default | sqlite | 323,431 | 115,581 | 42,228 | 63.5% |
| default | musl | 114,754 | 55,897 | 27,230 | 51.3% |
| all | lua | 76,245 | 30,433 | 12,161 | 60.0% |
| all | sqlite | 306,076 | 110,195 | 38,836 | 64.8% |
| all | musl | 107,878 | 53,511 | 25,523 | 52.3% |

The selected index and all available machine rules matched at all 1,006,223 nodes. The six runs also matched every object, standard output and diagnostic byte. The newly covered operations, summed across both configurations, were IR_BR (103,130), IR_PHI (46,725), IR_PARAM (28,782), IR_SYMBOL_ADDR (25,372), IR_RET (23,732), IR_LIFETIME (9,876), IR_BR_INDIRECT (328), IR_FENCE (22), IR_STACK_SAVE (14). The selector passed 1,530,046 checks and reproduced the frozen digest d15b788da26467e5 for 5,957 plans. Three pipeline seeds ran with the Clang cross-check. In a separate 19-node verified fixture, changing the baked grammar action, state, goal or missing production was detected even when the independent fallback could emit equivalent code.

[Complete captures, candidate and probe patches, native tests, fixture mutations and object manifests](supported-records.tar.xz)

## Complete source selection with single-pattern leaves

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9875 | 0.9875 | 0.9958 |
| sqlite | 2,666 | 448,699 | 0.9815 | 0.9817 | 0.9985 |
| musl | 2,756 | 235,335 | 0.9848 | 0.9849 | 0.9960 |

[Inputs, native commands and all paired samples](supported-source-selection.tar.xz)

## Complete source selection including ABI-specific calls

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9870 | 0.9912 | 0.9946 |
| sqlite | 2,666 | 448,699 | 0.9862 | 0.9858 | 0.9985 |
| musl | 2,756 | 235,335 | 0.9840 | 0.9846 | 0.9960 |

[Inputs, native commands and all paired samples](calls-source-selection.tar.xz)

## ABI-specific call productions

Three additional grammar leaves represent ordinary calls, inline assembly bodies and machine-row calls. The same ABI checks select their concrete kind for both the classifier and the independent candidate walk. The chosen grammar rule supplies that kind to the pattern builder.

| Passes | Corpus | Selected nodes | Parent maximal munch | Candidate maximal munch | Reduction |
| --- | --- | ---: | ---: | ---: | ---: |
| default | lua | 77,839 | 30,699 | 4,957 | 83.9% |
| default | sqlite | 323,431 | 115,581 | 25,461 | 78.0% |
| default | musl | 114,754 | 55,897 | 20,203 | 63.9% |
| all | lua | 76,245 | 30,433 | 4,740 | 84.4% |
| all | sqlite | 306,076 | 110,195 | 21,830 | 80.2% |
| all | musl | 107,878 | 53,511 | 18,488 | 65.5% |

The selected index and all available machine rules matched at all 1,006,223 nodes. The six runs also matched every object, standard output and diagnostic byte. The newly covered operations, summed across both configurations, were IR_BR (103,130), IR_CALL (56,858), IR_PHI (46,725), IR_PARAM (28,782), IR_SYMBOL_ADDR (25,372), IR_RET (23,732), IR_LIFETIME (9,876), IR_CALL_INDIRECT (5,798), IR_BR_INDIRECT (328), IR_FENCE (22), IR_STACK_SAVE (14). The selector passed 1,530,046 checks and reproduced the frozen digest d15b788da26467e5 for 5,957 plans. Three pipeline seeds ran with the Clang cross-check. In a separate 19-node verified fixture, changing the baked grammar action, state, goal or missing production was detected even when the independent fallback could emit equivalent code. A second verified function exercised 16 ordinary calls. Mutating the call rule’s kind was detected at all 16 calls even though every node still selected a grammar production. The call fixture also detected changes to its action, state, goal and missing production.

[Complete captures, candidate and probe patches, native tests, fixture mutations and object manifests](calls-records.tar.xz)

## End-to-end compilation with single-pattern leaves

Each cell compares five paired rounds of three ordinary compiler processes on the locked 9700X. The table gives the median change in user cycles for a single-lane Tier 1 debug build relative to the parent. All 2,742 objects, standard output and diagnostics matched.

| Corpus | Default passes | All passes |
| --- | ---: | ---: |
| lua | +0.240% | +0.144% |
| sqlite | +0.248% | +0.206% |
| musl | +0.091% | +0.128% |

[Native compiler runs, input commands and object manifests](compile-supported.tar.xz)

## Complete source selection including conversions

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9958 | 0.9931 | 0.9958 |
| sqlite | 2,666 | 448,699 | 0.9921 | 0.9921 | 0.9994 |
| musl | 2,756 | 235,335 | 0.9948 | 0.9948 | 0.9968 |

[Inputs, native commands and all paired samples](converts-source-selection.tar.xz)

## End-to-end compilation with ABI-specific call rules

Each cell compares five paired rounds of three ordinary compiler processes on the locked 9700X. The table gives the median change in user cycles for a single-lane Tier 1 debug build relative to the parent. All 2,742 objects, standard output and diagnostics matched.

| Corpus | Default passes | All passes |
| --- | ---: | ---: |
| lua | +0.130% | +0.025% |
| sqlite | +0.233% | +0.094% |
| musl | +0.056% | +0.107% |

[Native compiler runs, input commands and object manifests](compile-calls.tar.xz)

## Copy, negation and conversion productions

A supported copy, integer negation or complement has one concrete machine pattern. Truncation is admitted when its producer cannot supply a second narrow-arithmetic pattern. Sign extension is admitted for terminal producers that cannot fold a load, truncation or signed arithmetic tree.

| Passes | Corpus | Selected nodes | Parent maximal munch | Candidate maximal munch | Reduction |
| --- | --- | ---: | ---: | ---: | ---: |
| default | lua | 77,839 | 30,699 | 2,681 | 91.3% |
| default | sqlite | 323,431 | 115,581 | 12,310 | 89.3% |
| default | musl | 114,754 | 55,897 | 15,670 | 72.0% |
| all | lua | 76,245 | 30,433 | 3,177 | 89.6% |
| all | sqlite | 306,076 | 110,195 | 13,746 | 87.5% |
| all | musl | 107,878 | 53,511 | 15,469 | 71.1% |

The selected index and all available machine rules matched at all 1,006,223 nodes. The six runs also matched every object, standard output and diagnostic byte. The newly covered operations, summed across both configurations, were IR_BR (103,130), IR_CALL (56,858), IR_PHI (46,725), IR_PARAM (28,782), IR_SYMBOL_ADDR (25,372), IR_RET (23,732), IR_TRUNC (12,350), IR_SEXT (12,070), IR_LIFETIME (9,876), IR_COPY (7,096), IR_CALL_INDIRECT (5,798), IR_NEG (789), IR_BR_INDIRECT (328), IR_NOT (321), IR_FENCE (22), IR_STACK_SAVE (14). The selector passed 1,530,046 checks and reproduced the frozen digest d15b788da26467e5 for 5,957 plans. Three pipeline seeds ran with the Clang cross-check. In a separate 19-node verified fixture, changing the baked grammar action, state, goal or missing production was detected even when the independent fallback could emit equivalent code. A separate 19-node function exercises truncation, sign extension, copies, negation and complement. It detected all four mutations at all 19 nodes.

[Complete captures, candidate and probe patches, native tests, fixture mutations and object manifests](converts-records.tar.xz)

## Synthetic instruction widths with single-pattern leaves

The production benchmark generated each shape at fifteen step counts on the locked Ryzen 7 9700X. The table gives the median of three paired changes in TSC ticks per IR instruction. Instruction counts, output records and bytes, spill and reload counts and both reported memory peaks matched in every pair. The candidate met the parent in 26 of 45 selection cells and 25 of 45 complete cells.

| Requested steps | chain selection | chain complete | pressure selection | pressure complete | wide selection | wide complete |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | -5.274% | -0.591% | -3.183% | +0.912% | -5.009% | -0.822% |
| 2 | -4.953% | +0.173% | -2.146% | +1.169% | -5.667% | -1.297% |
| 7 | +0.114% | -0.401% | -0.331% | +0.949% | -3.911% | -1.804% |
| 15 | +0.704% | +2.411% | +0.914% | +1.364% | +1.036% | +1.835% |
| 16 | +0.022% | -0.293% | -0.084% | -1.085% | -1.787% | -1.814% |
| 17 | +1.108% | +1.142% | +0.702% | +0.635% | -1.423% | -1.710% |
| 31 | -0.065% | -0.305% | +0.844% | +0.195% | +0.081% | -0.057% |
| 32 | +0.267% | +0.361% | +0.224% | +1.037% | -0.350% | -2.744% |
| 63 | -1.616% | -1.422% | -0.218% | -2.416% | +4.027% | -1.966% |
| 64 | -1.213% | -1.382% | -0.457% | +0.380% | +4.164% | -1.685% |
| 127 | -0.480% | -0.026% | -0.041% | -0.304% | +6.177% | +1.270% |
| 256 | -0.129% | -0.634% | -0.300% | +0.285% | +7.082% | +0.126% |
| 1024 | -0.671% | -1.253% | +0.222% | +0.459% | +6.043% | +1.485% |
| 2048 | -2.624% | -0.149% | -0.831% | -0.089% | +2.721% | +0.779% |
| 8192 | -1.128% | -0.115% | -0.671% | +0.129% | +0.663% | -0.529% |

[Native paired measurements and commands](supported-widths.tar.xz)

## End-to-end compilation with conversion rules

Each cell compares five paired rounds of three ordinary compiler processes on the locked 9700X. The table gives the median change in user cycles for a single-lane Tier 1 debug build relative to the parent. All 2,742 objects, standard output and diagnostics matched.

| Corpus | Default passes | All passes |
| --- | ---: | ---: |
| lua | +0.140% | -0.029% |
| sqlite | +0.153% | -0.010% |
| musl | +0.008% | +0.012% |

[Native compiler runs, input commands and object manifests](compile-converts.tar.xz)

## Synthetic instruction widths with ABI-specific calls

The production benchmark generated each shape at fifteen step counts on the locked Ryzen 7 9700X. The table gives the median of three paired changes in TSC ticks per IR instruction. Instruction counts, output records and bytes, spill and reload counts and both reported memory peaks matched in every pair. The candidate met the parent in 23 of 45 selection cells and 15 of 45 complete cells.

| Requested steps | chain selection | chain complete | pressure selection | pressure complete | wide selection | wide complete |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | -3.692% | +3.174% | +0.180% | +2.002% | -0.646% | +1.981% |
| 2 | +2.258% | +3.078% | +2.747% | +2.431% | -2.204% | +1.946% |
| 7 | +3.513% | +1.989% | +4.008% | +2.059% | -0.998% | -0.241% |
| 15 | +1.819% | +2.284% | +2.561% | +1.084% | -0.256% | +1.414% |
| 16 | +1.739% | +2.268% | +1.404% | +0.340% | +2.057% | +2.855% |
| 17 | +2.188% | +1.617% | +2.662% | +0.917% | -1.582% | +0.118% |
| 31 | -0.148% | +0.728% | +2.034% | +1.371% | -4.581% | +0.425% |
| 32 | -0.043% | +0.306% | +2.002% | +0.464% | -2.915% | +0.053% |
| 63 | -1.427% | -0.584% | +2.038% | -0.310% | -0.995% | +1.819% |
| 64 | -1.337% | -1.561% | +1.681% | -1.557% | +1.048% | +0.224% |
| 127 | -1.450% | -0.093% | +1.403% | +0.630% | +0.623% | +1.655% |
| 256 | -2.908% | -1.389% | +1.539% | -0.828% | -0.679% | +1.352% |
| 1024 | -1.475% | -0.971% | +1.565% | -0.694% | -0.924% | +1.356% |
| 2048 | -0.816% | -0.878% | +0.339% | -0.820% | -1.856% | +0.721% |
| 8192 | -0.547% | -1.100% | -0.176% | -0.402% | -0.052% | -0.306% |

[Native paired measurements and commands](calls-widths.tar.xz)

## Source selection with floating-point productions and deferred visits

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9924 | 0.9925 | 0.9971 |
| sqlite | 2,666 | 448,699 | 0.9921 | 0.9922 | 1.0007 |
| musl | 2,756 | 235,335 | 0.9922 | 0.9921 | 0.9948 |

[Inputs, native commands and all paired samples](float-source-selection.tar.xz)

## Source selection with initialization limited to populated candidate slots

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9965 | 0.9966 | 0.9961 |
| sqlite | 2,666 | 448,699 | 0.9981 | 0.9985 | 0.9996 |
| musl | 2,756 | 235,335 | 0.9961 | 0.9962 | 0.9969 |

[Inputs, native commands and all paired samples](candidateinit-source-selection.tar.xz)

## Source selection with early control-flow classification

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9874 | 0.9873 | 0.9766 |
| sqlite | 2,666 | 448,699 | 0.9896 | 0.9895 | 0.9859 |
| musl | 2,756 | 235,335 | 0.9848 | 0.9847 | 0.9835 |

[Inputs, native commands and all paired samples](earlyjump-source-selection.tar.xz)
