#!/bin/bash
# $1: the tree; its compiler builds every unit (build.sh print-sources) by --tier1 with build.sh print-compile-flags'
# arguments read as an array (NUL-delimited, as tools/ci/selfhost.c reads them), less -g, -O3, -Wall and -Werror, 8 units
# at a time, then clang links them in source-list order.
t=$1
D=$(pwd)
rm -rf self-$t && mkdir -p self-$t
mapfile -d '' sources < <(cd $t && ./build.sh print-sources)
mapfile -d '' all < <(cd $t && BUSTER_HOST_ARCH=znver5 ./build.sh print-compile-flags)
flags=()
for f in "${all[@]}"; do
  case "$f" in -g|-O3|-Wall|-Werror) ;; *) flags+=("$f") ;; esac
done
printf '%s\n' "${flags[@]}" > self-$t/flags.txt
start=$(date +%s.%N)
running=0
objects=()
for s in "${sources[@]}"; do
  b=$(basename "$s" .c)
  objects+=("self-$t/$b.o")
  ( cd $t && ./build/compiler -c --tier1 --tier1-report "${flags[@]}" -o "$D/self-$t/$b.o" "$s" > "$D/self-$t/$b.report" 2>&1 || echo "self $t $s FAILED" ) &
  running=$((running + 1))
  if [ $running -ge 8 ]; then wait -n; running=$((running - 1)); fi
done
wait
end=$(date +%s.%N)
echo "self-build $t: ${#sources[@]} units in $(echo "$end - $start" | bc) s, 8 at a time"
clang -no-pie -o self-$t/compiler "${objects[@]}" -lm -ldl -lpthread && echo "self $t linked"
