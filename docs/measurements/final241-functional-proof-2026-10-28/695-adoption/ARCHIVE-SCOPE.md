# Scope: completed lossless-token-return adoption

[Original report](README.md), [same-tree hashes](composed-tree-identity.txt),
[corrected native protocol](protocol-native.log), [corrected sanitizer protocol](protocol-asan.log).
The original 35d guardian's EAGAIN/63-credit-loss finding is retained despite
green original CI. Original 186 checks did not exercise that case. Correction
b1b3e490cde7639e2030619c7b0054f352327679 adds lossless opaque-byte recovery.
Real-reexec local native and ASan/UBSan checks pass 204/0. The old-source adapter
receipts passing 181 checks are rejected and remain separately named.

Bounded composition b66527e33d2fac90c6eca9c62a75926f6bd60118 builds 41 units on
native/generic and passes lane smoke 2,682/0 and 2,716/0, including protocol204.
No broad checker/full-batch suite was run in this bounded adoption record.
Public ce8be68972d192ccbabb989dc8c819b39f50f19b and tested private b665 have
identical tree c7627b0d586819ee942ada2e1b28cb8c8d9af854 (two identical hashes in
the original identity file). This permits same-tree functional attribution;
it is not a new build or performance measurement.

The proposal's real-make stress, contention, driver and full-build results are
externally credited, not relabeled as our reruns. Recovery-buffer setup cost
is unmeasured, and old 673 timing does not transfer. The coordinator's later
ce8 hosted native/baseline PASS plus queued benchmark is a status snapshot;
it supersedes the original report's in-progress handoff text without rewriting
it and makes no general current-head or benchmark-pass claim.
