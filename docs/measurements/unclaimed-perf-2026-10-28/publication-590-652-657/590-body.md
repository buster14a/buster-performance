Empty, data-only and fully dropped-static-function units now avoid initializing the encoder, operand-semantics, Tier 0 and unwind tables. Data and symbol publication and failure rollback still execute. A reusable caller initializes the backend before its first selected function reaches the workers.

Adds an isolated cold/warm regression covering both checking paths, dropped builtin-helper bodies, source rows, unwind, requested lanes, resource failure, and later body emission. Cold data objects must equal their warmed counterparts.

Local validation of this head on main `321f5976`, including the newly merged encoder changes:

- Release build: all 41 translation units passed.
- `test-check-lanes --seed 590 --programs 1`: 2,295 checks, zero failures, including 150 cold/reuse startup checks.
- Driver: 21,648 checks, zero failures.

[Frozen 9700X evidence](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-590/target) compares `bc1b4861` with `8b815992`: empty backend setup falls from 0.600 to 0.000 ms at the recorded precision under the default page policy, and 0.908 to 0.000 ms with THP disabled per process. That control did not change the host to `madvise`. Function-bearing controls remain neutral and TCC remains faster on the tiny inputs. These historical timings predate this PR head; current-head CI qualification is separate.

Addresses the no-selected-body startup portion of #590. Table snapshot/layout work remains separate.
