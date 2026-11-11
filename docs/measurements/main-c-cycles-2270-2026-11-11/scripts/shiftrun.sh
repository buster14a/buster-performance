#!/usr/bin/env bash
# Arena shifts (BUSTER_ARENA_SHIFT seeds, arena-shift.patch) of base-s and head-s: perf stat of main.c -c on CPU 2, every
# seed of both builds, interleaved, one round per call (run under the lock by campaign.sh). Usage: shiftrun.sh OUT ROUND SEED...
set -u
W=$HOME/buster-fast-bench/2270-claude; TMPDIR=$W/tmp
out=$1; r=$2; shift 2
seeds=("$@")
src=$W/head/src
args=(-c -march=native -I"$src" -fwrapv -funsigned-char "$src/buster/compiler/main.c" -o /dev/null)
ev="cycles:u,instructions:u,ic_tag_hit_miss.instruction_cache_miss:u,de_no_dispatch_per_slot.no_ops_from_frontend:u,ls_bad_status2.stli_other:u"
order=("${seeds[@]}"); if (( r % 2 == 0 )); then order=($(printf '%s\n' "${seeds[@]}" | tac)); fi
for s in "${order[@]}"; do
  builds=(base head); if (( (r + s) % 2 == 1 )); then builds=(head base); fi
  for b in "${builds[@]}"; do
    tmp=$TMPDIR/shift.$$
    BUSTER_ARENA_SHIFT=$s perf stat -x, -o "$tmp" -e "$ev" taskset -c 2 "$W/$b-s/build/compiler" "${args[@]}" > /dev/null 2>&1 || echo "fail $b $s" >&2
    grep -v '^#' "$tmp" | grep . | awk -F, -v n="$b" -v r="$r" -v s="$s" '{print r"\t"s"\t"n"\t"$3"\t"$1}' >> "$out"
  done
done
