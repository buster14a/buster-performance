#!/bin/bash
# usage: measure.sh NAME -> prints Ir Dr Dw of the program's own object for speedtest1 and the Lua scripts (summed)
N=$1
W=$HOME/.cache/claude-2718/work
SC=/home/user/buster-performance/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
cd $W
own() { # file, binary -> Ir Dr Dw summed over functions in the binary
  callgrind_annotate --threshold=100 --inclusive=no "$1" 2>/dev/null | sed "s/([^)]*)//g" | awk '/file:function/ {go=1; next} go && NF>3 && $0 !~ /\[\/usr\/lib|\[\/lib/ {gsub(",","",$1); gsub(",","",$2); gsub(",","",$3); ir+=$1; dr+=$2; dw+=$3} END {printf "%d %d %d\n", ir, dr, dw}'
}
D=run-$N; rm -rf $D; mkdir -p $D/tmp
SQLITE_TMPDIR=$PWD/$D/tmp valgrind --tool=callgrind --cache-sim=yes --D1=32768,8,64 --LL=1048576,16,64 --callgrind-out-file=cg-st-$N.out ./speedtest1-$N --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 $D/db.sqlite > /dev/null 2>&1
echo "speedtest1-$N $(own cg-st-$N.out speedtest1-$N)"
tot=(0 0 0)
for s in calls tables strings arithmetic closures; do
  valgrind --tool=callgrind --cache-sim=yes --D1=32768,8,64 --LL=1048576,16,64 --callgrind-out-file=cg-$s-$N.out ./lua-$N $SC/$s.lua > /dev/null 2>&1
  r=($(own cg-$s-$N.out lua-$N)); echo "  $s ${r[*]}"
  tot=($((tot[0]+r[0])) $((tot[1]+r[1])) $((tot[2]+r[2])))
done
echo "lua-$N ${tot[*]}"
