# Local #641 candidate, 2026-10-28

Compiler base: `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Candidate commits: `7c1f0b09b7e68b28f8281f06580d5c33540d21ae`, then
`a29b4072c5dc2a5834e4ffce6ab1e274d9afd20b` on local branch `codex/perf-641`.
No branch was pushed and no pull request was opened. Original implementation, fixtures and adapter;
Clang runs externally as an oracle. Repository/component licenses remain unchanged.

This record is a Ryzen 9 7940HS screen, not target 9700X acceptance. All multicore work uses the shared
`cores` scheduler. `identities.sha256` identifies the final executable, stable baseline and frozen SQLite.

## Final release correctness

- `build-final.txt`: all 41 translation units build, `BUSTER_DEBUG_INFO=0`.
- `checker-final.txt`: seed 641, 389,229 checks; four existing laptop Clang fpclassify oracle disagreements.
  No full-checker pass is claimed.
- `driver-final.txt`: 21,646 checks, zero failures; 1,600 comparisons with the independent dense warning collector.
- `deferred-final.txt`: 1,113 checks, 684 successful merges, 6,492 bodies read apart, zero failures.
- `c-testsuite-pinned.txt`: 220/220, zero unsupported, with native Clang cross-check. Input checkout is
  `/home/david/Documents/Codex/2026-10-27/sol-11/work/c-testsuite`, read-only, verified at
  `5c7275656d751de0e68b2d340a95b5681858ed07`.
- `call-graph-final.txt`: 41 units, 25,109 functions, zero disallowed cycles and zero split variables.
- `sqlite-identity.txt`: baseline, candidate vector and candidate scalar objects are byte-identical,
  SHA-256 `427dd0a495f26927a22c71c3b2fb19996f9751d5d704ef7a55d4858172b9ef65`.

Permanent regressions cover every initializer token against an independent ordered merge; lookup lengths
0 through 129 with inaccessible tails and absent endpoint keys; static-policy metadata and object access
against dense source-order oracles; selection with producer ownership versus body-search fallback; and
parameter-VLA builtin ownership where the source token precedes the function opening.

## Local timing: held candidate

`sqlite-screen.txt` and `sqlite-screen-reverse.txt` are seven-round rotated whole-process screens,
including startup, object writing and release. The candidate is slower in these local runs:
188.937 versus 187.031 ms (+1.02%); reversing roles gives 189.328 versus 185.027 ms (+2.32%).
Peak RSS is about 502,900 versus 502,230 KiB. Every measured process succeeds. These runs do not
establish an accepted optimization or 9700X behavior.

Separate stage medians improve declaration checking, program checking and emission setup, but static-data
preparation and selection regress. Charge producer and consumer together: `benchmark-lowering-source`
prepares static data/program outside its timed region and cannot establish neutrality of moved policy work.
Controlled target measurements, and ablation of the compact selection lookup if needed, remain required.

The emitted attribute pass still scans pointer candidates once. Tracking all attribute writers, parameters
and deferred merge/fallback into a producer-owned declaration list remains a representation opportunity.

## Sanitizer receipts

`postcheck-checks.c` and `main-standalone.c` are original local adapters around the repository tests. The
main-file copy changes only `BUSTER_ELSEWHERE` to emit module entry points in one translation unit; its
renamed unused driver is discarded by section GC. Compiler code is included from the identified worktree.

`asan-checks.txt` is a rejected first adapter run: it passed null as the required Clang oracle name.
`asan-final.txt` corrects that adapter and completes 4,556 checks with zero fixture failures and no ASan
address finding, but UBSan reports unchanged `c_lowering_symbols.c` calls of `qsort(NULL, 0)` at lines
180, 398 and 399. It is not reported as a clean sanitizer pass.

`postcheck-checks-no-symbol-oracle.c` keeps the same selection/index/initializer/report tests and disables
only Clang symbol comparison inside the selection fixtures, whose ordinary release runs already cover it.
`asan-no-symbol-oracle.txt` completes 4,366 checks with zero failures and no ASan/UBSan diagnostics on the
final candidate source. No compiler source is altered to suppress a sanitizer result.

The earlier `build.txt`, `checker-first.txt` and `driver-first.txt` are preliminary receipts, not final-head
qualification. `c-testsuite-final.txt` is a rejected invocation without the required corpus-directory argument;
the pinned receipt above is the completed campaign. Failed experiments are retained explicitly.
