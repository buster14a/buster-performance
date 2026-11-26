# Deferred in-process arena-policy experiment

**Removed from the final PR despite passing correctness checks.** The
performance benefit was not established, and the change affects more than
resource-limit query counts. The final compiler head is
`e8746a798795c8e5e6702442a56f6d6ccc7a5b5d` (tree
`191d46ae8381b89d8d9107ed5d0752d75fd6c06d`), which restores these three files to
their baseline contents while retaining the independently justified file-test
work reuse and cost-table refresh.

[arena-policy.patch](arena-policy.patch) preserves the exact published diff from
baseline `8e4d32879e17b7d9548cad54257a2f8461328366` to historical candidate
`4d1f2024095f233cba19e8f8135dd99b17b9e264` in these files only:

- `src/buster/compiler/c_checker_driver_test.c`: snapshot live arena limits
  before each reusable command and restore the caller's policy afterward, under
  `#if !BUSTER_ARENA_REGIONS`.
- `src/buster/compiler/c_check_run_modes_driver_test.c`: 11 new assertions
  covering stale fixed/unfixed snapshots, fresh-child comparisons, acceptance,
  rejection, restoration and response-file fallback.
- `docs/commands/checker.md`: the corresponding behavior description.

The diff contains 75 added lines and no deletions. It was archived directly from
the two immutable commits; it was not reconstructed from the final checkout.

## Correctness evidence and its scope

The historical candidate's focused MSan run-mode test passed **79 checks with
zero failures**, compared with the baseline's existing 68 checks. The local
MSan driver `13/16` baseline/candidate/baseline sequence passed **15,316 checks
on every run**, with the same 305 of 5,438 selected units, 7,973 in-process
Buster commands, 1,792 Clang-server requests and 16 fallback children. All three
reported zero differences and clean sanitizer-report audits.

The historical candidate also passed the full unchanged hosted validation
workflow, [run 45788677912](https://github.com/buster14a/buster/actions/runs/45788677912),
covering all four existing vector configurations and their four shards. That
validation revision is `1145a859668a030945878fc7361c2e767fc97166`, whose only
change from the historical candidate is the temporary caller workflow; the
[source comparison](../../runtime/validation-source.json) preserves that proof.
These results validate the historical experiment's tested correctness. They
are not a performance result or a claim that the later final head was built by
that same run.

The guard avoids the plain allocator's persistent process-wide region, which a
later resource-limited child could inherit despite restoring the limit fields.
The reusable command joins its worker threads before return. Restoring the
snapshot after it returns preserves the caller's policy on both accepted and
rejected commands; the new focused controls exercise those boundaries. No
specific correctness failure was observed in the guarded experiment.

## Why correctness passing was insufficient

There is a structural opportunity to remove repeated `getrlimit(RLIMIT_AS)`
calls for reservations without a pool. However, pools already cache their
limits. Fixing all limits also reads commit policy once per command and enables
the existing unbounded-commit branch of `arena_commit`: the initial base-page
commit may reach 16 MiB, and later commits grow fourfold instead of the unfixed
64 KiB start and doubling policy. The branch uses `mprotect`; it does not
explicitly zero every newly writable physical page. Even so, its complete
kernel and sanitizer cost cannot be inferred from a smaller number of limit
queries. No syscall-count experiment was performed to establish the net work
removed, and the broader commit policy was not isolated from that query reuse.

The recorded local sequence demonstrates the timing ambiguity:

| Ordered replay | Wall | User | System | Clang-server wall |
| --- | ---: | ---: | ---: | ---: |
| Baseline A | 386.245 s | 171.795 s | 119.687 s | 27.943 s |
| Historical candidate B | 216.814 s | 123.169 s | 90.455 s | 17.758 s |
| Baseline A repeated | 187.586 s | 101.895 s | 83.680 s | 14.970 s |

The apparent 44% improvement against the first baseline disappears against the
repeat. Candidate elapsed time is 15.6% higher than the repeat and combined
user/system CPU is 15.1% higher, but unchanged Clang-oracle timings also shift;
these observations cannot isolate either a gain or a source regression. Small
tool builds also overlapped the candidate replay. The correct conclusion is
that a stable performance benefit was not demonstrated, not that the candidate
was proved faster or slower.

The complete artifact provenance, reproduction script, raw logs, audits and
excluded setup attempts are documented in [../../runtime/README.md](../../runtime/README.md).
No additional repetitions, syscall traces, compiler builds or hardware jobs
were started for this decision. The experiment remains archived for a future
isolated measurement; it is not part of the final PR.
