#!/bin/bash
# Syncs main and the merged branch to the 9700X, builds each under its own hold of the lock, then runs be-proc4.sh.
set -e
W=/home/david/dev/ai/claude/buster/.claude/worktrees/solve-133-136-137-145-775974
S=/tmp/claude-1000/-home-david-dev-ai-claude-buster--claude-worktrees-solve-133-136-137-145-775974/eeffc3cb-c596-444b-a0d3-1714d48ec3d1/scratchpad
filter() { grep --line-buffered -v "^exclusive.sh: waiting\|^  title:\|^  link:\|^  pull request:"; }
timeout 300 tailscale ssh david@benchpress 'cd ~/buster-fast-bench && for t in backend-136-main backend-136-claude; do mkdir -p $t && rm -rf $t/src $t/tests $t/build.sh $t/build; done'
git -C $W archive origin/main build.sh src tests | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/backend-136-main'
git -C $W archive HEAD build.sh src tests | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/backend-136-claude'
echo "main $(git -C $W rev-parse --short origin/main), branch $(git -C $W rev-parse --short HEAD)"
for t in backend-136-main backend-136-claude; do
    timeout 1800 tailscale ssh david@benchpress "cd ~/buster-fast-bench/$t && EXCLUSIVE_OWNER=claude-backend-136 EXCLUSIVE_TITLE='Solve 133 136 137 145' EXCLUSIVE_LINK='https://github.com/buster14a/buster/issues/136' BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; status=\$?; tail -1 build.log; echo \"$t build status \$status\"" 2>&1 | filter
done
cat $S/be-proc4.sh | timeout 300 tailscale ssh david@benchpress 'cat > ~/buster-fast-bench/backend-136-proc4.sh && chmod +x ~/buster-fast-bench/backend-136-proc4.sh'
timeout 3500 tailscale ssh david@benchpress '~/buster-fast-bench/backend-136-proc4.sh' 2>&1 | filter
