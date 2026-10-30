Version2 focused receipts; frozenv1 sources/288regularreceipts stay unchanged.
Production delta: hp_common46caf Bash environment hardening only. Final new C
controls are Bash18489b80 and independent raw-environment4dc65e8e.

Final focused assertions183/183 per mode: common95 +controller57 +Bash21 +raw10,
all strict and checked runs exit0. These do not relabel v1's612 assertions as
newly executed. Bash parent-only LSan scope is explicit in its actual-build
receipt; no per-worker leak-exit claim. Unchanged ELF/pad/linked/driver/plan/
receipt source and old results are retained under their original v1 pins.

Final component paths have env-final or final-v2 names. Original Bash23-case
strict run had4 unsupported dirty-fixture expectation failures; all clean
cases passed. Exact initial58b source plus matching original compiledbinarySHA,
raw scripts/argv/output/status and development notes are retained. Corrected
21-case controls separate startup settings and assert actual local behavior.
The queued focused launch's exit127 before fixtures is retained as a support
binary availability preflight failure, not a sourcebuild/compiler failure.
Intermediate5d common source is development-only; final46caf adds malformed
raw-entry refusal. Nothing in these development attempts used real producers.

Compiled control binaries are omitted; COMPILED-CONTROL-IDENTITIES.txt records
their retained originals' hashes. This bundle retains only control inputs,
raw outputs/statuses and explicit history; frozen29-file actual-source package
and its source/patch manifests are separate. Intentional negative symlinks are
recorded by SYMLINK-TARGETS.txt; regular files are SHA-manifested.

No Buster/repository build script, compiler/assembler/linker producer, remote
operation, produced target image, benchmark, performance cell or system change
was executed by this correction. Final actual-source/receipt review and root
producer disposition remain separate gates.
