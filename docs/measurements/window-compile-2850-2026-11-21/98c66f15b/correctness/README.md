# Unused binding analysis on ordinary compilation

The measured production source is `98c66f15b1dc3ab3aa5f5b3116fe3c9f7de0ac36`, based on `f0a204a9c335d`. The production patch selects the reporting mode for ordinary object and link commands. Raw checker calls, explicit graph dumps, and attestation capture or verification retain the exhaustive warning-event list.

The checker first resolves bindings normally. Before allocating the unused-analysis columns, the reporting mode checks the same command-line mapping and source diagnostic-pragma history used by common warnings. Any potentially enabled member of the six warning groups keeps the ordinary traversal, including a source directive that enables a group locally. With no possible consumer it omits the traversal. The six groups are unused functions, local typedefs, variables, const variables, set-but-unused variables and parameters.

## Local census on real compiler input

Instrumentation applies separately to the same parent as the production patch. The frozen SQLite source SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. The edition used here produced 716,136 preprocessed tokens and 323,623 ordinary graph nodes.

The original binding usage pass processed 167,474 binding events, including 34,530 declarations and 97,600 uses. It consumed 5,209,182 bytes of arena scratch. On this input it produced zero unused-binding warning events, including under `-Wall -Wextra`. A smaller positive fixture supplied seven raw events and checked their observer under diagnostic pragmas and command-line mappings. There are 59 same-image comparisons in the instrumented policy record. Suppression retained the existing resolution of the uses, then removed the unused-analysis allocation and all three declaration walks. The raw census shows the whole binding use count from before that step.

The separate per-pass probe ran three ordinary object compilations of the frozen SQLite and Lua 5.4.8 `lvm.c` sources for each policy. Its local reference-TSC median for SQLite's default common-facts pass was 32.17 million ticks. The common graph warning walk took 29.39 million. Uninitialized checking was already off by default and cost 127.42 million ticks with `-Wall -Wextra`. Roots, parents and evaluated operands remain inputs of ordinary, default-enabled bounds, arithmetic, conversion and unsequenced diagnostics. The binding usage pass has an independent policy guard. The pass-cost file records reference ticks in millions and the scratch high-water change in bytes for each named call. These samples are local reference-clock intervals, distinct from the locked Ryzen 7 9700X user instruction, cycle and elapsed-time pairs.

Three additional local hardware counter pairs use a single compiler binary with the diagnostic control, alternating the first mode. Every pair removed about 19.02 million user instructions. The native locked source-to-source record is the production timing result.

## Reproduction

Build the two production sources with the normal repository build. Use the repository reference Clang for full driver checks. Run the artifact comparison against the frozen source directory using the following command.

```sh
python3 compare.py /path/to/baseline/compiler /path/to/candidate/compiler /path/to/frozen/sqlite
```

The comparison invokes the real drivers on 200 pairs, including ordinary, scalar and three-lane deferred objects and syntax-only mode. It compares status, complete stdout and stderr, file presence and all output bytes. A successful run prints a per-case digest ledger followed by the number of pairs and delivered objects. Run both binaries under the same paths, working directory and system headers. Diagnostic byte counts depend on the spelling of source paths.

The two diagnostic patches can each be applied to the parent source independently. For the binding census set `BUSTER_PRIVATE_UNUSED_PROFILE=1`; set `BUSTER_PRIVATE_UNUSED_ELIDE=1` on the second run. For the per-pass probe, compile the chosen file with `-c` and inspect `wpd` rows. Production binaries use only the real driver policy and have no diagnostic environment control.
