#!/bin/bash
# u-checks.sh: the merged head f8c4f8e1e (main a62529650; a skipped group's UCN, a digit separator's quote and a dotted
# asm label leave): the gate against r2 (472cc48a3's code), the call graph, ASan+UBSan and MSan, then CI's count against
# main a62529650.
S=/tmp/claude-0/-home-user/cf3643bc-6e1c-51b2-99ca-175eb97147e4/scratchpad
C=/home/user/corpus
export LLVM_PROFILE_FILE=/dev/null
cd /home/user/buster || exit 2
cp build/compiler /home/user/u-compiler
U=/home/user/u-compiler; R=/home/user/r2-compiler
SQ=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$C/sqlite" "$C/sqlite/sqlite3.c")
CF=(--lanes 1 --predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include)
for t in u r2; do
  B=/home/user/$t-compiler
  $B "${SQ[@]}" -o $S/sq-$t.o; $B "${CF[@]}" "${SQ[@]}" -o $S/sq-corpus-$t.o
  echo "$t: sqlite3.c $(readelf -p .comment $S/sq-$t.o | grep -o 'buster[a-z -]*'), corpus $(readelf -p .comment $S/sq-corpus-$t.o | grep -o 'buster[a-z -]*')"
done
cmp -s $S/sq-u.o $S/sq-r2.o && echo "sqlite3.c: identical to r2's" || echo "sqlite3.c: DIFFERS from r2's"
cmp -s $S/sq-corpus-u.o $S/sq-corpus-r2.o && echo "corpus sqlite3.c: identical to r2's" || echo "corpus sqlite3.c: DIFFERS from r2's"
rm -f $S/u-bails.txt
BUSTER_TEST_DIRECT_BAILS=$S/u-bails.txt xargs -P 4 -n 1 $S/diff/one.sh $U < $S/diff/files.txt > $S/u-tests.tsv
awk -F'\t' '{c[$1]++; if ($4=="differs"||$4=="direct-only") d++} END {printf "tests/ (r2 list): %d SAME %d DIFF, %d direct-taken (r2 310)\n", c["SAME"], c["DIFF"], d}' $S/u-tests.tsv
awk -F'\t' '$1=="DIFF"{print "  DIFF", $5}' $S/u-tests.tsv | head
bash $S/real.sh $U u
awk -F'\t' '$1=="DIFF"{print "  DIFF", $5}' $S/real-u-cts.tsv $S/real-u-musl.tsv | head
echo "new reasons: $(cat $S/u-bails.txt $S/real-u-bails.txt | cut -f1 | grep -cE "universal character|asm label with a|quote after a name")"
cat $S/u-bails.txt $S/real-u-bails.txt | grep -E "universal character|asm label with a|quote after a name" | head
n=0; for d in p25 p26 p27 p28 p29 p30 p31 p32 p33 p34 p35 p36 p37 p38 p39 p40 p42 p44 p45 p46 p47 p48 p49 p50 p51 p52 p53 p54 p55 p56 p57 p58 p59 p60 p61 p62 p63 p64 p65 p66 p67 p68; do ls $S/$d/*.c > /dev/null 2>&1 || continue; (cd /home/user && P=$U bash $S/probe.sh $S/$d/*.c) > $S/u-probes-$d.txt 2>&1; n=$((n + $(grep -c '^DIFF' $S/u-probes-$d.txt))); done
(cd /home/user && P=$U EXTRA=-std=c23 bash $S/probe.sh $S/p68c23/*.c) > $S/u-probes-p68c23.txt 2>&1; n=$((n + $(grep -c '^DIFF' $S/u-probes-p68c23.txt)))
echo "probes: $n DIFF: $(grep -h '^DIFF' $S/u-probes-*.txt | cut -d: -f1 | sed 's|.*/||' | tr '\n' ' ')"
./build.sh check-call-graph --config Release > $S/u-callgraph.log 2>&1; echo "check-call-graph $?: $(tail -1 $S/u-callgraph.log)"
for san in address memory; do
  BUSTER_SANITIZER=$san ./build.sh > $S/$san-build-u.log 2>&1; echo "$san build $?"; tail -1 $S/$san-build-u.log
  cp build/compiler /home/user/u-$san-compiler
  build/compiler test-direct > $S/$san-u-unit.log 2>&1; echo "$san unit status $?: $(tail -1 $S/$san-u-unit.log)"
  build/compiler test-direct --differential --jobs 4 --direct-floor 260 tests > $S/$san-u-diff.log 2>&1; echo "$san differential status $?: $(tail -1 $S/$san-u-diff.log)"
  n=0; for d in p62 p63 p64 p65 p66 p67 p68; do ls $S/$d/*.c > /dev/null 2>&1 || continue; (cd /home/user && P=/home/user/u-$san-compiler bash $S/probe.sh $S/$d/*.c) > $S/$san-u-probes-$d.txt 2>&1; n=$((n + $(grep -c '^DIFF' $S/$san-u-probes-$d.txt))); grep -l "Sanitizer\|runtime error" $S/$san-u-probes-$d.txt; done; echo "$san probes: $n DIFF"
done
./build.sh --config Release > $S/u-release-again.log 2>&1; echo "release again $?"; cmp build/compiler /home/user/u-compiler && echo "release binary identical to u-compiler"
git -C /home/user/buster-base fetch -q origin main 2>/dev/null; git -C /home/user/buster-base checkout -q --detach a62529650 && echo "base at $(git -C /home/user/buster-base log --oneline -1 | cut -c1-60)"
rm -rf /home/user/count-u
bash tools/ci/compile-count.sh check /home/user/buster-base /home/user/buster /home/user/corpus /home/user/count-u > $S/u-count.log 2>&1; echo "count check exit $?"
grep -E "base's compile|change's compile|passed|failed|moves|states" $S/u-count.log | head -8
echo done
