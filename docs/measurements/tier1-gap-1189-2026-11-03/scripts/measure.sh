#!/usr/bin/env bash
# measure.sh DIR: DIR's st-t1 and lua-t1 checked (speedtest1's verification hash, each Lua script's output against
# clang -O0's), then each run's instructions under callgrind (the whole process's, as `Collected`), a line each in
# DIR/instructions.txt and the sums. A run that fails, a verification hash other than HASH's (the record's by default)
# or a script whose output isn't clang -O0's makes the exit status 1, after everything is printed.
set -u
S=${S:?S names the scratch directory, laid out as the README says}
HASH=${HASH:-1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739}
d=$(readlink -f $1)
cd $d && mkdir -p cg
status=0
$S/run.sh st st-t1 verify.txt --verify
rc=$?
echo "verify $rc $(grep 'Verification Hash' verify.txt)" > check.txt
[ $rc = 0 ] && grep -qx "Verification Hash: $HASH" verify.txt || status=1
for s in calls tables strings arithmetic closures; do
    $S/run.sh lua lua-t1 $s.out $s.lua
    rc=$?
    same=$(cmp -s $s.out $S/ref/$s-clang0.out && echo same || echo differs)
    echo "$s $rc $same" >> check.txt
    [ $rc = 0 ] && [ $same = same ] || status=1
done
export VG=1 VGOPTS="--dump-instr=yes"
{ echo "st"; for s in calls tables strings arithmetic closures; do echo $s; done; } | xargs -P 4 -I{} bash -c 'if [ {} = st ]; then '$S'/run.sh st st-t1 cg/st.txt; else '$S'/run.sh lua lua-t1 cg/{}.txt {}.lua; fi' || status=1
for f in st calls tables strings arithmetic closures; do echo "$f $(grep -m1 '^summary' cg/$f.txt.cg | cut -d' ' -f2)"; done > instructions.txt
awk '$1=="st" {st=$2} $1!="st" {lua+=$2} END {printf "speedtest1 %.1f M, Lua %.1f M\n", st/1e6, lua/1e6}' instructions.txt
cat check.txt | tr '\n' ';'; echo
exit $status
