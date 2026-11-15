#!/bin/bash
# recount.sh NAME: re-sum the existing callgrind outputs
N=$1; cd $HOME/.cache/claude-2718/work
own() { callgrind_annotate --threshold=100 --inclusive=no "$1" 2>/dev/null | sed "s/([^)]*)//g" | awk '/file:function/ {go=1; next} go && NF>3 && $0 !~ /\[\/usr\/lib|\[\/lib/ {gsub(",","",$1); gsub(",","",$2); gsub(",","",$3); ir+=$1; dr+=$2; dw+=$3} END {printf "%d %d %d\n", ir, dr, dw}'; }
echo "speedtest1-$N $(own cg-st-$N.out)"
tot=(0 0 0); for s in calls tables strings arithmetic closures; do r=($(own cg-$s-$N.out)); echo "  $s ${r[*]}"; tot=($((tot[0]+r[0])) $((tot[1]+r[1])) $((tot[2]+r[2]))); done; echo "lua-$N ${tot[*]}"
