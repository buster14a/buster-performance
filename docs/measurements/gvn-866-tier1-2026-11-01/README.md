# GVN in Tier 1's pipeline (#866), 2026-11-01

Measurement record for [buster14a/buster#866](https://github.com/buster14a/buster/issues/866)
and [PR #1020](https://github.com/buster14a/buster/pull/1020). #866's first two
Done-when items were closed by [#946](https://github.com/buster14a/buster/pull/946),
whose record is `gvn-866-2026-10-31`. This one covers the third: the pass's
compile-time and generated-code effects once the Tier 1 pipeline can exercise
it, and the independent corroboration of the other two on a second host.

## Trees and host

- Base: `main` at `f152e637`, the merge this PR is based on.
- Candidate: the PR head, `6b3f6d55` (plus the review follow-up, which changes
  only the option's plumbing, the arena's reservation and the tests; the pass
  itself and every figure here are the pass commit's).
- GVN pass: as merged in `b1c51527` (#946). This PR does not change it.
- Host: **Ryzen 9 7940HS** (Zen 4), 8 cores / 16 threads, Clang 23, wild
  linker, `BUSTER_DEBUG_INFO=0`. This is *not* the locked 9700X; the 9700X's
  compile-time pair has not been taken.
- Every run took the shared-core queue (`cores`, `CORES_TITLE`/`CORES_LINK`
  set); the queue lines are in the raw logs. Single runs were pinned with
  `taskset` where the log says so. The host runs other sessions' builds, so
  the wall-clock figures vary between runs; the instruction and byte counts do
  not.

## Synthetic and source-derived pass cost (corroboration)

`synthetic-ab.sh` builds two binaries from the same tree, one with the merged
grouping and one with the pre-#946 comparison sort, and times
`benchmark-ir-optimize-passes --pass gvn --instructions 4096 --samples 21` in
five processes each, both binaries alternating. Results are in the PR body and
the issue comment; the headline is vector `large-dag` 1,866,213 → 631,651 ns
(−66.2%) with the ratio to the scalar twin falling from 3.81× to 1.25× and the
removals unchanged (1,024 / 8 / 4 cyclic).

`benchmark-ir-source --only gvn` and `--only gvn-scalar` on a local
`sqlite3.c` (2,604 functions; the frozen file the CI uses has 2,602, so the
counts are not comparable across records):

```text
benchmark-ir-source: GVN removed 94465 instructions by gvn and 94465 by gvn-scalar;
  15030 refinement rounds, 3710330 key comparisons, 0 collision-budget sort completions

variant             ns/entry    cyc/entry    ins/entry     ns/instr    cyc/instr      IPC    thr/instr
gvn                   465.46      1929.68      5476.86       308.76      1280.04     2.84      175.717
gvn-scalar            290.39      1196.91      3529.79       192.63       793.96     2.95      108.985
```

The vector-to-scalar ratio (1.60×) matches the 9700X record's (1.61×), both
paths remove the same number of instructions, and no round exhausts the
collision budget.

## Tier 1's cost (`--tier1-gvn`)

`--tier1-gvn` runs `ir_optimize_gvn` on the lowered IR, before SSA promotion.
It is off by default; `--tier1` alone is unchanged, and `-c --tier1` of
`sqlite3.c` produces a byte-identical object with and without the option.

Compile time, `-c --tier1 -fno-asynchronous-unwind-tables sqlite3.c`, five
runs each, `tier1-cost.sh`. Two measurement runs on the shared host:

| Run | `--tier1` | `--tier1-gvn` | Change |
| --- | ---: | ---: | ---: |
| 1 | 525 ms (524–537) | 698 ms (689–701) | +33.0% |
| 2 | 751 ms (662–786) | 910 ms (895–924) | +21.2% |

The host is shared and run 2 overlapped other sessions' builds, so the change
is reported as a range (+21% to +33%) rather than a single figure. The
generated-code effect below is deterministic and does not vary.

Generated code, the same command, object read with `size`:

| | text | instructions | spill stores | spill reloads | edge moves |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c --tier1` | 1,283,627 B | — | — | — | — |
| `sqlite3.c --tier1-gvn` | 1,439,515 B (+12.1%) | — | — | — | — |
| c-testsuite `--tier1` | 347,912 B | 9,136 | 0 | 0 | 113 |
| c-testsuite `--tier1-gvn` | 343,624 B (−1.2%) | 10,402 (+13.9%) | 25 | 25 | 146 |

Tier 1's coverage is unchanged on both corpora: 2,155 of 2,604 functions on
`sqlite3.c`, 350 of 430 on c-testsuite, with no refusal at the optimization
step either way.

Two alternatives were measured and rejected: the pass after `ir_optimize`
rather than before promotion (text +15.8%, instructions +40% on `sqlite3.c`,
2.5× the spill traffic), and a cleanup pass after either placement (205,229
against 205,269 instructions, 0.02%, so dead values are not the cost; the merge
is).

Conclusion: merged class representatives lengthen live ranges across blocks, and
Tier 1's CFG allocation pays for that in edge moves and spills. The option stays
off, and routing C source through GVN by default waits for a variant that
accounts for allocation cost.

## The 9700X pair

The same commands on the approved Ryzen 7 9700X (Zen 5), head `fe3f3c79`, every
process taking the shared lock and pinned to CPU 2 (`tier1-cost-9700x.sh`,
`9700x.log`, `9700x-raw.log`):

| | text | compile time |
| --- | ---: | ---: |
| `sqlite3.c --tier1` | 1,440,195 B | 363 ms (median of four clean runs) |
| `sqlite3.c --tier1 --tier1-gvn` | 1,613,155 B (+12.0%) | 487 ms (+34.2%) |

The first base run's 243,805 ms is the wait for a CI job holding the lock and is
not a compile. Tier 1 compiles the same 2,171 of 2,604 functions either way;
the solver adds 51,212 instructions, 1,034 spill stores, 1,191 reloads and
4,990 edge moves. The byte totals are larger than the 7940HS run's because that
run is an earlier commit of the compiler; the relative changes agree (12.0%
against 12.1%, +34.2% against +33.0% and +21.2%).

## Behaviour

`behaviour.sh` compiles and runs c-testsuite's 220 programs both ways: 219
print the same output and exit with the same status under `--tier1-gvn` as
without it, 1 is skipped (it does not link through `cc` here), 0 differ.

`two-file-check.sh` is the review's reproduction of the option's contract with
several source files; the fixed driver reports `records=28` without the option
and `records=30` with it for the pair it uses, where the option was silently
dropped before the follow-up commit.

## Files

- `synthetic-ab.sh`, `tier1-cost.sh`, `tier1-cost-9700x.sh`, `behaviour.sh`,
  `two-file-check.sh` — the harnesses.
- `*.log` — their raw output, copied unedited.

## Provenance

Original harness use and measurements; no external code or data was imported.
The fixtures are the repository's, the corpora are c-testsuite's pinned commit
`5c72756` and a locally held `sqlite3.c`.
