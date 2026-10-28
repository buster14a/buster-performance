# Publication qualification for #652

Base: 321f5976d5af2b4c54fa45a639895739f2b8a8c9.
Publication head: a08583d3ef27672309a9f3ee42f1212ba4cab69d.
Branch: codex/publish-perf-652.
Worktree: work/publish-652.

The cleanup-only 24e9c1f8 patch applies cleanly to this base. The six-file
change introduces terminal modes for the C/check and -E routes, retains
full cleanup in reusable wrappers, adds repeated successful/rejected-option
reuse tests and documents the frozen evidence. No lane.c prefix change,
#673 worker-budget code, rejected #653 code or #451 code is included.

All current-source checks use one local `cores -n 2` grant per invocation:

- `BUSTER_DEBUG_INFO=0 ./build.sh`: 41 units passed (108.2 s).
- `./build/compiler test-checker-driver --clang clang --executable ./build/compiler`:
  21,653 checks, zero failures, including new success/error reuse assertions.
- `./build/compiler test-parser --clang`: passed. Existing repeated driver
  coverage checks 17 cases / 272 runs and mapping/descriptor cleanup; failure
  sweeps cover 127 valid, 176 invalid, 176 warned, 177 warning/directive,
  164 preprocessing-warning and 165 preprocessing-warning/directive allocations.
- `BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph`: 41 translation units,
  25,389 functions, 150,886 calls; zero disallowed cycles, three existing
  allowed cycles, zero split variables.

The final binary hash is in build-compiler.sha256; source commit/tree IDs
are in source-identity.txt. Tracked source remained unchanged after the
release build; the later commit and PR-body work changed documentation only.
The fresh issue/comments were read before publication preparation: #652's
setup optimization remains open, so the PR body addresses only its release
at exit direction and does not auto-close the broader issue.

Frozen performance evidence is immutable at:
https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-652/target

Those historical 9700X timings compare bc1b4861 and 24e9c1f8, not this PR
head. No new performance timing, remote operation, push, PR creation or issue
comment was made by this preparer. Parent handles publication and attachment.
