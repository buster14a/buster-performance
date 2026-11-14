#!/bin/bash
# #1840's last rows (FMA, the verifier's table, scatters): the scatters' Zen 5 rows measured into the head, its tests
# natively, the backend unit's rows, a self-built backend unit's suites, and main against the head.
W=$HOME/buster-fast-bench/1840-scatter
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-scatter EXCLUSIVE_TITLE="Issue 1840: IR scatters" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
R=$HOME/buster-fast-bench/1840-fma/repo
cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
git -C $R fetch -q origin main
git -C $R fetch -q -f $W/scatter.bundle local/1840-rest:scatter-head
[ -d $W/head ] || git -C $R worktree add -q --detach $W/head scatter-head
H=$W/head
(cd $H && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-head.log 2>&1)
echo "built head $(git -C $H rev-parse --short HEAD): $(tail -1 $W/build-head.log)" >> progress.txt
(cd $H && $L taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > $W/zen5-table.txt 2> $W/zen5.err)
echo "zen5 $(grep -c '^# row' $W/zen5-table.txt) rows $(date -u +%FT%TZ)" >> progress.txt
grep '^# row' $W/zen5-table.txt | sed 's/^# row *//' > $W/rows.txt
python3 - "$H/src/buster/compiler/x86_zen5_rows.c" "$W/rows.txt" <<'PY'
import sys, re
path, rows = sys.argv[1], sys.argv[2]
table = open(path).read().split('\n')
measured = {}
for line in open(rows):
    m = re.match(r'\s*X\((\w+), (\w+),', line)
    if m: measured[(m.group(1), m.group(2))] = '    ' + line.strip()
for i, line in enumerate(table):
    m = re.match(r'\s*X\((\w+), (\w+),', line)
    if m and (m.group(1), m.group(2)) in measured and ' U, U, U, U, U, U, U, 0x00, 0x00, 0x00)' in line:
        table[i] = measured[(m.group(1), m.group(2))]
open(path, 'w').write('\n'.join(table))
PY
(cd $H && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-head2.log 2>&1)
echo "rebuilt head with the rows: $(tail -1 $W/build-head2.log)" >> progress.txt
cp $H/build/compiler $W/compiler-head
cp $HOME/buster-fast-bench/1840-meta/compiler-main $W/compiler-main
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $H/build/predefines.h
for s in test-x86-zen5 test-ir-simd test-tier1-masks test-tier1-select test-x86-semantics; do
  (cd $H && $L ./build/compiler $s > $W/$s.txt 2>&1)
  echo "head $s: status $? $(grep -iE 'failures|failed|pass|incomplete' $W/$s.txt | tail -1 | cut -c1-100)" >> progress.txt
done
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
for n in main head; do
  $L $W/compiler-$n -c --tier1 --tier1-report -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/rows-$n.o > $W/rows-$n.txt 2>&1
done
echo "rows: main $(tr '\t' '\n' < $W/rows-main.txt | grep '^machine_rows='), head $(tr '\t' '\n' < $W/rows-head.txt | grep '^machine_rows=')" >> progress.txt
# The backend unit self-built by the head's --tier1, linked with the head's Release objects, on the backend's suites.
N=$H/build/cmake/native-g0
clang -dM -E -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -x c /dev/null > $W/self-pd.h
LINE=$(grep -n "^build Release/compiler.link: " $N/CMakeFiles/impl-Release.ninja | head -1 | cut -d: -f1)
OBJS=$(sed -n "${LINE}p" $N/CMakeFiles/impl-Release.ninja | sed 's/^build Release\/compiler.link: [A-Za-z_]* //; s/ |.*//')
FLAGS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_FLAGS =" | sed 's/.*LINK_FLAGS = //')
LIBS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_LIBRARIES =" | sed 's/.*LINK_LIBRARIES = //')
rm -rf $W/self; mkdir -p $W/self/build
$L $W/compiler-head -c --tier1 --tier1-report -march=native -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_HOST_STATIC=1 --predefines $W/self-pd.h $H/src/buster/compiler/main_unit_backend.c -o $W/self/backend.o > $W/self/compile.txt 2>&1
objs=""
for o in $OBJS; do case $o in *main_unit_backend*) objs="$objs $W/self/backend.o" ;; *) objs="$objs $N/$o" ;; esac; done
(cd $N && $L clang $FLAGS $objs $LIBS -o $W/self/build/compiler > $W/self/link.txt 2>&1)
echo "self: $(stat -c %s $W/self/build/compiler 2>&1) $(tr '\t' '\n' < $W/self/compile.txt | grep '^machine_rows=')" >> progress.txt
$L $W/self/build/compiler -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/self/out.o > $W/self/run.txt 2>&1
$L $W/compiler-head -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/out-head.o > /dev/null 2>&1
echo "self output: $(cmp $W/self/out.o $W/out-head.o > /dev/null && echo same || echo differ)" >> progress.txt
for s in test-ir test-ir-simd test-tier1-masks test-tier1-select test-x86-semantics test-ir-lowering; do
  (cd $H && $L $W/self/build/compiler $s > $W/self/$s.txt 2>&1)
  echo "self $s: status $? $(grep -iE 'failures|failed|pass' $W/self/$s.txt | tail -1 | cut -c1-80)" >> progress.txt
done
for mode in c tier1; do
  flag=""; [ $mode = tier1 ] && flag="--tier1"
  for n in main head; do
    $L taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5 $W/compiler-$n $flag -c $ARGS $H/src/buster/compiler/main.c -o $W/out-$n-$mode.o > /dev/null 2> $W/stat-$n-$mode.txt
    echo "stat $mode $n $(grep instructions $W/stat-$n-$mode.txt | cut -d, -f1) $(grep cycles $W/stat-$n-$mode.txt | cut -d, -f1)" >> progress.txt
  done
done
B="--build main $W/compiler-main --build head $W/compiler-head --build main-again $W/compiler-main"
TR="time-runs --runs 3 --copies 3"
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-t1.o > $W/tr-t1.txt 2>&1)
echo "time-runs --tier1 status $? $(date -u +%FT%TZ)" >> progress.txt
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-c.o > $W/tr-c.txt 2>&1)
echo "time-runs -c status $? $(date -u +%FT%TZ)" >> progress.txt
echo scatterdone >> progress.txt
