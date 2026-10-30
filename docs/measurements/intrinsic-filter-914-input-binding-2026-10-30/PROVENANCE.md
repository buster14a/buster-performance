# Preparation provenance and limits

`profile914.c` is original C controller code prepared in David's authorized
Codex reviewer session. It uses POSIX/Linux libc interfaces and invokes existing
external tools; no external implementation or third-party fixture is imported.
It follows the project default Apache-2.0 WITH LLVM-exception terms. No source
compiler or external ELF is incorporated into these added files.

The command protocol and compiler flags are transcribed from the already
reviewed 146 producer `profile-capture.sh` and `sqlite-once.sh`, retaining their
period250003,4096-byte stack,CPU2/CPU3 split,safe minimal environment and matched
explicit1MiB writer buffer. The new launcher is C and adapts only new private
input/output paths and command execution/accounting. It is not an executed or
reconstructed historical launcher and supplies no old-run receipt.

Expected original compiler/reader/adapter and historical offline-analysis hashes
in `DEPENDENCIES.tsv` retain frozen 146's source/executable and final decoder
identity receipts. They are distinct from the target recording host's tools.
Authorized read-only `david@benchpress` inspection at 2026-10-30T18:34 UTC found
target perf `a6da58ff...62f7d4f`, libdw `14a4563f...dc8786` and libelf
`13d3e3cb...8e08af`; complete hashes are the three `target_capture_*` rows.
The original offline f48c2d/a89708/1cff58 values remain separately named, unchanged.
Only those three prospective capture-host constants change in the controller;
no algorithm, original compiler, profile flag, process count or acceptance gate
changes. The original source and hosted artifact remain preserved in history.

Expected archive/header/SQLite identities come from
Buster `tools/ci/fetch-corpus.sh` at reviewed mainCAEF; the explicit predefines
digest is the frozen provenance manifest's `gnu17-pinned-predefines.txt` row.
The target inspection authenticated current paths/hashes, not historical 146
recording-tool identities or consumed inputs. Full commands/statuses/raw outputs
are retained by the coordinating review in `work/prepare914-target-readonly/`
and `work/prepare914-target-preflight-proof.json`; these are not a new capture.
All input values remain preparation expectations, not historical or new private
consumed-input verification receipts. Runtime inputs, tools and the original
compiler release retain their own licenses/notices and remain external.

The complete old146 packet and its reporting note, all199 original files and
seven release assets/tag, and140 remain untouched. This additive preparation
contains no measurements, captures, private input snapshot or tool binary.
The original 611-line source was built, never executed, by hosted run 41105728145
at exact 66149; authenticated inert ELF a6b58058 is evidence only for that old
source. This prospective three-pin correction has not been built or executed.
It needs new exact-head independent review and a newly authorized ordinary
hosted-only build/artifact binding. No test/probe/profile, remote staging,
resource acquisition or host setting change occurred. No historical certificate,
source performance approval or frozen-workload acceptance is inferred.
