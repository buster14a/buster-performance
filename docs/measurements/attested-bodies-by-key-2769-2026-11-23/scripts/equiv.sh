#!/bin/bash
# equiv.sh: the head's source with the temporary dump, built, against the base binary (built with the dump): census reports,
# per-unit hits and reach, one-lane musl skips, objects and diagnostics against main's and --attested=off's.
S=/tmp/claude-0/-home-user/71d741cf-e5b6-5da5-8b58-e4a09ee1158f/scratchpad
cd /home/user/buster
cp src/buster/compiler/c_check_attested.c $S/attested-wip.c
python3 $S/dump.py src/buster/compiler/c_check_attested.c
./build.sh > $S/build-dev.log 2>&1; echo "build $?"
cp $S/attested-wip.c src/buster/compiler/c_check_attested.c
cd $S
rm -rf cmp-head c-head c-off m1-head m1-off
$S/census.sh /home/user/buster/build/compiler $S/cmp-head > /dev/null &
$S/musl1.sh /home/user/buster/build/compiler $S/m1-head &
$S/musl1.sh /home/user/buster/build/compiler $S/m1-off --attested=off &
wait
$S/compile.sh /home/user/buster/build/compiler $S/c-head &
$S/compile.sh /home/user/buster/build/compiler $S/c-off --attested=off &
wait
for f in musl sqlite; do
    grep -v "pass=\|passes cycles" cmp-base/$f.txt > a; grep -v "pass=\|passes cycles" cmp-head/$f.txt > b
    echo "census $f report: $(cmp -s a b && echo same || echo DIFFER)"
    grep DUMP cmp-base/$f.err > a; grep DUMP cmp-head/$f.err > b
    echo "census $f hits/reach: $(cmp -s a b && echo same || echo DIFFER) ($(wc -l < a) units)"
done
grep -h "twins" cmp-head/*.txt
echo "musl one lane skips: $(cmp -s <(grep DUMPC m1-base/diagnostics.err) <(grep DUMPC m1-head/diagnostics.err) && echo same || echo DIFFER)"
echo "musl one lane objects head/base: $(diff -rq --exclude=diagnostics.err m1-base m1-head > /dev/null && echo same || echo DIFFER), head/off: $(diff -rq --exclude=diagnostics.err m1-head m1-off > /dev/null && echo same || echo DIFFER)"
echo "musl one lane diagnostics head/off: $(diff <(grep -v DUMP m1-head/diagnostics.err) m1-off/diagnostics.err > /dev/null && echo same || echo DIFFER)"
echo "sqlite skips: $(cmp -s <(grep DUMPC c-base/sqlite/diagnostics.err) <(grep DUMPC c-head/sqlite/diagnostics.err) && echo same || echo DIFFER) $(grep DUMPC c-head/sqlite/diagnostics.err)"
for p in "c-base c-head" "c-head c-off"; do set -- $p; echo "$1/$2 objects: $(diff -rq --exclude=memo --exclude=diagnostics.err $1 $2 > /dev/null && echo same || echo DIFFER), diagnostics: $(diff <(grep -hv DUMP $1/musl/diagnostics.err $1/sqlite/diagnostics.err) <(grep -hv DUMP $2/musl/diagnostics.err $2/sqlite/diagnostics.err) > /dev/null && echo same || echo DIFFER)"; done
