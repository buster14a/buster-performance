# Issue 673 final report

Implementation: `1d076d6736df9b7350610ec646dc1fe1ef39f7dc` on
`codex/perf-673-spawn`, based on `b7681dcf67a337ca8205bf2201ca85e91f03cf42`
and baseline `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Doc-only follow-up: `30658d647bfaba8ec33d1fee676a0c853a274f02`.
The worktree is clean. No PR, push, GitHub comment or host setting change was made.

Native target compiler SHA256 is
`c1ff5c08fff9b360ccc4caa77fed24fc0c073549278402030b72e2b9edb4d72d`;
native baseline is
`d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d`.
Final rechecks match the original identities. SQLite source SHA256 is
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
pinned predefines are
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
The source implementation is unchanged after the measured commit; the follow-up
changes documentation only. The source and evidence helpers are original C.

## Behavior and correctness

`--worker-budget=N` includes the caller. GNU make FIFO and pipe authentication
is captured before ordinary compiler descriptor use, then extra credits are
acquired without waiting only after the existing emission profitability rule.
Inherited descriptor flags are untouched. A clean `posix_spawn` guardian owns
the exact bytes until the workers join; it isolates its session before ownership
and returns credits on normal completion, fallback, setup failure and parent
process-group termination. Credits are closed independently of terminal VM
teardown. Reusable command cleanup remains intact.

- Optimized standalone protocol, including no `_GNU_SOURCE`: 186 checks, zero failures.
- ASan/UBSan protocol: 186 checks, zero failures.
- Final local lanes/emission/diagnostic/dry-run regression: 2,720 checks, zero failures.
- Native target protocol: 186 checks, zero failures.
- Native target lanes/emission/diagnostic/fallback regression: 2,768 checks, zero failures.
- Local call graph: 41 units, 25,137 functions, 149,622 calls, zero disallowed cycles and split variables.
- Five real GNU make 4.4.1 ownership cases: FIFO, recursive pipe, closed pipe authentication,
  and sequential borrowing on each protocol. Each has 32 events and maximum ownership 4 of 4.
- Real GNU make `-n` plus recipe: success, no missing-source open in strace, no output created.
- Independent balanced-results reader accepts all real cases and rejects a forged predecessor.

The protocol includes exact opaque-byte return, zero/partial supply, caps, fd zero,
stale authentication numbers reused for unrelated IPC, capture followed by original
FD replacement, malformed/overridden words, escaped FIFO paths, packet pipes,
resource failure, ignored SIGCHLD, signal masks/handlers and SIGTERM/SIGKILL of
the compiler process group. A named parent mapping is absent in the guardian,
and parent private handles keep CLOEXEC.

## Target performance and bounds

All shared controls use physical CPUs 0–7. The 120-cohort matrix covers external
jobs 1/2/4/8 over baseline/head one/default/eight lanes, explicit cap one and real
GNU make budgets. Pinned-one controls are separate. Every output is identical;
the 960-entry manifest has only the SQLite object digest below. CPU/resource
variation, including base-one eight-job outliers, makes this characterization,
not an asserted baseline/head speedup. All counter events counted 100% of their
enabled interval. Physical DRAM traffic was not measured.

The superseded late fork added 1,549 faults and 1.28% wall time in an identical-
affinity eight-lane spare-credit control. The clean-launch same-head control
is 134.221 ms cooperative versus 134.277 ms without authentication, with overlapping
ranges, 4,912 versus 4,910 faults, and eight granted/active workers in all 26 outputs.
This establishes removal of the observed copy-on-write amplification.

The first mixed nine-list policy screen is retained and fenced: slot rotation
confounded predecessor workload with policy. Acceptance uses separate homogeneous
workloads, each held under one shared lock, a full-size primer and four nine-edge
cycles. Every ordered predecessor/current pair occurs four times. There are
108 measured cohorts plus three primers, all status zero and byte-identical.

| Eight-file workload | Jobserver (ms) | Cap one (ms) | Free eight (ms) |
| --- | ---: | ---: | ---: |
| Eight SQLite units | 408.827 | 408.011 | 428.449 |
| Eight tiny units | 8.766 | 9.101 | 9.323 |
| Two SQLite and six tiny | 180.681 | 177.824 | 172.410 |

Uniform large-file wall time falls 4.58% against free eight. Its median context
switches fall 325 to 105 and migrations 60 to 14; max RSS falls 557,058 to
518,278 KiB and minor faults 37,436 to 21,856. Tiny ranges overlap.
The uneven mix has a real 4.80% wall-time cost against free eight, with fewer
cycles/switches/migrations. Fixed seven-plus-one leases can leave spare capacity
idle after one team finishes; active-team resizing and profitability retuning
are deferred. This is an ownership feature with workload tradeoffs, not a
universal throughput/neutrality guarantee. Major faults are retained in every
summary. These are one-placement results.

## Byte and provenance receipts

`../evidence-673/target/clean-spawn-1d/` contains every raw matrix, balanced-policy,
exploratory-policy, spare-token, protocol/make/emission/dry-run record, exact method,
tool/input identity and object manifest. Generated matrix/policy objects remain
on target; all individual digests and comparison receipts are local. The local
spare-token collections additionally retain their actual identical objects.

- Matrix: 960 objects, all SQLite SHA256
  `cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`.
- Balanced policy: 888 objects, 370 SQLite and 518 tiny; tiny SHA256
  `80d4c323efc3c80bba94dd853dd6ad0bdbaab088e44214b352bec86ecd3c52de`.
- Fenced mixed policy: 936 objects, 390 SQLite and 546 tiny; the same two digests.
- Raw counters, major faults, all statuses and every worker receipt are retained.

`contamination-audit.txt` records all reported unlocked packaging windows.
No #673 timing overlaps them. Own two early compressed transfers were disclosed
with conservative extraction-derived windows; later exports and all final hashing
ran under the shared lock. No measured sample was discarded or silently replaced.

## Target recipe

From `~/buster-fast-bench/unclaimed-perf-20261028`, after staging the exact source
and compiling the retained original C helpers, run each workload as one bounded
group with a fresh OUTROOT (0 = uniform large, 1 = tiny, 2 = uneven):

```sh
EXCLUSIVE_OWNER=codex-unclaimed-perf \
EXCLUSIVE_TITLE='Issue 673 balanced real make workload 0' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/673 \
~/buster-fast-bench/exclusive.sh taskset -c 0-7 \
  ./issue673-spawn-1d/evidence-673-spawn/policy_balanced NEW_OUTROOT 0 \
  ./issue673-spawn-1d/issue-673-spawn/build/compiler \
  ./issue673-spawn-1d/evidence-673-spawn/compile-budget.mk \
  ./issue673-spawn-1d/evidence-673-spawn/usage_record
```

The C collector carries the exact frozen SQLite options and retains each command.
Protocol adapters expect source at sibling `issue-673-spawn/`. `matrix_stats.c`
and `policy_stats.c` generate the local TSV reports without timing any compiler.
