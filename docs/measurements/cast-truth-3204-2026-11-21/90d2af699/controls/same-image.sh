#!/usr/bin/env bash
# Run on benchpress from the existing #2850 benchmark directory, using one executable/inode
# for all four positions in each round. The launcher chooses the old or new function in it.
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-codex-step2"
source ./corpora.sh
label=${1:-sameimage}
rounds=${2:-7}
out="$PWD/results/$label"
compiler="$out/compiler"
test -x "$compiler"
exec 8>our-timing.lock
for ((n=1; n<=rounds; n++)); do
  flock -x 8
  image="$out/compiler-turn-same-$n"
  cp "$compiler" "$image"
  cat "$image" >/dev/null
  tags=(before1 after1 after2 before2)
  if (( n % 2 == 0 )); then tags=(after1 before1 before2 after2); fi
  for tag in "${tags[@]}"; do
    if [[ $tag == before* ]]; then choice='export BUSTER_DIAGNOSTIC_OLD_CAST_LOOP=1'; else choice='unset BUSTER_DIAGNOSTIC_OLD_CAST_LOOP'; fi
    ./lock.sh bash -c "$choice; head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy; taskset -c 2 \"$image\" measure-node-machine --shadow --passes 0 --window-rows $musl_arguments; status=\$?; echo status \$status; $busy; exit \$status" > "$out/$tag-musl-same-$n.txt" 2>&1
  done
  rm -f "$image"
  flock -u 8
done
