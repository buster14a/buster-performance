#!/bin/bash
# cg.sh: callgrind of speedtest1 and the five Lua scripts by base's and new's builds, with each one's outputs compared.
S=/tmp/claude-0/-home-user-buster/e0886b9c-74f2-549b-80ea-29be6d44c3f8/scratchpad; I=$S/inputs
st="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
for d in base new; do clang -o $S/$d/speedtest1 $S/$d/speedtest1.o -lm; done
for d in base new; do
  (cd $S/$d && valgrind --tool=callgrind --callgrind-out-file=$S/$d/cg-speedtest1.out ./speedtest1 $st --verify $S/$d/db > $S/$d/speedtest1.txt 2>&1) &
done; wait
for script in arithmetic calls closures strings tables; do
  for d in base new; do
    (cd $I/scripts && valgrind --tool=callgrind --callgrind-out-file=$S/$d/cg-$script.out $S/$d/lua $script.lua > $S/$d/$script.txt 2>/dev/null) &
  done; wait
done
echo cg-done
