# Include-directory negative lookup cache (#653): rejected experiment

Do not ship these production changes or count #653 as solved. Locked 9700X
whole-process comparisons lost performance despite reducing total system calls.
The parent accepted rejection. No PR, push or GitHub comment was made by this
worker. The original candidate branch and all negative data are preserved.
`README-local-first-candidate.md` is the superseded initial local report.

## Source identities and decision

- Baseline: `bc1b486150850fe00bad1361a19f57d67706bb3b`; target executable SHA256
  `d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d`.
- Initial candidate: `4b3a4f50f81dd4ad840a2183680e6b30fe55e222`.
- Probe-triggered candidate: `83cfe3b4dcdafa10533bd336058d870c9a56a913`;
  `b543fa9cf7e81b1a94d0a8177edf5dadfbdd291d` changes comments/docs only.
- Final bounded candidate: `d8a4b93663deac305e11d9a59c43610ef27f03ee` on
  `codex/perf-653`, worktree `work/issue-653`; target executable SHA256
  `34f26756ce3cfbcccca67fbf124ba281aaec769f323b3623e0221e13fea74771`.
- Removal: `da22a8a11a0b37642e2e1310b857f0aff6290d27` on
  `codex/perf-without-653`, worktree `work/without-653`, directly atop frozen
  integrated source `b8cd163ce33bb8042e42fd9fea7c675ae13fa487`.

`target-bounded/SUMMARY.tsv` is produced by original C helper
`summarize_cohorts.c` from unchanged target run logs. Values below are median
cohort wall time divided by completed tasks; positive changes mean slower.
Paired medians/ranges are retained in the TSV. No sample was discarded. Every
final cohort reports zero failures and zero major faults.

| Input | Baseline ms/compile | Bounded ms/compile | A/B change | A/A control |
|---|---:|---:|---:|---:|
| Frozen zlib deflate | 6.619653 | 6.633204 | +0.205% | -0.054% |
| Frozen zlib uncompr | 2.580823 | 2.601396 | +0.797% | +0.168% |
| Frozen SQLite | 143.876157 | 144.474156 | +0.416% | -0.115% |
| Live-header zlib deflate | 6.555187 | 6.570263 | +0.230% | -0.068% |
| Live-header zlib uncompr | 2.567418 | 2.581134 | +0.534% | -0.173% |
| Tiny source | 1.393158 | 1.407992 | +1.065% | +0.112% |
| First quoted local include | 1.401099 | 1.414821 | +0.979% | +0.184% |
| First successful `-I` lookup in a large directory | 1.398575 | 1.420349 | +1.557% | -0.126% |

Earlier failures remain too. The initial candidate increased the positive
`-I` control by 16.94% (A/A -0.416%). Moving construction after a paid ENOENT
recovered that control, but 83c still slowed live deflate by 0.472% and uncompr
by 1.514%; frozen changes stayed near A/A noise. See
`target-lazy/SUMMARY.json` and original logs. An 83c positive cohort with ten
major faults was retained, including its large outlier. The final conservative
refinement bounded setup to one directory page. It also failed end-to-end
qualification, so no further tuning or timing runs were attempted.

## Method and complete system-call tradeoff

All target builds, tests, captures, helper builds, measurements and final archive
compression took `exclusive.sh` with owner/title/issue link. Single-process
measurements/captures ran on CPU 2; target settings were unchanged. Original
`samples.c` and `cohort.c` under `harness-common/` rotate role order and retain
each object's bytes, diagnostics, child resources and aggregate measurement.
Equal-length executable aliases control argument layout. A/A uses baseline in
both roles. These are fresh processes with an unforced OS page cache, not
cold-storage measurements.

Each final candidate campaign contains 432 cohorts and 19,504 compilations.
zlib A/B uses 21 rounds and 48 tasks per role, A/A uses 11 rounds. Tiny/local
use 11 rounds and 64 tasks per role; positive uses 32, SQLite uses 4. Frozen
flags, input paths and exact invocation are retained in each `arguments.txt`
and `run_campaign.c`. Live zlib uses ordinary installed target headers.

Full `strace -f -c` captures include directory qualification, fstat, close and
optional-arena setup/teardown. Tracer time is not a performance measurement.

| Input | All calls baseline/bounded | openat baseline/bounded | fstat baseline/bounded | close baseline/bounded |
|---|---:|---:|---:|---:|
| Frozen deflate | 880 / 780 | 261 / 140 | 83 / 83 | 82 / 85 |
| Frozen uncompr | 783 / 705 | 215 / 116 | 70 / 70 | 69 / 72 |
| Frozen SQLite | 1475 / 1203 | 604 / 311 | 165 / 165 | 164 / 167 |

Each bounded compile adds six getdents64, three fstatfs, three faccessat2 and
three ioctl calls. Both the selected file-call and full all-call captures are
retained. Fewer total calls did not produce useful whole-compile speedup.

## First and reused FileCache observations

