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

## Floating-point load, store and binary productions

The grammar chooses a register or a foldable memory operand for floating add, subtract, multiply and divide. A right load takes priority. Add and multiply can use a left load. A store or load through a walked address retains its corresponding address pattern. The classifier also covers floating negation, undefined values and constants. The baked grammar has 1,029 states, 218 rules and 38,729 entries.

Newly classified nodes are checked in their original dependency order, including any that a later expression absorbs. On a preliminary build, deferring a previously generic floating-point node reordered the production trace. The tables below are from the corrected build. Both executables used identical object output directories so their DWARF compilation-directory fields matched.

| Passes | Corpus | Visited nodes | Parent maximal munch | Conversion version | Floating-point version |
| --- | --- | ---: | ---: | ---: | ---: |
| default | lua | 77,839 | 30,699 | 2,681 | 2,145 |
| default | sqlite | 323,431 | 115,581 | 12,310 | 10,917 |
| default | musl | 114,754 | 55,897 | 15,670 | 7,667 |
| all | lua | 76,245 | 30,433 | 3,177 | 2,696 |
| all | sqlite | 306,076 | 110,195 | 13,746 | 12,415 |
| all | musl | 107,878 | 53,511 | 15,469 | 7,615 |

The floating-point version reduced maximal-munch visits by 89.0% overall, to 43,455. All 1,006,223 full candidate lists and selected indices matched the parent in visit order. All 2,742 debug objects and both output streams were byte-identical. The frozen plans and 1,530,046 selector checks passed, along with emission, liveness, masks and three Clang-backed pipeline seeds.

A 14-node verified function exercises a right-hand load, commuted left-hand load, a load with two uses, and both walked loads and stores. Changing the loaded side, the register rule or either address action caused its independent choice check to fail. The two existing 19-node fixtures also detected their eight changes to the direct and conversion rules. The optimized host fixture driver checked a further 7,362 nodes from 251 verified repository inputs.

[Grammar and probe source, fixed fixtures, mutation results, per-node captures and object checksums](floating-productions.tar.xz)

## Source selection with floating-point productions in dependency order

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9961 | 0.9960 | 1.0015 |
| sqlite | 2,666 | 448,699 | 0.9940 | 0.9940 | 1.0051 |
| musl | 2,756 | 235,335 | 0.9931 | 0.9930 | 1.0011 |

[Inputs, native commands and all paired samples](ordered-source-selection.tar.xz)

## Production selection by function size with single-pattern leaves

Five alternating paired rounds ran single-lane Tier 1 compilation on the locked 9700X. Each measurement brackets verified instruction selection on a production function. For each size band, the table gives the median paired ratio of summed TSC ticks across Lua, SQLite and musl. The function order, instruction and block counts and selection status matched. All 2,742 debug-object checksums and both output streams matched within each paired round.

| Input instructions | Default functions | Default change | All-pass functions | All-pass change |
| --- | ---: | ---: | ---: | ---: |
| 1–31 | 2,515 | -0.152% | 2,658 | -0.581% |
| 32–127 | 1,994 | +0.856% | 2,134 | +0.796% |
| 128–511 | 1,495 | +1.095% | 1,346 | +1.031% |
| 512–2,047 | 436 | +0.344% | 336 | +0.355% |
| 2,048–8,191 | 72 | +0.033% | 38 | +0.036% |
| 8,192+ | 6 | -0.598% | 6 | -0.730% |
| All | 6,518 | +0.420% | 6,518 | +0.516% |

[Native paired measurements and commands](supported-functions.tar.xz)

## Production selection by function size with ABI-specific calls

Five alternating paired rounds ran single-lane Tier 1 compilation on the locked 9700X. Each measurement brackets verified instruction selection on a production function. For each size band, the table gives the median paired ratio of summed TSC ticks across Lua, SQLite and musl. The function order, instruction and block counts and selection status matched. All 2,742 debug-object checksums and both output streams matched within each paired round.

