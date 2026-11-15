#!/bin/bash
# #2780 (the other units' SIMD machine rows) on the 9700X: head (the branch's 4 commits) against main 1935a91f. Release
# builds; the new forms' Zen 5 rows measured, written into the head's table and rebuilt; the machine rows of every unit
# by both; the 7 units that had rows self-built by each --tier1, linked into a compiler and run on their suites and on
# -c main.c; time-runs under ab (base, head, base again; one lock hold a run) of -c and --tier1 -c main.c, and of the
# self-built compilers' -c main.c.
W=$HOME/buster-fast-bench/2780-claude
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-2780 EXCLUSIVE_TITLE="Issue 2780: the other units' SIMD machine rows" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2780
cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main
git -C repo fetch -q $W/head.bundle claude/focused-ride-jlo904:head-2780 2>> progress.txt
for t in base:1935a91f head:head-2780; do
  n=${t%%:*}; c=${t#*:}
  [ -d $n ] || git -C repo worktree add -q --detach ../$n $c
  (cd $W/$n && git checkout -q --detach $c && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-$n.log 2>&1)
  echo "built $n $(git -C $W/$n rev-parse --short HEAD): $(tail -1 $W/build-$n.log)" >> progress.txt
done
(cd $W/head && $L taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > $W/zen5-table.txt 2> $W/zen5.err)
echo "zen5 $(grep -c '^# row' $W/zen5-table.txt) rows $(date -u +%FT%TZ)" >> progress.txt
grep '^# row' $W/zen5-table.txt | sed 's/^# row *//' > $W/rows.txt
python3 - "$W/head/src/buster/compiler/x86_zen5_rows.c" "$W/rows.txt" >> progress.txt <<'PY'
import sys, re
path, rows = sys.argv[1], sys.argv[2]
table = open(path).read().split('\n')
measured = {}
for line in open(rows):
    m = re.match(r'\s*X\((\w+), (\w+),', line)
    if m: measured[(m.group(1), m.group(2))] = '    ' + line.strip()
done = 0
for i, line in enumerate(table):
    m = re.match(r'\s*X\((\w+), (\w+),', line)
    if m and (m.group(1), m.group(2)) in measured and ' U, U, U, U, U, U, U, 0x00, 0x00, 0x00)' in line:
        table[i] = measured[(m.group(1), m.group(2))]
        done += 1
open(path, 'w').write('\n'.join(table))
print("rows written:", done, "of", len(measured))
PY
(cd $W/head && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-head2.log 2>&1)
echo "rebuilt head with the rows: $(tail -1 $W/build-head2.log)" >> progress.txt
(cd $W/head && $L ./build/compiler test-x86-zen5 > $W/test-zen5.txt 2>&1)
echo "test-x86-zen5: status $? $(tail -1 $W/test-zen5.txt)" >> progress.txt
(cd $W/head && git diff > $W/zen5-rows.diff)
for n in base head; do cp $W/$n/build/compiler $W/compiler-$n; clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/$n/build/predefines.h; done
H=$W/head
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
mkdir -p $W/rows
for u in frontend backend checker check_builtins types assembler dynamic executable link x86; do
  for n in base head; do
    $L $W/compiler-$n -c --tier1 --tier1-report -march=znver5 $ARGS $H/src/buster/compiler/main_unit_$u.c -o $W/rows/$n-$u.o > $W/rows/$n-$u.txt 2>&1
  done
  echo "rows $u: base $(tr '\t' '\n' < $W/rows/base-$u.txt | grep -E '^machine_rows=|^fallbacks=|^records=' | tr '\n' ' ') head $(tr '\t' '\n' < $W/rows/head-$u.txt | grep -E '^machine_rows=|^fallbacks=|^records=' | tr '\n' ' ')" >> progress.txt
done
B="--build base $W/compiler-base --build head $W/compiler-head --build base-again $W/compiler-base"
TR="time-runs --runs 3 --copies 3"
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-c.o > $W/tr-c.txt 2>&1)
echo "time-runs -c status $? $(date -u +%FT%TZ)" >> progress.txt
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-t1.o > $W/tr-t1.txt 2>&1)
echo "time-runs --tier1 status $? $(date -u +%FT%TZ)" >> progress.txt
for n in base head; do
  $L perf stat -r 5 -e instructions:u,cycles:u -x, -o $W/stat-t1-$n.txt taskset -c 2 $W/compiler-$n --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/stat.o > /dev/null 2>&1
