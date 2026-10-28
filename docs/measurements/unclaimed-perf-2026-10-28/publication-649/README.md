# Publication of issue 649

Draft PR: https://github.com/buster14a/buster/pull/685

Base main: `321f5976d5af2b4c54fa45a639895739f2b8a8c9`.
Publication branch: `codex/publish-perf-649`.
Head: `927c46e15cea9b95a5e2cb6c9119aaa04ce40d31`.
Built production source: `09f4cd183092a13a5fdaaec34c7c612322775502`.
The later commit changes documentation only. Frozen issue-649 is untouched.

Separate `cores -n 2` grants with owner/title/link were used. Build/tests unset
CPATH and C_INCLUDE_PATH; build disables debug info.

- `./build.sh`: 41 units, pass; image SHA-256 in compiler.sha256.
- `./build/compiler test-preprocessor --clang --jobs 2`: pass, 325 protected
  prefix batches, every pragma alignment, >1 MiB rollover, marker/fallback
  bytes, long/splice/UCN/trigraph/embed fixtures, and 3,000 Clang fuzz cases
  with no differences/missing results.
- `cc -std=c17 -O2 -Wall -Wextra -Werror -o ../evidence-publish-649/changes
  tools/ci/changes.c`, then that selector's `--self-test`: 1,131 checks,
  zero failures.
- `git diff --check 321f5976 HEAD`: pass; worktree clean at publication.

The compiler/test patch's stable ID matches frozen123d:
`6795184a453423b3e8e352d0841140db192db2f4`. The full offsets/vector-printer
span through the next macro-ordering comment has SHA-256
`7d4ef84711e84f20d6d0ed801d69e7c854dff3124228aeb9e12f26b119e95a22`,
identical to validatedd3. Latestmain main.c target-table sharing/encoder
changes do not overlap preprocessing/printing. PR678's scalar shim companion
is pending separately; no shim or remote PR678 change was made here.

Measurements remain frozen123d vsbc1b4861, limited to -E -P, with the original
interference exclusions retained. No new target run. CI at handoff:
storage pass; 9700X run40704182222 queued. Artifact attached immediately after
creation; no merge, force push or issue comment.

The PR deliberately addresses the prefix-offset slice; spelling and source-run
compaction remain future work. PR-BODY.md is the exact published description.