| Input instructions | Default functions | Default change | All-pass functions | All-pass change |
| --- | ---: | ---: | ---: | ---: |
| 1–31 | 2,515 | +1.474% | 2,658 | +1.173% |
| 32–127 | 1,994 | +0.285% | 2,134 | +0.944% |
| 128–511 | 1,495 | +0.256% | 1,346 | +0.597% |
| 512–2,047 | 436 | +0.038% | 336 | +0.177% |
| 2,048–8,191 | 72 | -0.046% | 38 | -0.041% |
| 8,192+ | 6 | -0.080% | 6 | -0.083% |
| All | 6,518 | +0.362% | 6,518 | +0.387% |

[Native paired measurements and commands](calls-functions.tar.xz)

## Production selection by function size with conversions

Five alternating paired rounds ran single-lane Tier 1 compilation on the locked 9700X. Each measurement brackets verified instruction selection on a production function. For each size band, the table gives the median paired ratio of summed TSC ticks across Lua, SQLite and musl. The function order, instruction and block counts and selection status matched. All 2,742 debug-object checksums and both output streams matched within each paired round.

| Input instructions | Default functions | Default change | All-pass functions | All-pass change |
| --- | ---: | ---: | ---: | ---: |
| 1–31 | 2,515 | -1.347% | 2,658 | -0.896% |
| 32–127 | 1,994 | -0.143% | 2,134 | +0.308% |
| 128–511 | 1,495 | +0.530% | 1,346 | +0.746% |
| 512–2,047 | 436 | +0.544% | 336 | +0.667% |
| 2,048–8,191 | 72 | +0.457% | 38 | +0.361% |
| 8,192+ | 6 | +0.436% | 6 | +0.450% |
| All | 6,518 | +0.295% | 6,518 | +0.456% |

[Native paired measurements and commands](converts-functions.tar.xz)

## Source selection with signed load and floating-point productions

The production `benchmark-tier1-select-source` command ran on Lua, SQLite and musl with the Release compilers on the 9700X. Each ratio divides the candidate’s measurement per IR instruction by the parent’s, then takes the median of three paired rounds. Both compiled the same set of functions. The bottom-up rewrite checks reported zero mismatches and zero uncovered nodes.

| Corpus | Selected functions | Instructions | Wall time | Core cycles | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 1,096 | 97,441 | 0.9857 | 0.9859 | 0.9826 |
| sqlite | 2,666 | 448,699 | 0.9867 | 0.9867 | 0.9920 |
| musl | 2,756 | 235,335 | 0.9897 | 0.9897 | 0.9881 |

[Inputs, native commands and all paired samples](signloads-source-selection.tar.xz)

## End-to-end compilation with floating-point load and binary rules

Each cell compares five paired rounds of three ordinary compiler processes on the locked 9700X. The table gives the median change in user cycles for a single-lane Tier 1 debug build relative to the parent. All 2,742 objects, standard output and diagnostics matched.

| Corpus | Default passes | All passes |
| --- | ---: | ---: |
| lua | +0.052% | -0.078% |
| sqlite | +0.109% | +0.055% |
| musl | -0.058% | -0.081% |

[Native compiler runs, input commands and object manifests](compile-float.tar.xz)

## Signed widening loads

Sign extension can fold a single-use signed load into the machine instruction. The new production distinguishes a foldable load from a register input, including an address the selector walks and a memory barrier between the load and extension. Calls and terminators also bypass unused candidate-slot initialization. The baked grammar has 1,031 states, 220 rules and 38,792 entries.

| Passes | Corpus | Visited nodes | Parent maximal munch | Floating-point revision | Signed-load revision |
| --- | --- | ---: | ---: | ---: | ---: |
| default | lua | 77,839 | 30,699 | 2,145 | 1,249 |
| default | sqlite | 323,431 | 115,581 | 10,917 | 4,952 |
| default | musl | 114,754 | 55,897 | 7,667 | 6,126 |
| all | lua | 76,245 | 30,433 | 2,696 | 1,804 |
| all | sqlite | 306,076 | 110,195 | 12,415 | 7,191 |
| all | musl | 107,878 | 53,511 | 7,615 | 6,212 |