done
echo "perf stat --tier1: base $(grep instructions $W/stat-t1-base.txt | cut -d, -f1) head $(grep instructions $W/stat-t1-head.txt | cut -d, -f1)" >> progress.txt
# The 7 units that had rows, self-built by each --tier1 (the head's sources), linked with the head's Release objects.
N=$H/build/cmake/native-g0
clang -dM -E -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -x c /dev/null > $W/self-pd.h
LINE=$(grep -n "^build Release/compiler.link: " $N/CMakeFiles/impl-Release.ninja | head -1 | cut -d: -f1)
OBJS=$(sed -n "${LINE}p" $N/CMakeFiles/impl-Release.ninja | sed 's/^build Release\/compiler.link: [A-Za-z_]* //; s/ |.*//')
FLAGS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_FLAGS =" | sed 's/.*LINK_FLAGS = //')
LIBS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_LIBRARIES =" | sed 's/.*LINK_LIBRARIES = //')
UNITS="checker check_builtins types assembler dynamic executable link"
for n in base head; do
  rm -rf $W/self-$n; mkdir -p $W/self-$n/build
  for u in $UNITS; do
    $L $W/compiler-$n -c --tier1 --tier1-report -march=native -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_HOST_STATIC=1 --predefines $W/self-pd.h $H/src/buster/compiler/main_unit_$u.c -o $W/self-$n/$u.o > $W/self-$n/compile-$u.txt 2>&1
    echo "self $n $u: status $? $(tr '\t' '\n' < $W/self-$n/compile-$u.txt | grep -E '^machine_rows=|^fallbacks=' | tr '\n' ' ')" >> progress.txt
  done
  objs=""
  for o in $OBJS; do
    r=$N/$o
    for u in $UNITS; do case $o in *main_unit_$u.c.o) r=$W/self-$n/$u.o ;; esac; done
    objs="$objs $r"
  done
  (cd $N && $L clang $FLAGS $objs $LIBS -o $W/self-$n/build/compiler > $W/self-$n/link.txt 2>&1)
  echo "self $n linked: $(stat -c %s $W/self-$n/build/compiler 2>&1)" >> progress.txt
done
# Their outputs against the Release head's: -c and --tier1 of main.c, --tier1 of the checker unit.
for job in "c:-c" "t1:--tier1 -c"; do
  k=${job%%:*}; f=${job#*:}
  $L $W/compiler-head $f $ARGS $H/src/buster/compiler/main.c -o $W/out-release-$k.o > /dev/null 2>&1
  for n in base head; do
    $L $W/self-$n/build/compiler $f $ARGS $H/src/buster/compiler/main.c -o $W/self-$n/out-$k.o > $W/self-$n/out-$k.txt 2>&1
    echo "self $n $k main.c: $(cmp $W/self-$n/out-$k.o $W/out-release-$k.o > /dev/null 2>&1 && echo same || echo DIFFER)" >> progress.txt
  done
done
# The head's self-built compiler on the suites of the units it changed.
for s in test-link test-dynamic test-executable test-inflate test-import test-assembler test-types test-check-builtins test-builtins "test-checker --seed 133 --part 6/8"; do
  name=$(echo $s | tr ' /' '__')
  (cd $H && $L $W/self-head/build/compiler $s > $W/self-head/$name.txt 2>&1)
  echo "self head $s: status $? $(grep -iE 'failures|failed|pass|checks' $W/self-head/$name.txt | tail -1 | cut -c1-100)" >> progress.txt
done
S="--build self-base $W/self-base/build/compiler --build self-head $W/self-head/build/compiler --build self-base-again $W/self-base/build/compiler"
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $S --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-self.o > $W/tr-self.txt 2>&1)
echo "time-runs self -c status $? $(date -u +%FT%TZ)" >> progress.txt
echo done2780 >> progress.txt
