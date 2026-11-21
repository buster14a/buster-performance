#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-switch-3217-integrated"
mkdir -p readings
export BUSTER_HOST_ARCH=znver5
./build-label.sh before cb920fe57
./build-label.sh after 05dbff5f9f202376696572c37c9f8552bad5321d
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
source ./corpora.sh
for n in 1 2 3 4 5 6 7; do
 for v in before after; do
  cp --reflink=never "results/$v/compiler" "readings/compiler-$v-$n"
  cat "readings/compiler-$v-$n" >/dev/null
 done
 for c in sqlite lua musl compile; do
  corpus_name=$c; test "$c" != compile || corpus_name=sqlite
  key=${corpus_name}_arguments
  eval "args=(${!key})"
  k=0
  for v in before after after before; do
   k=$((k+1)); tag="$n-$c-$k-$v"; exe="$PWD/readings/compiler-$v-$n"
   if [ "$c" = compile ]; then
    task=(-c -o "$PWD/readings/$tag.o")
   else
    task=(measure-node-machine --shadow --passes 0 --window-rows)
   fi
   ./lock.sh taskset -c 2 perf stat -x ';' --no-big-num -e cycles,instructions,branch-misses -o "$PWD/readings/$tag.stat" -- "$exe" "${task[@]}" "${args[@]}" > "readings/$tag.out" 2>"readings/$tag.err"
   if [ "$c" = compile ]; then
    sha256sum "readings/$tag.o" >> readings/objects.sha256
    if [ "$k" -gt 1 ]; then cmp -s "readings/$n-$c-1-before.o" "readings/$tag.o"; fi
   fi
  done
 done
 rm -- "readings/compiler-before-$n" "readings/compiler-after-$n"
 echo "round $n complete" >> readings/progress
done
date -u +%FT%TZ > readings/done
