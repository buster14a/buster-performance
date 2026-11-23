#!/bin/bash
# job-bodies4.sh: the compile that takes bodies (06681bbdb, main merged in). The same binary with --node-bodies against
# without, paired, on the frozen sqlite3.c (the objects and the diagnostics one set); the option off against the commit of
# main it stands on (89362fd0f); then the other three workloads the same. Release, CPU 2, each run under the lock. A build
# that leaves no compiler stops the job.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
cd "$dir"
git -C src fetch -q origin
for rev in 06681bbdb 89362fd0f; do
    ./setup.sh $rev || { echo "setup failed: $rev"; exit 1; }
    [[ -x trees/$rev/build/compiler ]] || { echo "no compiler: $rev"; tail -3 trees/$rev-build.log; exit 1; }
done
df -h /home | tail -1
./pair2.sh 06681bbdb 06681bbdb sqlite 7 "--node-bodies" && python3 reduce2.py results/pair2-sqlite-06681bbdb-06681bbdb-__node_bodies > results/pair2-sqlite-06681bbdb-06681bbdb-__node_bodies/summary.txt
echo sqlite-option-complete
./pair2.sh 89362fd0f 06681bbdb sqlite 7 && python3 reduce2.py results/pair2-sqlite-89362fd0f-06681bbdb > results/pair2-sqlite-89362fd0f-06681bbdb/summary.txt
echo sqlite-off-complete
for w in lua musl main; do
    ./pair2.sh 06681bbdb 06681bbdb $w 5 "--node-bodies" && python3 reduce2.py results/pair2-$w-06681bbdb-06681bbdb-__node_bodies > results/pair2-$w-06681bbdb-06681bbdb-__node_bodies/summary.txt
done
echo option-complete
for w in main lua musl; do
    ./pair2.sh 89362fd0f 06681bbdb $w 5 && python3 reduce2.py results/pair2-$w-89362fd0f-06681bbdb > results/pair2-$w-89362fd0f-06681bbdb/summary.txt
done
echo job-complete
