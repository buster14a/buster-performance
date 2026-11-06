#!/bin/bash
# usage: final.sh LABEL CONFIG... -- each CONFIG is NAME=COMPILER[,ENV=VALUE...]; -c of the frozen sqlite3.c on 1, 2, 4
# and 8 independent processes pinned one per physical core, 7 rounds with configs and worker counts rotating; each
# config's --time-stages on one, and the 8 processes' own --time-stages huge-pages decisions in a last round. Run under
# the lock.
cd ~/buster-fast-bench/672-claude
label=$1; shift
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
d=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" --lanes 1)
out=results/$label; mkdir -p $out
uname -r > $out/host.txt; cat /sys/kernel/mm/transparent_hugepage/enabled >> $out/host.txt; nproc --all >> $out/host.txt; getconf _NPROCESSORS_ONLN >> $out/host.txt
run() { # NAME CPU OUTPUT [EXTRA...]
  local cfg=$1 cpu=$2 o=$3; shift 3
  local spec=${CONFIGS[$cfg]}; local C=${spec%%,*}; local envs=""; [[ $spec == *,* ]] && envs=${spec#*,}
  IFS=, read -ra e <<< "$envs"
  env "${e[@]}" taskset -c $cpu $C "${d[@]}" "$@" -o $o
}
declare -A CONFIGS; names=()
for c in "$@"; do CONFIGS[${c%%=*}]=${c#*=}; names+=(${c%%=*}); done
for n in "${names[@]}"; do spec=${CONFIGS[$n]}; sha256sum ${spec%%,*} | sed "s/\$/ $n/" >> $out/identities.txt; done
for n in "${names[@]}"; do for r in 1 2 3; do run $n 2 $out/$n.o --time-stages 2> $out/stages-$n-$r.txt; done; done
for r in 1 2 3 4 5 6 7; do
  for n in "${names[@]}"; do
    for w in 1 8 2 4; do
      s=$(date +%s%N)
      for ((c = 0; c < w; c++)); do run $n $c $out/w-$n-$c.o 2> /dev/null & done
      wait
      t=$(date +%s%N)
      echo "round $r config $n workers $w wall_ns $((t-s))" >> $out/workers.txt
    done
  done
done
for n in "${names[@]}"; do
  for ((c = 0; c < 8; c++)); do run $n $c $out/w-$n-$c.o --time-stages 2> $out/decide-$n-$c.txt & done
  wait
done
sha256sum $out/*.o | awk '{print $1}' | sort | uniq -c > $out/objects-unique.txt
echo done >> $out/workers.txt
