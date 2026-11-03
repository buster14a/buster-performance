#!/usr/bin/env bash
# measure.sh DIR: DIR's st-t1 and lua-t1 checked (speedtest1's verification hash, each Lua script's output against
# clang -O0's), then each run's instructions under callgrind (the whole process's, as `Collected`), a line each in
# DIR/instructions.txt and the sums.
set -u
S=/tmp/claude-0/-home-user-buster/acfdbf9f-332f-5668-85be-7d9e72cff003/scratchpad
d=$(readlink -f $1)
cd $d && mkdir -p cg
$S/run.sh st st-t1 verify.txt --verify; echo "verify $? $(grep 'Verification Hash' verify.txt)" > check.txt
for s in calls tables strings arithmetic closures; do $S/run.sh lua lua-t1 $s.out $s.lua; echo "$s $? $(cmp -s $s.out $S/ref/$s-clang0.out && echo same || echo differs)" >> check.txt; done
export VG=1 VGOPTS="--dump-instr=yes"
{ echo "st"; for s in calls tables strings arithmetic closures; do echo $s; done; } | xargs -P 4 -I{} bash -c 'if [ {} = st ]; then '$S'/run.sh st st-t1 cg/st.txt; else '$S'/run.sh lua lua-t1 cg/{}.txt {}.lua; fi'
for f in st calls tables strings arithmetic closures; do echo "$f $(grep -m1 '^summary' cg/$f.txt.cg | cut -d' ' -f2)"; done > instructions.txt
awk '$1=="st" {st=$2} $1!="st" {lua+=$2} END {printf "speedtest1 %.1f M, Lua %.1f M\n", st/1e6, lua/1e6}' instructions.txt
cat check.txt | tr '\n' ';'; echo
