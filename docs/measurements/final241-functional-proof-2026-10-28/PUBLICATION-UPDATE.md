# Coordinator-supplied publication snapshot

These facts were verified through GitHub by the coordinator and supplied during
curation on 2026-10-28. They update publication interpretation without modifying
any frozen payload. They are not new tests run by this evidence collector.

- [PR #678](https://github.com/buster14a/buster/pull/678), final head
  `4b2a8a6f51cf8dee5a5833a8f32138d865d780b8` with main-241 ancestry, merged
  upstream at 16:19:01 UTC via `12db4a0edd13a4ee319aa04467b910f3151a9290`.
  Its own hosted, Benchpress and aggregation checks all passed; the coordinator
  identifies [run 40718815405](https://github.com/buster14a/buster/actions/runs/40718815405).
  This is external qualification of that exact #678 source, not a new pass for
  the private twelve-slice union or every later public head. Root did not merge it.
- [PR #708](https://github.com/buster14a/buster/pull/708) was created at 16:29:56 UTC
  and closed **unmerged** at 16:32:36 UTC as superseded. A parallel coordinator had
  already published the same assertion on [PR #693](https://github.com/buster14a/buster/pull/693)
  at 16:29:07 UTC, head `31413e36b71d4ce8115a53645ada22c9166288b3`.
  The entire `c_check_asm_test.c` blob matches qualified private a076 and companion
  c27, with stable patch ID `7950ed0494128bf5ce9e9a2d6a7daecd310cc542`.
  Root verified the equivalence and closed redundant #708; root did not edit #693.
  Independent review comment 6474636045 reproduced the generic two-failure issue
  and reported corrected focused 425/0 checks on both hosts; review 5686161556
  cleared the source. Those external focused results are credited, not our reruns
  or a fresh full-suite claim at public 31413e36.
- The coordinator published the original `4349d8fd1a8b5be358669b89b08e80e38a68b7bc`
  at `codex/experiment-20261028-asm-control`, the separate test correction
  `a07682fe6c31cdf5329a7601d2074f907e407341` at
  `codex/qualification-20261028-final241`, and the separate focused composition
  `26364e88d61f34b3df635e24d85bed46a3333052` at
  `codex/qualification-20261028-702-compat`. Their positive and negative test
  scopes remain exactly those in the collected reports.

Earlier report snapshots remain historical: ce8 hosted native/baseline checks
were known to pass while its benchmark was queued; the original #702 native
job was queued and other PRs were refreshing. No current all-PR CI status,
benchmark success, new performance result or qualification of #665 is inferred.
