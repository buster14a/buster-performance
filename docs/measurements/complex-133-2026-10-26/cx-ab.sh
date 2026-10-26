#!/bin/bash
# The 9700X A/B of the _Complex lowering (#133): main and the branch, each tree synced and built under its own hold of
# the lock, then sqlite3.c compiled with -c as whole processes (time-runs, 21 runs after 3 warm-ups), main's and the
# branch's in turn, two rounds, each run its own hold.
set -e
S=/tmp/claude-1000/-home-david-dev-ai-claude-buster--claude-worktrees-solve-133-136-137-145-775974/eeffc3cb-c596-444b-a0d3-1714d48ec3d1/scratchpad
filter() { grep -v "^exclusive.sh: waiting\|^  title:\|^  link:\|^  pull request:"; }
timeout 300 tailscale ssh david@benchpress 'cd ~/buster-fast-bench && for d in complex-133-main complex-133-claude; do mkdir -p $d && rm -rf $d/src $d/tests $d/build.sh; done'
git -C $S/cx archive origin/main build.sh src tests | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/complex-133-main'
git -C $S/cx archive HEAD build.sh src tests | timeout 300 tailscale ssh david@benchpress 'tar xf - -C ~/buster-fast-bench/complex-133-claude'
echo "main $(git -C $S/cx rev-parse --short origin/main), branch $(git -C $S/cx rev-parse --short HEAD)"
for d in complex-133-main complex-133-claude; do
    timeout 1800 tailscale ssh david@benchpress "cd ~/buster-fast-bench/$d && EXCLUSIVE_OWNER=claude-complex-133 EXCLUSIVE_TITLE='Solve 133 136 137 145' EXCLUSIVE_LINK='https://github.com/buster14a/buster/issues/133' BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; status=\$?; tail -1 build.log; echo \"$d build status \$status\"" 2>&1 | filter
done
cat > /tmp/claude-1000/lgt/complex-proc.sh <<'EOS'
#!/bin/bash
export EXCLUSIVE_OWNER=claude-complex-133 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/133"
X=~/buster-fast-bench/exclusive.sh
B=~/buster-fast-bench
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
for round in 1 2; do
    for d in complex-133-main complex-133-claude; do
        cd $B/$d || exit 1
        $X taskset -c 2 ./build/compiler time-runs --runs 21 --warmups 3 --list -c -I$Q -o $B/$d/sqlite3.o $Q/sqlite3.c > sqlite-$round.log 2>&1
        echo "== $d $round: $?"; grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:" sqlite-$round.log | grep "^list"
    done
done
EOS
cat /tmp/claude-1000/lgt/complex-proc.sh | timeout 300 tailscale ssh david@benchpress 'cat > ~/buster-fast-bench/complex-proc.sh && chmod +x ~/buster-fast-bench/complex-proc.sh'
timeout 3500 tailscale ssh david@benchpress '~/buster-fast-bench/complex-proc.sh' 2>&1 | filter
