# #450 delivery handoff

Pushed only `codex/450-one-lane-dispatch`, fast-forwarding the remote
`9de3d30b` branch to submitted head
`00a63096f77f435fcf59ad8b531a12bd997e2f30`.
`git ls-remote` independently returns that exact remote ref. Push used
`git -c pack.threads=1`; no force push or other ref was sent.

Measured candidate remains an ancestor at
`1d2b12c658807f466b989bcdfe2cdf548c1812d5`. The local delivery ref was
verified an ancestor before being fast-forwarded to that measured commit.
The final commit changes ONLY AGENTS.md and docs/c-deferred-bodies.md.
`git diff --exit-code 1d2b12c6 HEAD -- src build.sh .github tools` passes.

Identical measured/submitted tree and blob identities:

| Path | Git object |
| --- | --- |
| src | `57e099eb8f46956cbaa6a52f789ee06a404cd4c0` |
| tools | `3998ccec75145e5fde4f46bc2db248be4f688a04` |
| .github | `9e24c4239974306b1ec627667c56c888172a5077` |
| build.sh | `9909122edfe1459305d8dc0efabd49805939f025` |

The complete diff against exact baseline35 has exactly five paths: AGENTS,
deferred guide, corpus test harness, deferred checker and deferred tests.
No C/test/build/CI change was made after qualification. `git diff --check`
passes and `git status --porcelain` is empty.

Authentic existing opt-in was present as `BUSTER_DCO_SIGN_OFF=davidgmbb`;
it was not set or changed for this operation. Existing `.githooks` appended
`Signed-off-by: David Gonzalez Martin <davidgmbb@gmail.com>` to the final
documentation commit, matching the existing author/committer identity.

The tracked guide now links immutable accepted evidence at
`1294f0afc4f39db0d98630018e9808fde4c44ea3` and removes only the completed
one-lane-pinning item from What is left. Arena/costliest-part follow-ups and
all adverse measurement observations remain.

Final PR title/body: `.git/PR450-cold.md`, SHA-256
`a4b996eb68d401a61fc2f8e160c54a51f1acf8aef57451f68d514b4c05853c1c`.
Root owns PR creation/attachment/review and submitted-head integration CI.
No PR or merge was created here; no extra build, test or native command ran.
