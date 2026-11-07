/home/david/buster-fast-bench/777-claude-cloud/tmain/build/compiler time-runs --executable /bin/sh --runs 11 "$@" > runs.log 2>&1
echo time-runs status $?
bash stages.sh > stages.raw 2>&1
echo stages status $?
