#!/bin/bash
# lg-ab.sh again with the branch's working tree (main's build kept): sync and build the branch under its own hold of
# the lock, then the benchmarks and the whole-process runs, alternating main and branch.
set -e
S=/tmp/claude-1000/-home-david-dev-ai-claude-buster--claude-worktrees-solve-133-136-137-145-775974/eeffc3cb-c596-444b-a0d3-1714d48ec3d1/scratchpad
filter() { grep -v "^exclusive.sh: waiting\|^  title:\|^  link:\|^  pull request:"; }
timeout 300 tailscale ssh david@benchpress 'cd ~/buster-fast-bench && for d in libgcc-136-main libgcc-136-claude; do mkdir -p $d/run1; mv $d/snapshot-*.log $d/link-*.log $d/proc-*.log $d/run1/ 2>/dev/null || true; done; rm -rf libgcc-136-claude/src libgcc-136-claude/tests libgcc-136-claude/build.sh'
(cd $S/libgcc && tar cf - build.sh src tests) | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/libgcc-136-claude'
timeout 1800 tailscale ssh david@benchpress "cd ~/buster-fast-bench/libgcc-136-claude && EXCLUSIVE_OWNER=claude-libgcc-136 EXCLUSIVE_TITLE='Solve 133 136 137 145' EXCLUSIVE_LINK='https://github.com/buster14a/buster/pull/483' BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; status=\$?; tail -1 build.log; echo \"build status \$status\"" 2>&1 | filter
timeout 3500 tailscale ssh david@benchpress '~/buster-fast-bench/libgcc-bench.sh' 2>&1 | filter
timeout 3500 tailscale ssh david@benchpress '~/buster-fast-bench/libgcc-proc.sh' 2>&1 | filter | grep "^==\|^list"
