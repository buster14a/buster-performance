# Definition convention after call-argument preferences

This second definition experiment preserves the existing call convention before assigning an otherwise unhinted late definition its earlier body register. It is against compiler baseline `8e4d32879e17b7d9548cad54257a2f8461328366`.

- Patch: [definition-hints.patch](definition-hints.patch), SHA-256 `8d87718046ee258b1a8705873547ba0f3dbad9a333bef9f82330e2010e06dbc3`.
- Resulting CFG source SHA-256: `f87810acea8273edb0ae97ee3f0419eaaf9e4e7ef527a393a6dabde28de59c64`.

## Why the phase matters

The first definition experiment reduces edge traffic with no increased measured spills in controlled workload runs. However, it also blocks existing call-register propagation through tied instructions, adding 1,091,787 SQLite call-setup instructions. Most are in sqlite3BtreeIndexMoveto: a computed pointer moves from R8 to RDX, and the following call needs a three-move RSI/RDX swap instead of two moves.

In the actual 93-block, 370-value Btree CFG, value v243's defining interval I426 is tied to the add-one result v248/I432. The baseline's argument-avoidance pass propagates the RSI preference and avoided mask through that tie. The first experiment installs a stronger definition hint before that pass, preventing propagation.

This version runs definition hints **after argument avoidance** and leaves every existing final register hint in place, including hints propagated through ties. It does not change call-save masks, register pools or eviction policy. The vector byte-column lookup gathers only four-byte windows wholly inside the column; columns shorter than four bytes use a masked byte load.

## Replay evidence before fresh dynamic measurement

The actual Btree allocation and complete dump now match the baseline exactly, fingerprint `4adeaee6301ad982`. Lua retains the first definition experiment's allocation exactly, fingerprint `628b63303053c54b`, 575 moves and 40 spilled values. The earlier controlled Lua measurement removed 12,742,604 edge instructions without changing any other origin group; retaining that result still requires an emitted-program check for this exact source.

The four large SQLite snapshots have 2,383 / 888 / 446 / 359 resolved moves versus baseline 2,385 / 899 / 453 / 361. Their spill-value counts are unchanged (214 / 117 / 89 / 44). All six certificates pass. Additional fragments concern recipe eviction or recomputation, with no added register-to-spill transition. The main SQLite dispatch latch is unchanged.

The patch is pinned before hosted compilation and fresh dynamic measurement. Final correctness tests, emitted-program counts and the no-extra-spills check are pending. Native placement measurements remain excluded by the session's no-benchpress/9700X constraint.
