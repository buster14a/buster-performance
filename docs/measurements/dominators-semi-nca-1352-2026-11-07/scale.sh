#!/bin/sh
# #1352 end-to-end scaling, one measurement point: BUILD (base: main; semi: SEMI-NCA without the frontier walk's
# early stop; new: both) compiles SHAPE-N.c with -c (--tier1 when MODE is
# tier1) and --time-stages, best of 3 whole processes pinned to CPU 2. Run under the lock once per point.
# Prints TSV: build shape N mode wall_ms tier0_ms, wall to 0.1 ms, tier0 as --time-stages reports it.
cd ~/buster-fast-bench/1352-claude || exit 1
build=$1; shape=$2; N=$3; mode=$4
case "$build" in
  base) cc=../1352-claude-base/build/compiler ;;
  semi) cc=../1352-claude-semi/compiler ;;
  *) cc=./build/compiler ;;
esac
flag=; [ "$mode" = tier1 ] && flag=--tier1
best_wall=; best_t0=
for r in 1 2 3; do
  s=$(date +%s%N)
  taskset -c 2 $cc -c $flag --time-stages -o /tmp/1352-claude.o inputs/$shape-$N.c 2> stages-$build.txt || echo "FAIL $build $shape $N $mode"
  e=$(date +%s%N)
  wall=$(( (e - s) / 1000 ))
  t0=$(awk '$1 == "time-stage" && $2 == "tier0" {print $3; exit}' stages-$build.txt)
  if [ -z "$best_wall" ] || [ $wall -lt $best_wall ]; then best_wall=$wall; best_t0=$t0; fi
done
printf '%s\t%s\t%s\t%s\t%d.%d\t%s\n' $build $shape $N $mode $((best_wall / 1000)) $((best_wall % 1000 / 100)) "$best_t0"
