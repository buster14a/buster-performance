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