Across the six compilations the revision reduced maximal-munch visits from 396,316 to 27,534 (93.1%). All 1,006,223 complete candidate rule lists and chosen indices matched the parent in visit order. All 2,742 debug objects and both output streams matched. The compiler passed the 5,957-plan frozen digest, 1,530,046 selector checks and three Clang-backed pipeline seeds. The independent 16-node function caught all three signed-load faults. The original direct, conversion and floating-point fixtures caught their 13 injected faults. A further 251 verified repository IR inputs covered 7,362 nodes.

[Probe and production source, oracle inputs, native checks, full candidate traces and object manifests](signed-widening-loads.tar.xz)

## Synthetic instruction widths with conversions

The production benchmark generated each shape at fifteen step counts on the locked Ryzen 7 9700X. The table gives the median of three paired changes in TSC ticks per IR instruction. Instruction counts, output records and bytes, spill and reload counts and both reported memory peaks matched in every pair. The candidate met the parent in 28 of 45 selection cells and 17 of 45 complete cells.

| Requested steps | chain selection | chain complete | pressure selection | pressure complete | wide selection | wide complete |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | -0.867% | -0.381% | +0.460% | +1.764% | -3.517% | +0.453% |
| 2 | -0.779% | -0.277% | -2.358% | +1.466% | -3.144% | +1.454% |
| 7 | -0.832% | +0.781% | -0.153% | +0.782% | -3.160% | -1.195% |
| 15 | -1.235% | +0.449% | +0.587% | +0.077% | -2.682% | -0.546% |
| 16 | -0.845% | +1.843% | +0.507% | +1.601% | +1.294% | -0.187% |
| 17 | -1.147% | +1.654% | -0.455% | +0.091% | -3.657% | -0.421% |
| 31 | -1.171% | +0.101% | +2.522% | +0.307% | -3.760% | -0.113% |
| 32 | -0.752% | +4.434% | +1.818% | +1.361% | -3.088% | +3.928% |
| 63 | -0.842% | -0.511% | +1.859% | +0.236% | -0.572% | +1.137% |
| 64 | -1.385% | +0.130% | +1.878% | -0.040% | -1.009% | +2.365% |
| 127 | -1.576% | -0.579% | +1.311% | -0.919% | -1.070% | +0.285% |
| 256 | -1.507% | -1.360% | +2.375% | +0.526% | -0.450% | +0.386% |
| 1024 | -0.230% | -1.121% | +2.291% | +1.300% | +0.799% | +2.958% |
| 2048 | +0.749% | -1.380% | +2.038% | -0.243% | +1.195% | +0.564% |
| 8192 | -1.336% | -2.777% | +0.648% | -0.748% | +1.310% | +0.579% |

[Native paired measurements and commands](converts-widths.tar.xz)

## Long double operations

The selector now classifies x87 operations from the result and operand types in each vector of IR instructions. Long double phis use the existing direct phi production. The baked grammar has 1,032 states, 221 rules and 38,823 entries.

| Passes | Corpus | Visited nodes | Signed-load maximal munch | Long double maximal munch |
| --- | --- | ---: | ---: | ---: |
| default | lua | 77,839 | 1,249 | 1,249 |
| default | sqlite | 323,431 | 4,952 | 4,952 |
| default | musl | 114,754 | 6,126 | 1,824 |
| all | lua | 76,245 | 1,804 | 1,804 |
| all | sqlite | 306,076 | 7,191 | 7,191 |
| all | musl | 107,878 | 6,212 | 2,696 |

The number of maximal-munch visits fell from 396,316 on the original build to 19,716 (95.0% fewer). All 1,006,223 candidate rule lists and chosen indices matched in visit order. All 2,742 debug objects and both output streams matched. The native suite passed the 5,957-plan frozen digest, 1,530,046 selector checks, and three Clang-backed pipeline seeds. A separate 21-node function required 17 x87 classifications. Changing the rule action or kind caused 17 mismatches. Dropping the extended-precision load from that class failed the count independently. The 251 verified repository IR inputs covered 7,362 nodes. These counts measure grammar coverage and correctness. Timing results have their own tables.

[Source, fixtures, faults, native logs, candidate traces and object manifests](long-double-productions.tar.xz)
