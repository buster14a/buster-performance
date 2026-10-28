# Completed const initializers: recovered exact-head correctness receipts

This record preserves the completed local qualification of
[Buster PR #738](https://github.com/buster14a/buster/pull/738), issue
[#704](https://github.com/buster14a/buster/issues/704), at source
[`599c03ed63d9f50a3dfa75d240f08432371bef41`](https://github.com/buster14a/buster/commit/599c03ed63d9f50a3dfa75d240f08432371bef41).
The original worker completed both sanitizer builds before its parent chat
stopped. The takeover session replayed those existing binaries on October 28,
2026. Publication added no compiler change or new test campaign.

| Existing adapter | Checks | Failures | Exit | Sanitizers |
| --- | ---: | ---: | ---: | --- |
| Native host | 14,410 | 0 | 0 | AddressSanitizer, UndefinedBehaviorSanitizer, leak detection |
| Baseline x86-64 host | 14,410 | 0 | 0 | AddressSanitizer, UndefinedBehaviorSanitizer, leak detection |

The adapter calls `check_test_const_values`, `check_test_const_sources`,
`check_test_const_alias_sources`, `check_test_const_programs`,
`check_test_driver_const`, and `check_test_driver_recovery`. These cover the
const source/value/alias controls, emitted effect programs, the 46 GNU driver
fixtures, and the inherited diagnostic recovery/return matrix. The headline
count is the adapter's complete assertion count, not a number of distinct C
programs. See the retained [adapter](adapter/const-focused-sanitize.c) and
[native](logs/native.log)/[baseline](logs/baseline.log) result lines.

## Source, tool and executable identities

- Source commit: `599c03ed63d9f50a3dfa75d240f08432371bef41`.
- Source tree: `086cc7a52776d03e9fb8f2aecf1c38184d5d587a`.
- `git archive --format=tar` of that commit, SHA-256:
  `e97213392eac7e5666b1fe4dc657857cdac50e2187952d2d4343659d35a6f0a3`.
- Native executable, SHA-256:
  `7e2ae027b1fa1b78524a7ff72e267cf2c7f6456cb2756fd36499ce68a1623a66`.
- Baseline executable, SHA-256:
  `0133efdf8354b4f01558d0ac074ce9587f55db25883d1c1a0e84fa0e051460fd`.
- Installed compiler reports Clang 23.1.4, target `x86_64-pc-linux-gnu`;
  `/usr/bin/clang` SHA-256 is
  `b53890006355553d68159ddeafd47586f74d9bf8febee4132763fa0ec84e3b44`.
- Local execution host: AMD Ryzen 9 7940HS, Linux/x86-64. This is separate
  from the approved Ryzen 7 9700X's qualification.

The archived source snapshot's entire `src/` tree compared byte-identical
with a clean checkout of the recorded commit using `git diff --no-index`.
The adapter generator changes the unity entry/linkage wrapper; it leaves
included compiler module bodies unchanged. [commands.txt](commands.txt)
records the original generation/build and takeover replay commands.
[identity/](identity/) retains source, binary, tool, host and original-log
digests. Host/tool identity files were captured during publication after the
replay; original build tool provenance is its recorded Clang 23.1.4 invocation.

The two large sanitizer executables remain in the original local qualification
directory and are omitted here. Their hashes identify the exact binaries run.
A different source location or toolchain can change debug/build bytes;
reproduction is not a promise of bit-identical rebuilt executables.

## Integration boundary and next action

At publication, genuine [CI run 40774446921](https://github.com/buster14a/buster/actions/runs/40774446921)
passed both hosted correctness jobs at `599c03ed`; its Benchpress job was
queued. The retained [CI snapshot](identity/pr738-checks.json) is a point-in-time
status record, not a hardware pass. Full CI and this focused local adapter are
separate evidence.

The unresolved source-review item is the initializer-liveness lookup finding.
Reviewer [PR #746](https://github.com/buster14a/buster/pull/746), head
`85d2a8360cc6bf31cba08f6a799549b2cd2705b0`, is a clean descendant of `599c03ed`.
Its only feature changes are in `c_check_init_live.c` and
`c_check_const_values_test.c`; its own exact-head CI is separate. The next
action is reviewer/coordinator adoption and qualification of that correction,
then integration after the frozen warning foundation #737. These receipts
qualify `599c03ed` only; they do not qualify #746, a later merge, full issue
closure, or merge readiness. No performance measurement or speedup is claimed.

## Retention and provenance

Only `cores:` scheduler lines were removed from published logs, excluding
other sessions' queue metadata. The compiler's result lines are unchanged.
The original complete logs remain local with their hashes in
[original-logs.sha256](identity/original-logs.sha256). The original build logs
contain scheduler records; they are represented by hashes and their commands,
not republished as another session's metadata.

The original C wrapper, generator and retained project main prefix use
Apache-2.0 WITH LLVM-exception; their notices are retained. See
[PROVENANCE.md](PROVENANCE.md). Clang and system headers/runtime remain
external dependencies. No external compiler implementation, corpus, package,
large executable, or unrelated session file is imported.
