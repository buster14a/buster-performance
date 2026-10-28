# PR #633: remove the direct-name namespace table

Review supplement for compiler PR [#633](https://github.com/buster14a/buster/pull/633).
Prior source `fee24515606be3e79e30b55976cf251109fd6016`; reviewed source
`b30e5a247cd07e667e180ed5655f74ab33d8cce7`.

Direct names already passed the reader's `member_seen` duplicate check. The
packing pass now records whether an unnamed non-bit-field member exists and
omits the second namespace allocation/check when none does. Anonymous records,
invalid anonymous nonrecords, duplicate ownership and the defensive helper's
direct tests retain the previous behavior. No new namespace scan was added.

The complete target checker passes **269,753 checks, zero failures**. The
source manifest covers `build.sh` and every tracked source/header; every remote
file matched it before publication. The local Clang 23.1.4 full checker has the
same four floating-classification oracle mismatches already documented on the
unchanged baseline; target Clang 23.1.1 is clean.

## Matched measurements

Ryzen 7 9700X, Clang 23.1.1, `BUSTER_DEBUG_INFO=0 ./build.sh`, shared
`exclusive.sh` lock per build/test/measurement command, `taskset -c 2` for
measurements. `time-runs --runs 7 --copies 2` rotates the prior, review and
prior-again roles. Each row/role has 14 fresh processes. There are **168 measured
processes, all status zero and no major faults**. The original nesting inputs
are the unchanged, hashed inputs from the [earlier record](https://github.com/buster14a/buster-performance/tree/71171053ddb96b470e90dd7d7c57a1d9e72b8e29/docs/measurements/record-names-614-2026-10-27).
`ordinary.c` is an original small-record control with independent layout assertions.

| Syntax-only input | Prior wall ms | Prior again ms | Review wall ms | Prior user instructions | Review user instructions |
|---|---:|---:|---:|---:|---:|
| Ordinary small records | 0.772 | 0.777 | 0.782 | 1,408,427 | 1,408,020 |
| Nested 2,000 | 2.128 | 1.928 | 1.970 | 17,813,608 | 17,467,608 |
| Nested 4,000 | 3.330 | 3.438 | 3.447 | 35,566,748 | 34,874,748 |
| Nested 8,000 | 5.623 | 5.632 | 5.569 | 69,825,010 | 68,441,012 |

The nested cases execute about 1.94–1.98% fewer user instructions. Wall-clock
differences are small, with substantial same-binary role variation in some
rows; these measurements do not establish a precise latency improvement or a
fastest-design claim. Two executable copies are one build/link layout, not a
layout sweep. This short review supplement is unconditioned; the preceding
record retains the original normal/conditioned asymptotic comparison. No new
corpus-wide throughput claim is made.

## Reproduction

Build the two compiler commits separately with the flags above. Verify their
compiled source manifests and retain the hashes of both binaries and inputs.
The original generator/inputs are pinned by the previous record; use the
`nested-2000.c`, `nested-4000.c` and `nested-8000.c` inputs plus `ordinary.c`.
With `prior` and `review` set to those executable paths, run each comparison
under the shared host lock:

```sh
taskset -c 2 "$review" time-runs --runs 7 --copies 2 \
  --build prior "$prior" --build review "$review" --build prior-again "$prior" \
  --list --lanes 1 -fsyntax-only nested-2000.c \
  --list --lanes 1 -fsyntax-only nested-4000.c \
  --list --lanes 1 -fsyntax-only nested-8000.c
taskset -c 2 "$review" time-runs --runs 7 --copies 2 \
  --build prior "$prior" --build review "$review" --build prior-again "$prior" \
  --list --lanes 1 -fsyntax-only ordinary.c
```

The logs retain every sample, medians for wall/user/system time, peak RSS,
faults, user cycles and instructions. `identities.txt`, `source.sha256` and
`source-check.log` bind the build, host and inputs. Compilation/measurement
receipts are independent of the source PR's queued GitHub workflow.

Original report/control source under Apache-2.0 WITH LLVM-exception. No external
implementation or corpus material was incorporated.
