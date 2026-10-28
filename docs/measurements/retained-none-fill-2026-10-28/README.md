# Bounded retained-column fill qualification

Thirteen mandatory `uint32_t[count + 1]` reader output columns use `UINT32_MAX`
as their empty value. The candidate fills them one column at a time with
bounded `memset(..., 0xff, ...)` calls. Requested scalar parsing retains the
original nineteen-store initialization loop as an independent oracle. The six
reader-internal NONE stores and nullable zero-default assembly-ID initialization
are unchanged. No arena storage, reader walk, allocated byte count or freshness
assumption changes.

The bounded result supports a large-table CPU/work improvement. It does not
establish a peak-memory or system-time reduction, the full goal of compiler
[#628](https://github.com/buster14a/buster/issues/628), or a general compilation
speedup. No refinement was made after this candidate's first native screen.

## Frozen sources and binaries

| Role | Compiler source | Native debug0 binary SHA-256 |
| --- | --- | --- |
| Base | `96a4ad102cb7882ba834374ddfcf38eac080b924` | `6663d2b127fa68d3b31f8cb95d28419c1fbaf82905e40d1dca7765aca11cb43c` |
| Candidate | `95be46e6e67466565d37e29b9c5131abd19c2af6` | `acfb630bcbb892ce11128c9a62496948a2c57d85f418642f968e0b8b3e45f603` |

The base is the published #696 stack, including #693/#628 and #694/#641 on
main321. These measurements are not claims for later main revisions. Each
private native build uses the same Clang and `BUSTER_DEBUG_INFO=0 ./build.sh`,
restricted to CPUs 2 and 3. Original build logs, source markers and complete
compile commands are retained. The final publication may append documentation
without changing these measured C source blobs.

## Correctness

Both native source images compile the pinned SQLite input and original
800,000-byte table into identical complete objects. All 360 objects from the
timing and instruction campaigns agree within their source class. Every
compiler invocation succeeds and every timed compile has zero major faults.
The candidate's native checker completes 466,964 checks with zero failures.

Local Clang23.1.4 validation includes the release build (41 units), full checker
(466,964 checks with the same four known fpclassify oracle disagreements),
assembly/Clang (1,010/0), deferred reading (1,147/0), driver (21,655/0), and
focused ASan/UBSan (206/0). The pinned c-testsuite cross-check passes 220/220;
the 41-unit call graph has 25,407 functions, 151,105 calls, zero bad cycles,
three allowed cycles and zero split variables. Guarded dirty columns cover count 0 through 200 plus
the sentinel. Copied/borrowed arenas cover counts 0, 1 and 257, preserving the
owner's prefix and excluded zero-default column. Two independent read-only
source audits found no concrete correctness defect.

The older unqualified prototype on `1b98b195139a114c9b5da6cf7f82c083ce14c165`
is preserved separately as historical material. It is not this experiment's
baseline or performance evidence.

## Native whole-process controls

The existing Ryzen 7 9700X host runs each operation under the shared
`exclusive.sh` lock. A separate lock covers each build, test, campaign and
packaging operation. No host policy was changed. Each fresh compiler process
uses one lane and CPU 2, ordinary warm file cache, and normal object output.
Startup, compilation, object creation/write, teardown and scheduling/wait costs
are charged. Source/header bytes and binary identities are retained.

Each row below has 21 paired rounds. Within-round role order rotates. A/A uses
the exact same base binary in both roles. A/B uses base then candidate roles;
B/A reverses those role labels. All samples and outliers, including the first,
remain in the raw record.

| Workload and control | Role 0 median wall | Role 1 median wall | Role 0 / role 1 median peak RSS |
| --- | ---: | ---: | ---: |
| SQLite A/A | 126.865698 ms | 126.731236 ms | 374,896 / 374,872 KiB |
| SQLite A/B | 127.023062 ms | 125.945543 ms | 374,872 / 374,908 KiB |
| SQLite B/A | 125.843983 ms | 126.784435 ms | 374,916 / 374,900 KiB |
| 800k-byte table A/A | 60.573142 ms | 60.681896 ms | 473,528 / 473,556 KiB |
| 800k-byte table A/B | 60.797858 ms | 56.983384 ms | 473,528 / 473,564 KiB |
| 800k-byte table B/A | 56.848960 ms | 60.843618 ms | 473,600 / 473,556 KiB |

The table's candidate throughput is 6.694% above base in A/B and 7.027% above
base with reversed roles. Every pair in both orders favors the candidate.
Table A/A's paired median bias is +0.0031% (11/21 role-1 wins), with its role
median difference -0.179%. This large-table wall gain accompanies the
instruction reduction below.

The small SQLite observations (+0.856% and +0.747% throughput) are retained as
cost screens. A/A role throughput differs by +0.106%. Code-placement variants
were not run, so no qualified sub-percent or general SQLite speedup is claimed.

Peak RSS is effectively unchanged. System time does not improve: the table A/B
medians are 20.154 ms base and 23.475 ms candidate; reversed roles give 20.068 ms
base and 20.412 ms candidate. User time falls from 39.782 to 33.279 ms in A/B
and from 40.596 to 36.284 ms in reversed roles. These are separate medians;
their sums need not equal the median wall time. The result earns a bounded CPU
and wall-time optimization, not #628's memory/system-time acceptance.

## Retired user instructions

Separate `perf stat -x, -e instructions:u` runs use nine rotated pairs per
control and the same complete compiler command, with CPU 2 affinity. The event
is restricted to user mode, follows the launched process, and reports 100.00% running
in every retained row. No mixed-recording or multiplexed count is accepted.
`instruction_summary.c` rejects missing/duplicate rows, nonnumeric counts and
reported running percentages below 99.999%. It does not infer kernel work
from this user event.

| Workload | Base median retired user instructions | Candidate median | Reduction |
| --- | ---: | ---: | ---: |
| SQLite A/B | 1,254,019,483 | 1,235,357,352 | 1.488185% |
| 800k-byte table A/B | 674,654,534 | 632,928,983 | 6.184728% |

Reversed counts corroborate both reductions. A/A medians differ by only one
instruction for each workload. Every raw CSV, stdout/stderr and emitted object
is retained. These are whole-process user instruction counts, not isolated
kernel or source-loop instruction estimates.

## Reproduction and raw disposition

`whole.sh` records the full SQLite flags and invokes the existing original C
`samples`/`cohort` helpers for the 21-pair fresh-process campaigns.
`instructions.sh` records the nine-pair counter commands. The workload table
comes from the original `generate_table.c`; the pinned SQLite/header corpus is
an external runtime input, identified by hashes, rather than incorporated
source. Existing corpus licensing/provenance remains applicable.

All timing objects, counter objects, per-process records, counters, complete
stderr, helpers, build identities and source input are retained in the raw
release asset described by `RAW-ARTIFACT.md`. Public text copies and their
digests accompany this report.

The first packaging attempt completed all 360 object comparisons, then failed
because the target lacks `rg`. Its stderr and empty output are retained. The
successful fallback uses `find` solely to enumerate object hashes. Both
attempts, all hashing and compression ran inside `exclusive.sh`; no measurement
sample was dropped or replaced. Earlier local screen timing is explicitly
unqualified (five shared-host rounds, overlapping ranges, approximately 1.9%
median difference). No experiment beyond this one candidate was tuned.
