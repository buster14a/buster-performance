#!/bin/bash
# final.sh MAIN_TREE HEAD_TREE: #151's record of --deferred-bodies on the 9700X. Every compile runs under the host's lock
# (exclusive.sh, per command), on CPUs 0-7, one per core; the driver's default lanes are one per core.
#  1. time-runs, 21 runs in rotated order: sqlite3.c's -c, with -w and without, by HEAD with --no-deferred-bodies and with
#     --deferred-bodies; and 11 runs of MAIN against HEAD by default. Every object compared.
#  2. The lanes' sweep: --time-stages of sqlite3.c's -c -w by --lanes 1..8, with and without --deferred-bodies, 11 each.
#  3. benchmark-checker-deferred on sqlite3.c (the deferred reader's phases), lane 0 on CPU 2.
#  4. main.c's -c -w with and without --deferred-bodies, 3 each (its #pragma clang section sends it to source order).
#  5. A small unit's -c, time-runs of 41 runs, with and without --deferred-bodies.
#  6. perf's samples of lane 0's functions with --deferred-bodies on 8 lanes.
set -uo pipefail
base=~/buster-fast-bench/151-claude
main=$base/$1/build/compiler
head=$base/$2/build/compiler
out=$base/results/final-$(date +%Y%m%dT%H%M%S)
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-151 EXCLUSIVE_TITLE="GitHub issue #151" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/151
lock=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
o=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
{
  echo "main $(git -C $base/$1 rev-parse HEAD) $(git -C $base/$1 status --porcelain | wc -l) changed"
  echo "head $(git -C $base/$2 rev-parse HEAD) $(git -C $base/$2 status --porcelain | wc -l) changed"
  sha256sum "$main" "$head" "$sqlite/sqlite3.c"
  uname -srm; clang --version | head -1; nproc
  for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor)"; done
} > "$out/identity.txt" 2>&1
for w in -w ""; do
  tag=${w:-warnings}
  $lock taskset -c 0-7 $head time-runs --runs 21 --warmups 2 \
      --list --no-deferred-bodies $w "${o[@]}" -o "$out/source-order-$tag.o" --list --deferred-bodies $w "${o[@]}" -o "$out/deferred-$tag.o" > "$out/time-runs-$tag.txt" 2>&1
  $lock taskset -c 0-7 $head time-runs --runs 11 --warmups 2 --executable $main --executable $head \
      --list $w "${o[@]}" -o "$out/default-$tag.o" > "$out/time-runs-main-$tag.txt" 2>&1
  $lock taskset -c 0-7 $main $w "${o[@]}" -o "$out/main-$tag.o" 2> /dev/null
  cmp "$out/source-order-$tag.o" "$out/deferred-$tag.o" && cmp "$out/source-order-$tag.o" "$out/main-$tag.o" && echo "sqlite3.c objects the same ($tag)" >> "$out/identity.txt"
done
printf 'mode\tlanes\trun\tcheck-input-ms\ttotal-ms\tdeferred-lanes\tdeferred-merged\n' > "$out/sweep.tsv"
for mode in --no-deferred-bodies --deferred-bodies; do
  for lanes in 1 2 3 4 5 6 7 8; do
    for i in $(seq 1 11); do
      $lock taskset -c 0-7 $head --time-stages --lanes $lanes $mode -w "${o[@]}" -o "$out/sweep.o" 2> "$out/sweep-stages.txt" > /dev/null
      ci=$(awk -F'\t' '$1=="time-stage" && $2=="check-input" {print $3}' "$out/sweep-stages.txt")
      tot=$(awk -F'\t' '$1=="time-stage" && $2=="total" {print $3}' "$out/sweep-stages.txt")
      dl=$(awk -F'\t' '$1=="time-check" && $2=="deferred-lanes" {print $3}' "$out/sweep-stages.txt")
      dm=$(awk -F'\t' '$1=="time-check" && $2=="deferred-merged" {print $3}' "$out/sweep-stages.txt")
      printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$mode" "$lanes" "$i" "$ci" "$tot" "${dl:--}" "${dm:--}" >> "$out/sweep.tsv"
    done
    cp "$out/sweep-stages.txt" "$out/stages$mode-$lanes.txt"
  done
done
$lock taskset -c 0-7 $head benchmark-checker-deferred --passes 24 --lanes 8 --cpus 2,0,1,3,4,5,6,7 \
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" > "$out/benchmark-checker-deferred.txt" 2>&1
cd $base/$2
m=(-c -w -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c)
for mode in --no-deferred-bodies --deferred-bodies; do
  for i in 1 2 3; do
    $lock taskset -c 0-7 $head --time-stages $mode "${m[@]}" -o "$out/main.c$mode.o" 2> "$out/main.c$mode-$i.txt" > /dev/null
  done
done
cmp "$out/main.c--no-deferred-bodies.o" "$out/main.c--deferred-bodies.o" && echo "main.c objects the same" >> "$out/identity.txt"
small="$out/small.c"
{
  echo '#include <stdio.h>'
  for f in $(seq 1 24); do echo "static int f$f(int x) { int y = x * $f; for (int i = 0; i < x; i += 1) { y += i ^ $f; } return y; }"; done
  echo 'int main(void) { int s = 0;'
  for f in $(seq 1 24); do echo "  s += f$f($f);"; done
  echo '  printf("%d\n", s); return 0; }'
} > "$small"
$lock taskset -c 0-7 $head time-runs --runs 41 --warmups 3 --list --no-deferred-bodies -c "$small" -o "$out/small-source-order.o" --list --deferred-bodies -c "$small" -o "$out/small-deferred.o" > "$out/time-runs-small.txt" 2>&1
cmp "$out/small-source-order.o" "$out/small-deferred.o" && echo "small objects the same" >> "$out/identity.txt"
# 6. Lane 0's functions: perf's user cycles of sqlite3.c's -c -w with --deferred-bodies on 8 lanes, the samples of the
#    process's first thread (lane 0, whose tid is its pid), by function: the serial part's shares.
$lock taskset -c 0-7 perf record -q -F 20000 -e cycles:u -o "$out/perf.data" -- $head --deferred-bodies -w "${o[@]}" -o "$out/perf.o" 2> /dev/null
perf script -i "$out/perf.data" -F pid,tid,sym 2> /dev/null | awk '{ n = split($1, id, "/"); lane = n == 2 ? id[1] == id[2] : $1 == $2; symbol = n == 2 ? $2 : $3 } lane { lane0 += 1; count[symbol] += 1 } { all += 1 } END { printf "samples\t%d\tlane0\t%d\n", all, lane0; for (f in count) printf "%d\t%.2f\t%s\n", count[f], 100 * count[f] / lane0, f }' \
    | sort -k1,1nr > "$out/lane0-functions.tsv"
rm -f "$out/perf.data"
rm -f "$out"/*.o "$out/sweep-stages.txt"
echo done > "$out/done"
echo "$out"
