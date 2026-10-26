#!/bin/bash
# The 9700X A/B for #483's review: main (origin/main, the branch's merge base) and the libgcc branch's head, each tree
# synced and built under its own hold of the lock, then the benchmarks (lg-bench-remote.sh) and the whole-process runs
# (lg-proc.sh), alternating main and branch, each run its own hold.
set -e
S=/tmp/claude-1000/-home-david-dev-ai-claude-buster--claude-worktrees-solve-133-136-137-145-775974/eeffc3cb-c596-444b-a0d3-1714d48ec3d1/scratchpad
filter() { grep -v "^exclusive.sh: waiting\|^  title:\|^  link:\|^  pull request:"; }
timeout 300 tailscale ssh david@benchpress 'cd ~/buster-fast-bench && for d in libgcc-136-main libgcc-136-claude; do mkdir -p $d/before-closure; mv $d/*.log $d/before-closure/ 2>/dev/null || true; rm -rf $d/src $d/tests $d/build.sh; done'
git -C $S/libgcc archive origin/main build.sh src tests | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/libgcc-136-main'
(cd $S/libgcc && git archive HEAD build.sh src tests) | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/libgcc-136-claude'
echo "main $(git -C $S/libgcc rev-parse --short origin/main), branch $(git -C $S/libgcc rev-parse --short HEAD)"
for d in libgcc-136-main libgcc-136-claude; do
    timeout 1800 tailscale ssh david@benchpress "cd ~/buster-fast-bench/$d && EXCLUSIVE_OWNER=claude-libgcc-136 EXCLUSIVE_TITLE='Solve 133 136 137 145' EXCLUSIVE_LINK='https://github.com/buster14a/buster/pull/483' BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; status=\$?; tail -1 build.log; echo \"$d build status \$status\"" 2>&1 | filter
done
cat $S/lg-bench-remote.sh | timeout 300 tailscale ssh david@benchpress 'cat > ~/buster-fast-bench/libgcc-bench.sh && chmod +x ~/buster-fast-bench/libgcc-bench.sh'
cat $S/lg-proc.sh | timeout 300 tailscale ssh david@benchpress 'cat > ~/buster-fast-bench/libgcc-proc.sh && chmod +x ~/buster-fast-bench/libgcc-proc.sh'
timeout 3500 tailscale ssh david@benchpress '~/buster-fast-bench/libgcc-bench.sh' 2>&1 | filter
timeout 3500 tailscale ssh david@benchpress '~/buster-fast-bench/libgcc-proc.sh' 2>&1 | filter
