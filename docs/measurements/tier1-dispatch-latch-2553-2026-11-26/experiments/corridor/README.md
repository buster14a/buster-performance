# Corridor-model experiment — rejected by dynamic measurement

This measurement-only patch applies to buster candidate `d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167`.
It is separate from production PR #3631. The initial candidate leaves sqlite3VdbeExec unchanged.

The experiment finds the existing first-handler convention through a bounded forward header path,
allowing a default edge directly back to the latch or through one unconditional block with no phis.
It publishes the model to the latch, visited header/dispatch blocks and default intermediates.
It keeps the graph's sibling/continuation metadata unchanged, and lets header phis use the same model.
Masked vector loads, gathers and a bounded scatter implement the path and model publication.

Patch SHA-256: `c7c0e010ce1d7bee2dca89d4a9bc4bbacac5af8f7278782365e0ed0f4f6e978c`.

Actual SQLite input capture from baseline `8e4d32879e17b7d9548cad54257a2f8461328366`
reproduces its allocation fingerprint `03c4f1e1d5fec534` exactly and passes the CFG certificate.
The function has 3,591 blocks and 8,108 values. The initial candidate produces an identical dump.
All four captured large SQLite functions reproduce their baseline allocation fingerprints.

The relevant actual blocks are latch 3543, header 3544, dispatcher 3545, default intermediary 3542,
and first handler 27. The header's default edge goes to 3542, whose sole successor is the latch.
The initial same-operand majority predicate misses the unchanged cold operand; a latch-only model
also fails because the header takes its joined convention from the default intermediary.

The corridor replay passes the certificate, with fingerprint `c14fca8df1343816`.
Its interval count remains 69,922; fragments change 70,774 to 70,775, spill values 214 to 216,
and resolved moves 2,385 to 2,451. The main dispatcher-to-first-handler edge changes from three
reloads and one store to one reload, but other edges add traffic. This static tradeoff is not
acceptance evidence. The fresh dynamic comparison below rejects the experiment.

The frozen corridor source passed the unchanged full CFG suite (107,813 checks), plus 731 focused checks at O3 and with ASan/UBSan. [The exact validation](validation/README.md) includes the shared-default shape and masked-memory guards. Correctness did not imply a workload improvement.

## Dynamic rejection

| Mapped executable instructions | Baseline | Corridor | Delta |
| --- | ---: | ---: | ---: |
| SQLite | 2,250,813,933 | 2,272,495,659 | +21,681,726 |
| sqlite3VdbeExec | 457,760,300 | 479,441,998 | +21,681,698 |
| Lua, five scripts | 3,994,120,551 | 3,995,041,787 | +921,236 |
| luaV_execute | 2,035,500,325 | 2,036,419,327 | +919,002 |

SQLite's interpreter gains 2,210,382 edge register moves, 6,073,931 edge stores, 4,643,508 edge reloads and **8,735,266 spill stores**. Spill reloads and call saves/restores are unchanged. The result is rejected.

Lua's interpreter edge/spill categories are unchanged, but relocating a reload to outgoing edges adds a jump executed 919,002 times in the tables script. The retained structural comparison accounts for the entire interpreter delta; 7,116 aligned instructions retain identical execution counts. Small changes outside the interpreter, including one extra S and u each in singlestep, remain recorded without unsupported causal attribution.

Both generated programs pass their native oracle checks and all six fresh Callgrind outputs are verified. Every unmatched address is outside the executable's LOAD segments. These are cloud-host instruction counts, not native timings.

[Detailed attribution and provenance](counts-analysis.txt) accompany the [compressed raw evidence](corridor-rejected-raw.tar.xz). The archive preserves tags, disassembly, raw Callgrind, per-function/category tables, output verification, compiler identities/logs and an internal SHA-256 manifest. Large per-instruction joins are reproducible from these inputs. Archive SHA-256: `9194473e5f3b145db45c92ba11ccc518261df5e7bf47bed4f32fe3d089f187d2`.

The hosted diagnostic build uses the original pinned tags and snapshot patch, then this patch.
No hardware benchmark is requested. No elapsed-time claim follows from hosted instruction counts.

Original source additions use Apache-2.0 WITH LLVM-exception.

Agent session: 6b07eefe-ecbc-83eb-8e50-5060ad2a8075 (OpenAI session ID; no share URL is exposed).
Model: OpenAI / GPT-6 Astra Pro.
