# Publication of issue 647

Draft PR: https://github.com/buster14a/buster/pull/686

Base main: `321f5976d5af2b4c54fa45a639895739f2b8a8c9`.
Publication branch: `codex/publish-perf-647`.
Head: `b645da36951e15d7e4fbad6c5b800618e5e164d4`.
Built production merge: `b9e061467bff4df6810ce0b62f1d5e1f7c7021f8`.
Later changes are evidence-link documentation and workflow if-gates only.
Frozen issue-647 and next-main remain untouched.

Each build/test used a separate `cores -n 2` grant with owner/title/issue link.
Build/tests unset CPATH and C_INCLUDE_PATH; build disables debug info.

- `./build.sh`: 41 units, pass; image SHA-256 in compiler.sha256.
- `./build/compiler test-streaming --units 8`: 188 checks, zero failed.
- `bash ../evidence-publish-647/workflow-step.sh`: real extracted workflow
  script, 100 units/32 functions/five runs, all five variants pass exact-byte
  and executable oracles, on two distinct allowed physical cores (6,7).
- A separate inherited-one-CPU `taskset` invocation requesting eight lanes
  selects one; writer and parallel-direct rows print not run.
- `./build/compiler test-x86-target-selection`: all baseline/v3/v4 policy,
  native-record and exact-twin checks pass, including merged421's complete
  default64 segment-template check.
- `BUSTER_DEBUG_INFO=0 ./build.sh check-call-graph`: 41 units, 25,383
  functions, 150,852 calls, zero cycles beyond three existing allowed,
  zero split variables.
- Original selector self-test failed six checks because both split steps
  retained all three benchmark names in their gates. Its raw log is retained
  as selector.log. Publication-only commitb645da36 narrows the backend step
  to backend/unwind and the streaming step to streaming. The rerun in
  selector-corrected.log passes 1,133 checks, zero failures. No compiler
  rebuild was needed for two workflow condition lines.
- `git diff --check 321f5976 HEAD`: pass; worktree clean at publication.

Compiler/test patch stable ID matches frozenb197:
`dc6c1afc3cf5afff05a728222a5ae749d299281d`. The extracted workflow shell
matches the frozen validated shell exactly and passes bash syntax checks.
The main.c merge preserves both streaming tests and merged421 ISA policy
registrations/table ownership.

Frozen target evidence remains b197 vs416 controls. It qualifies corrected
benchmark configuration and makes no compiler speedup claim. No new target
run here. CI at handoff: 9700X run40704296773 queued; storage run40704296800
completed successfully. Artifact attached immediately; no merge/force push/
issue comment.

PR-BODY.md is the exact published description. Source identity, raw logs and
the initial failed selector are preserved beside it.
