#!/bin/bash
# bound.sh REV ROUNDS VARIANT...: --time-stages of -c bound/v-VARIANT.i, one lane on CPU 2, each run under the lock, the
# variants in a rotating order.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
rev=$1; rounds=$2; shift 2
variants=("$@")
cc="$dir/trees/$rev/build/compiler"
out="$dir/results/bound-$rev"
rm -rf "$out"; mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: the flip's bound, stage times of reduced sources" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
count=${#variants[@]}
for i in $(seq 1 "$rounds"); do
    for j in $(seq 0 $((count - 1))); do
        v=${variants[$(( (i + j) % count ))]}
        "$HOME/buster-fast-bench/exclusive.sh" bash -c "
            cat /proc/loadavg > '$out/$v-$i.load'
            taskset -c 2 '$cc' --lanes 1 -c '$dir/bound/v-$v.i' -o '$out/x.o' > /dev/null 2>&1
            taskset -c 2 '$cc' --lanes 1 -c '$dir/bound/v-$v.i' -o '$out/x.o' --time-stages 2> '$out/$v-$i.stages'
            sha256sum < '$out/x.o' | cut -c1-16 > '$out/$v-$i.sha'
            rm -f '$out/x.o'
        " 2>> "$out/lock.log"
    done
done
echo done > "$out/complete"
