#!/bin/bash
# Syncs the jump tables' branch to the 9700X (main's tree, e04462c1, is backend-136-main from #514's last round),
# builds it under its own hold of the lock, then runs jt-proc.sh there.
set -e
W=/home/david/.cache/claude-worktrees/jump-tables-136
S=/tmp/claude-1000/-home-david-dev-ai-claude-buster--claude-worktrees-solve-133-136-137-145-775974/eeffc3cb-c596-444b-a0d3-1714d48ec3d1/scratchpad
filter() { grep --line-buffered -v "^exclusive.sh: waiting\|^  title:\|^  link:\|^  pull request:"; }
timeout 300 tailscale ssh david@benchpress 'mkdir -p ~/buster-fast-bench/jump-136-claude && cd ~/buster-fast-bench/jump-136-claude && rm -rf src tests build.sh build'
git -C $W archive HEAD build.sh src tests | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/jump-136-claude'
echo "main $(git -C $W rev-parse --short origin/main), branch $(git -C $W rev-parse --short HEAD)"
timeout 1800 tailscale ssh david@benchpress "cd ~/buster-fast-bench/jump-136-claude && EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE='Solve 133 136 137 145' EXCLUSIVE_LINK='https://github.com/buster14a/buster/issues/136' BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; status=\$?; tail -1 build.log; echo \"build status \$status\"" 2>&1 | filter
cat $S/jt-proc.sh | timeout 300 tailscale ssh david@benchpress 'cat > ~/buster-fast-bench/jump-136-proc.sh && chmod +x ~/buster-fast-bench/jump-136-proc.sh'
timeout 3500 tailscale ssh david@benchpress '~/buster-fast-bench/jump-136-proc.sh' 2>&1 | filter
