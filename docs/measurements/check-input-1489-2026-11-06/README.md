# check-input's growth since #1049 (buster#1489), 2026-11-06

This record has the 9700X evidence for buster's pull request on
[#1489](https://github.com/buster14a/buster/issues/1489). The issue reports that sqlite3.c's
`check-input` grew from about 45 ms before #1049 to 59 ms on main.

**Exploratory record; not policy-compliant qualification.** The SQLite and
self-source rounds grouped several compiler invocations under each shared-lock
lease; `perf stat -r 5` and the exploratory profiles also grouped invocations.
The repository's Benchpress policy requires a separate lock grant per run.
These historical observations are retained with that limitation; a compliant
repeat is needed before using them as performance qualification. The measured
`rhead` is an earlier compiler revision, not the current head of
[buster#1530](https://github.com/buster14a/buster/pull/1530).

## What was measured

| name | buster commit | what it is |
| --- | --- | --- |
| `pre1049` | `aca9e53aa981bb3f61d21cdd5a408ce5167a06f8` | the build before #1049, #1340's record's binary (below) |
| `rbase` | `6b3a7ebd150ab6b064eee79d9de42922f4f560c0` | main when the pull request was opened (#1529's merge) |
| `rhead` | `f9d76cdccffe720bc75343bb1a229e876f4110ab` | the pull request's head |

`rbase` and `rhead` were built here from `git archive` of those commits, with
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` under the lock
(`record/raw/build-*.log`). The `pre1049` binary and the run root come from #1340's record, the
`1340-droid` run root of
[buster-performance#271](https://github.com/buster14a/buster-performance/pull/271) (`tools/microarch`'s
layout). That root supplies the frozen corpus `preprocessor-391e729af658`, `self-main.i` and the predefines.
`record/sha256.txt` has every binary's and input's SHA-256.

`record/host.txt` has the host, the tools, CPU 2's governor and EPP, the transparent huge pages' settings and
the commits. The host is a Ryzen 7 9700X running Linux 6.18.50-2-lts, with clang 23.1.1 and perf 7.2.9-1.

[`scripts/record.historical.txt`](scripts/record.historical.txt) is the
byte-for-byte original recording script, retained for provenance as a
non-executable text file. Do not run it through a shell: its grouped lock leases
must not be repeated. It made everything under `record/`:

- **sqlite3.c**, as tools/microarch's `sq-c` workload: the frozen sqlite3.c with the CI's options, `-c --lanes 1`,
  `--time-stages`, on CPU 2. Each of 11 lock holds runs the three builds once, in an order that rotates by round
  (`record/raw/sq-BUILD.ROUND.log`).
- **perf stat** of each build: `perf stat -r 5` with `cycles:u`, `instructions:u`, `branches:u`,
  `branch-misses:u` and `task-clock`, one lock hold each (`record/raw/stat-BUILD.csv`).
- **The compiler's own main.c**, as tools/microarch's `self-syn` workload: `self-main.i` with `-fsyntax-only`.
  There are 3 lock holds, each running `rbase` and `rhead` once, in alternating order
  (`record/raw/self-BUILD.ROUND.log`).

Every lock hold appends the holder's line of `/var/lib/buster-9700x/owner` to
`record/holds.txt`; all 19 are this session's. `record/status.txt` has 44 zero
statuses: two builds and 42 run entries (33 SQLite compiles, three aggregate
`perf stat -r 5` commands, and six self-source compiles). The perf entries do
not retain a separate exit status for each of their five children. The holder
snapshots do not establish whether another session waited for the lock.

## Results

The internal `--time-stages` medians of 11 rounds, in ms, with the fastest and
the slowest. The difference is between separately calculated medians, not a
median of paired differences or a whole-process wall-time result:

| stage | `pre1049` | `rbase` | `rhead` | `rhead` − `rbase` |
| --- | ---: | ---: | ---: | ---: |
| check-input | 44.992 (44.809 .. 45.103) | 59.239 (59.039 .. 59.683) | 50.417 (50.250 .. 50.679) | −8.822 (−14.9%) |
| check-program | 10.339 | 26.736 | 26.812 | +0.08 |
| check-expressions | 10.248 | 10.241 | 10.216 | −0.03 |
| total | 105.929 (105.644 .. 106.747) | 138.989 (138.683 .. 139.288) | 129.997 (129.349 .. 130.378) | −8.992 (−6.5%) |

The separate `perf stat -r 5` **means**, not medians of the 11 stage rounds:

| | `pre1049` | `rbase` | `rhead` |
| --- | ---: | ---: | ---: |
| cycles:u | 503.0 M | 674.7 M | 624.5 M (−7.4%) |
| instructions:u | 1,155.7 M | 1,636.8 M | 1,393.1 M (−14.9%) |
| branches:u | 176.5 M | 252.5 M | 211.6 M |
| branch-misses:u | 3.13 M | 4.67 M | 4.24 M |
| task-clock | 106.19 ms | 138.68 ms | 129.82 ms (−6.4%) |

For the compiler's own main.c (`self-syn`), the medians of 3 rounds are:

| stage | `rbase` | `rhead` |
| --- | ---: | ---: |
| check-input | 1,191.7 ms | 1,110.6 ms (−6.8%) |
| total | 1,958.1 ms | 1,885.3 ms (−3.7%) |

At these measured placements, the `rhead` stage median is 8.8 ms below `rbase`
and 5.4 ms above `pre1049`. These are exploratory differences; the displayed
stage medians do not establish that other stages or warning costs are unchanged.

## Outputs

`record/outputs.txt` has SHA-256s of each build's sqlite3.c object and of the diagnostics both workloads printed,
with the `--time-stages` lines removed.

- The three retained object SHA-256s match; the objects themselves and a direct
  byte-comparison receipt are not retained here.
- The normalized diagnostic SHA-256s for `rbase` and `rhead` match for round 0
  of each workload; the other rounds were not compared in this receipt.
- `pre1049`'s sqlite3.c diagnostics differ: it predates #1049's warning (#1339).

## Exploration: where the growth was

[`scripts/prof.historical.txt`](scripts/prof.historical.txt) records profiling
each tree with `cycles:u`, `-c 50021`, over 8 compiles under one shared-lock
lease, contrary to the per-run policy. The profiles are exploratory, not
qualification. These trees were archived from local commits made before the branch was rebased onto
`rbase`:

- `exploration/profiles/base.*` is main `8b1e14b0` with a one-line fix for its build, the same lookup that #1529
  then merged. This build had debug information.
- `exploration/profiles/v4.*` is that tree with the pull request's first three commits. Their diffs are the same as
  `d6109cb3`, `924e8d12` and `8217031f` on `rbase`; only the line offsets differ.

`exploration/ab/` has A/B medians of those trees, run with the retained
[`scripts/ab.historical.txt`](scripts/ab.historical.txt) in 11 rotated rounds
with multiple compiles per lock lease. Only the summaries are retained here;
their individual logs and statuses are not part of this record:

| tree | check-input |
| --- | ---: |
| `base` | 59.25 ms |
| `v2`, the deprecated-use pass's commit alone | 52.99 ms |
| `v4`, its first three commits | 50.59 ms |

Against #1340's `pre1049` profile (buster-performance#271's
`zen5-9700x/profiles/pre1049-znver5.samples.txt`), the base tree's added check-input samples were:

Only symbol summaries are retained here, not the raw perf captures or
source-line reports. The following attributions are the original investigator's
interpretations and cannot all be independently reconstructed from this record.

- **The deprecated-use pass.** About 4,000 samples were its two per-token walks, inlined into `check_input_run`.
  There were 278 more in `check_input_deprecated_key`, plus its four 2.86 MB clears.
- **#823's unused-declaration facts.** `check_input_binding_answers` and `check_input_binding_answer` went from 696
  to 1,960 samples. Of those, about 470 were `check_input_parameter_marks`' read of every token.
- **The attribute lookups.** `memcmp` had 568 samples, `__strlen_evex512` 122, and `check_input_attributes` and
  `check_input_subject_row` together about 470.

In `v4`, `check_input_run` has 2,285 samples against `pre1049`'s 2,502. `memcmp` has 216 and `__strlen_evex512` 21.

The stage medians differ by about 5.4 ms between `rhead` and `pre1049`.
The following sampled symbol differences are exploratory leads; the profiles
do not apportion that elapsed-time difference among functions or prove causes:

- the expressions' coded walk (`check_input_expressions_coded_range`, `check_input_expression_flush`), net about
  +930 (#1038's area);
- the binding answers' remaining per-event loops, +845;
- the declarations (`check_input_declaration`, `check_input_declarator_step`, `check_input_specifiers`), +674;
- `check_input_intrinsic_initialize`, +255 (#893);
- `check_input_controls`, +234.

## Limitations

- **One host.** This record has the 9700X alone; it doesn't measure a Zen 4 host. On the Ryzen 9 7940HS, `pre1049`'s
  `check-input` already takes about as long as main's. Its coded expression walk, which later commits sped up, hides
  the growth there.
- **Two workloads.** The record measures sqlite3.c and the compiler's own main.c. Units without a deprecated or
  unavailable attribute don't run the deprecated-use pass at all.
- **Shared inputs.** `pre1049` is #1340's record's binary, identified by its SHA-256. This record didn't build it.
- **Lock policy and revision.** The grouped historical runs are nonqualifying;
  the current compiler head needs a new per-run-lock campaign and its own
  correctness qualification. None of these observations establishes that.
