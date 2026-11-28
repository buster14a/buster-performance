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
