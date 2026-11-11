#!/usr/bin/env bash
# perf stat (5 hardware events, no multiplexing) of main.c -c on CPU 2 over the checker-offset builds of base and head,
# one round per call (run under the lock by campaign2.sh). Usage: offstat.sh OUT ROUND
set -u
W=$HOME/buster-fast-bench/2270-claude; TMPDIR=$W/tmp
out=$1; r=$2
src=$W/head/src
args=(-c -march=native -I"$src" -fwrapv -funsigned-char "$src/buster/compiler/main.c" -o /dev/null)
ev="cycles:u,instructions:u,ic_tag_hit_miss.instruction_cache_miss:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,de_no_dispatch_per_slot.backend_stalls:u"
offs=(0 16 32 48 1040 2080 3120 4032); if (( r % 2 == 0 )); then offs=($(printf '%s\n' "${offs[@]}" | tac)); fi
for n in "${offs[@]}"; do
  builds=(base head); if (( (r + n / 16) % 2 == 1 )); then builds=(head base); fi
  for b in "${builds[@]}"; do
    tmp=$TMPDIR/off.$$
    perf stat -x, -o "$tmp" -e "$ev" taskset -c 2 "$W/offsets/$b/compiler-$n" "${args[@]}" > /dev/null 2>&1 || echo "fail $b $n" >&2
    grep -v '^#' "$tmp" | grep . | awk -F, -v n="$b" -v r="$r" -v s="$n" '{print r"\t"s"\t"n"\t"$3"\t"$1"\t"$5}' >> "$out"
  done
done
