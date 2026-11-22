# Native fragments carried across a live preprocessing checkpoint

While the original preprocessor held an active input context, a private semantic reader checked the closed declarations and encoded function bodies. The original preprocessor then resumed. At final emission the compiler compared the selected machine instructions and reference counts, reused matching earlier bytes and field offsets, and resolved symbols in the final program. At SQLite window 24, 1,671 distinct function openings supplied 534,539 bytes to later native encodes. Buster reused 146,026 bytes across 294 openings. Some openings supplied more than one encoder call. These are compiler-body counts and include internal functions considered during compilation. [Per-workload counts](handoff.tsv), [source](source.patch), [revision](revision.tsv).

The two complete ordinary-reference ELFs matched byte for byte on the local Ryzen 9 7940HS. The prefix checker and final checker each perform semantic work in this experiment. The reported coverage measures earlier encoding actually consumed in process. [Full compilation logs, preprocessor snapshot, encoder and test commands](runs.tar.gz).

## Perturbing the retained state

At the return from the real prefix callback, an independent debugger changed a first instruction in all 1,671 records. The final compiler declined every changed record and emitted the exact reference ELF. Changing early bytes instead affected the final ELF, as did modifying 1,349 nonempty fixup-ending arrays. This checks both fallback and actual use of the retained state. [Actions and hashes](interventions.tsv), [debugger driver](run.py), [raw logs](interventions.tar.gz).

In five local Develop ABBA rounds, executing the prefix instead of scheduling it past EOF added a median paired 141.930 ms on SQLite and 494.537 ms on Buster. Every pair lost. [Paired wall times](local-wall-pairs.tsv), [individual processes](local-wall-samples.tsv), [timing harness](measure-local.py).
