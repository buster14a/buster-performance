#!/bin/sh
R=/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/s2546/rv2
cd /home/user/wt-2546
for t in "test-snapshot" "test-bind --cross-check" "test-executable" "test-static --cross-check" "test-dynamic --cross-check" "test-link" "test-lanes"; do
  name=$(echo $t | tr ' ' '_')
  start=$(date +%s)
  ./build/compiler $t > $R/full-$name.log 2>&1
  e=$?
  echo "$t: exit $e ($(( $(date +%s) - start )) s) $(grep -c 'failed' $R/full-$name.log) tallies, $(grep -E '[1-9][0-9]* failed' $R/full-$name.log | head -2 | tr '\n' ' ')"
done > $R/full.out 2>&1
echo full-done >> $R/full.out