`target-bounded/CACHE.tsv`, produced by `summarize_cache.c`, summarizes the
original in-process `cache_units.c` adapter: 31 units per fresh/shared mode and
role. Initialization, work and unit/cache release are measured; output/diagnostic
hashing and printing are outside timing. Shared-cache release is separately
reported in the raw log. Fresh-cache warm work medians (baseline/bounded) are
1.011930 / 0.987529 ms for deflate and 0.578363 / 0.566771 ms for uncompr.
Reused-cache warm medians are 0.453580 / 0.446446 ms and 0.208656 / 0.203873 ms.
First-unit observations, including setup and release, are retained in the TSV;
each is one observation, not a cold-cache claim. These stage observations do
not establish an end-to-end gain.

Fresh bounded caches retain 158 names in three listings per unit. First-unit
file opens fall from 256 to 132 for deflate and 210 to 108 for uncompr. Later
shared-cache units make zero file opens and zero listings in both roles. All
per-input token/location and diagnostic digests agree across roles/modes.

Directory names are a snapshot for the FileCache lifetime, matching the issue's
immutable-files contract; permanent tests verify that a fresh cache sees new
names. The final policy uses sizes from already-required stat calls as a cheap
admission hint, then requires a complete one-page getdents64 result followed by
EOF. Partial, unreadable, unsearchable, unsupported/casefold and exhausted
listings retain ordinary probes. Known components, symlinks, dot/dot-dot, path
aliases and overlong components retain ordinary lookup behavior. Include order
and include_next remain with existing search. Decoder offsets follow Linux
[getdents(2)](https://man7.org/linux/man-pages/man2/getdents.2.html); no external
implementation was copied.

## Correctness, interference audit and raw evidence

Final d8a4b936 optimized local/native builds pass. Local preprocessor tests pass
377 built-in cases, 176 header/mode sets and 3000 C17/C23 Clang comparisons;
file lanes 1/2 pass, including memory failures. The call graph reports 41 units,
25,115 functions, 149,533 calls, zero disallowed cycles and zero split variables.
The focused bounded ASan/UBSan adapter passes 1665 checks and requires an actual
supported complete listing, so it exercises the decoder. The permanent budget
fixture ensures a partial page never hides a later entry. Actual casefold setup
is unavailable on the local fixture filesystem. Locked native Clang/preprocessor
tests and file lanes 1/2/3/8 pass.

Each 83c/d8 campaign independently passes its binary oracle: all 19,504 measured
objects and diagnostics plus 18 traced objects, 39,026 files total. Exact paths,
bytes and equality results are in `byte-manifest.tsv`, with `verify.log` summary.

Final 432 cohort intervals run from 12:57:48.977402568 through
13:00:06.544975730 UTC on 2026-10-28, after all five reported unlocked-compression
windows. The preceding 83c campaign's 432 intervals also have zero overlaps
(`target-lazy/contamination-overlaps.json`). Reported windows are
11:46:01–11:46:10, 11:51:35–11:51:44, 12:06:56–12:07:12,
12:08:16–12:08:24 and 12:27:37.850–12:27:40.604 UTC. Child-ledger birth and final
modification give conservative interval bounds. No negative result was dropped
or attributed to contamination.

Original external runtime corpora are zlib 1.3.1 from
https://zlib.net/fossils/zlib-1.3.1.tar.gz (archive SHA256
`9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23`) and frozen
SQLite SHA256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
with the pinned corpus headers/predefines. Inputs are external corpora, not
compiler imports; original zlib archive/source remain under `inputs/`.

`target-all-negative-evidence.tar.gz` retains all three target candidate
directories and every measured object/diagnostic, without duplicated inputs or
helper binaries. Its SHA256 is recorded alongside it. Compression held the
shared lock from 13:04:15.387205843 to 13:04:47.481101264 UTC, with a saved receipt.
`target-curated/` extracts the same receipts/helpers/child ledgers/manifests,
omitting objects, per-child diagnostics and executable aliases; the full archive
retains them. Nothing remote was deleted. The intentional old queue-helper
rename (`QUEUE_SWITCH.txt`) ended an obsolete serial controller with status 127;
actual independent cohorts completed and were verified. Early incomplete local
collection/command receipts retain explicit names.

## Removal ownership review

Removal commit da22a8a1 cleanly reverses exactly six #653 integration commits:
aea89b6a, af66e3be, e67dda41, d9d136a7, 91bfa8e9, 62b77ef0. No conflict
resolutions or unrelated edits were needed. Only AGENTS.md, docs/c-files.md,
c_files.c, c_preprocessor.c and c_preprocessor_test.c change: 20 insertions,
374 deletions. Diagnostic batching (#636) and printing (#649) bodies lie outside
every changed hunk; other files are identical to frozen b8cd163c. c_files.c is
byte-identical to original bc1. Merged main 4165454e remains an ancestor.

Frontend-unit and preprocessor-benchmark syntax checks pass with build flags;
diff whitespace validation passes, and no snapshot symbols remain. The DCO hook
signed the local removal commit with the user's opt-in. The parent will run the
final integrated rebuild/qualification; this worker did not duplicate that
build. The original candidate branch remains unchanged at d8a4b936.
