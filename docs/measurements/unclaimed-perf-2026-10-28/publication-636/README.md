# Publication of issue 636

Draft PR: https://github.com/buster14a/buster/pull/684

Base main: `321f5976d5af2b4c54fa45a639895739f2b8a8c9`.
Publication branch: `codex/publish-perf-636`.
Head: `600262cbfac4a0917eea751d9b5c2ee9c14ee3b0`.
Built production source: `43b92c1298ff0acac02e2688f49661976c79599c`.
The later commit changes documentation only. Frozen issue-636 is untouched.

All tests/builds used separate `cores -n 2` grants, with owner, title and issue
link. Build/tests unset CPATH and C_INCLUDE_PATH; build disables debug info.

- `./build.sh`: 41 units, pass; image SHA-256 in compiler.sha256.
- `./build/compiler test-preprocessor --clang --jobs 2`: pass, 90 diagnostic
  buffer cases and 3,000 Clang fuzz cases with no differences/missing results.
- `./build/compiler test-checker-driver --executable ./build/compiler`:
  21,648 checks, zero failures.
- `cc -std=c17 -O2 -Wall -Wextra -Werror -o ../evidence-publish-636/changes
  tools/ci/changes.c`, then that selector's `--self-test`: 1,131 checks,
  zero failures.
- `git diff --check 321f5976 HEAD`: pass; worktree clean at publication.

The source patch's stable ID, excluding documentation, matches frozen60ff:
`28d0158fd61c6941ecb983fb7e07d486648d53c7`. Diagnostic history blob
`e281aeda24781ce0d301d515e4ca7e01f98b5197` equals frozen60ff and validated
integratedd3. Latestmain's main.c target-table sharing and encoder changes do
not overlap the diagnostic adapter or renderer.

All native timings in the immutable linked record remain for frozen60ff vs
bc1b4861. No new target run was made. CI at handoff: measurement-storage pass;
9700X run40704076635 queued. PR creation was immediately followed by artifact
attachment. No merge, force push or issue comment was made.

PR-BODY.md is the exact published description. Logs, executable/source
identities, commits and selected paths are retained beside this document.
