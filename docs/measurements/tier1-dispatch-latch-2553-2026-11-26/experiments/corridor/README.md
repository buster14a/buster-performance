# Corridor-model experiment; not an accepted fix

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
acceptance evidence. A full tagged dynamic comparison is pending.

The earlier conservative latch-only vector prototype passed the unchanged full CFG suite
(107,813 checks). That result does not certify this subsequent corridor extension.
Small same-value and separate-header regressions exposed the initial defect and are being extended
with the actual shared-default shape.

The hosted diagnostic build uses the original pinned tags and snapshot patch, then this patch.
No hardware benchmark is requested. No elapsed-time claim follows from hosted instruction counts.

Original source additions use Apache-2.0 WITH LLVM-exception.

Agent session: 6b07eefe-ecbc-83eb-8e50-5060ad2a8075 (OpenAI session ID; no share URL is exposed).
Model: OpenAI / GPT-6 Astra Pro.
