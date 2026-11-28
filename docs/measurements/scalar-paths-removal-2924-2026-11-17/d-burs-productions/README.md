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
