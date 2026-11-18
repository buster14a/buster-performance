#!/bin/bash
# perf10.sh LABEL...: the front with the window on sqlite3.c (--front-window) under perf stat, CPU 2, a hold of the lock
# a build, three runs: the branch predictor's redirects by cause, the op cache's misses, the decoder's ops.
cd "$(dirname "$0")"
. ./corpora.sh
for label in "$@"; do
    out=$PWD/results/$label
    for n in 1 2 3; do
        ./lock.sh bash -c "perf stat -x, -e cycles:u,bp_redirects.resync:u,bp_redirects.ex_redir:u,bp_de_redirect:u,op_cache_hit_miss.op_cache_miss:u,de_src_op_disp.x86_decoder:u -o $out/perf10-stat-$n.txt -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > $out/perf10-run.txt 2>&1; echo status \$? >> $out/perf10-run.txt"
        echo "$label $n: $(grep -v '^#' $out/perf10-stat-$n.txt | cut -d, -f1,3 | tr '\n' ' ') front $(grep -o 'the front with the window: ticks=[0-9]*' $out/perf10-run.txt | grep -o '[0-9]*$')"
    done
done
echo perf10 done
