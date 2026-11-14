#!/bin/bash
# #1840's IR_FMA (head b62a08b against main 749be1a) on the 9700X: Release builds, the new FMA3 rows' Zen 5 measurement,
# written into the head's table and rebuilt, then time-runs under ab (base, head, base again; one lock hold a round) of
# -c and --tier1 -c main.c, the backend unit's machine rows, and the backend unit self-built by each --tier1.
W=$HOME/buster-fast-bench/1840-fma
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-1840-fma EXCLUSIVE_TITLE="Issue 1840: IR fused multiply-add" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1840
cd $W
echo "start $(date -u +%FT%TZ)" > progress.txt
[ -d repo ] || git clone -q https://github.com/buster14a/buster.git repo
git -C repo fetch -q origin main
git -C repo fetch -q $W/fma.bundle local/1840-rest:fma-head
for t in base:749be1a head:fma-head; do
  n=${t%%:*}; c=${t#*:}
  [ -d $n ] || git -C repo worktree add -q --detach ../$n $c
  (cd $W/$n && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-$n.log 2>&1)
  echo "built $n $(git -C $W/$n rev-parse --short HEAD): $(tail -1 $W/build-$n.log)" >> progress.txt
done
(cd $W/head && $L taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > $W/zen5-table.txt 2> $W/zen5.err)
echo "zen5 $(grep -c '^# row' $W/zen5-table.txt) rows $(date -u +%FT%TZ)" >> progress.txt
# The measured rows into the head's table, then its build again.
grep '^# row' $W/zen5-table.txt | sed 's/^# row *//' > $W/rows.txt
python3 - "$W/head/src/buster/compiler/x86_zen5_rows.c" "$W/rows.txt" <<'PY'
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
print(done)
PY
(cd $W/head && $L env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > $W/build-head2.log 2>&1)
echo "rebuilt head with the rows: $(tail -1 $W/build-head2.log)" >> progress.txt
(cd $W/head && $L ./build/compiler test-x86-zen5 > $W/test-zen5.txt 2>&1)
echo "test-x86-zen5: $(tail -1 $W/test-zen5.txt)" >> progress.txt
for n in base head; do cp $W/$n/build/compiler $W/compiler-$n; clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $W/$n/build/predefines.h; done
H=$W/head
ARGS="-march=native -I$H/src -fwrapv -funsigned-char --predefines $H/build/predefines.h"
B="--build base $W/compiler-base --build head $W/compiler-head --build base-again $W/compiler-base"
TR="time-runs --runs 3 --copies 3"
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-c.o > $W/tr-c.txt 2>&1)
echo "time-runs -c status $? $(date -u +%FT%TZ)" >> progress.txt
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $B --list --tier1 -c $ARGS $H/src/buster/compiler/main.c -o $W/tr-t1.o > $W/tr-t1.txt 2>&1)
echo "time-runs --tier1 status $? $(date -u +%FT%TZ)" >> progress.txt
for n in base head; do
  $L $W/compiler-$n -c --tier1 --tier1-report -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/rows-$n.o > $W/rows-$n.txt 2>&1
done
echo "rows: base $(tr '\t' '\n' < $W/rows-base.txt | grep '^machine_rows='), head $(tr '\t' '\n' < $W/rows-head.txt | grep '^machine_rows=')" >> progress.txt
# The backend unit self-built by each --tier1 (the head's sources), linked with the head's Release objects.
N=$H/build/cmake/native-g0
clang -dM -E -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -x c /dev/null > $W/self-pd.h
LINE=$(grep -n "^build Release/compiler.link: " $N/CMakeFiles/impl-Release.ninja | head -1 | cut -d: -f1)
OBJS=$(sed -n "${LINE}p" $N/CMakeFiles/impl-Release.ninja | sed 's/^build Release\/compiler.link: [A-Za-z_]* //; s/ |.*//')
FLAGS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_FLAGS =" | sed 's/.*LINK_FLAGS = //')
LIBS=$(sed -n "$((LINE+1)),$((LINE+8))p" $N/CMakeFiles/impl-Release.ninja | grep "LINK_LIBRARIES =" | sed 's/.*LINK_LIBRARIES = //')
for n in base head; do
  rm -rf $W/self-$n; mkdir -p $W/self-$n/build
  $L $W/compiler-$n -c --tier1 --tier1-report -march=native -I$H/src -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_HOST_STATIC=1 --predefines $W/self-pd.h $H/src/buster/compiler/main_unit_backend.c -o $W/self-$n/backend.o > $W/self-$n/compile.txt 2>&1
  objs=""
  for o in $OBJS; do case $o in *main_unit_backend*) objs="$objs $W/self-$n/backend.o" ;; *) objs="$objs $N/$o" ;; esac; done
  (cd $N && $L clang $FLAGS $objs $LIBS -o $W/self-$n/build/compiler > $W/self-$n/link.txt 2>&1)
  echo "self $n: $(stat -c %s $W/self-$n/build/compiler 2>&1) $(tr '\t' '\n' < $W/self-$n/compile.txt | grep '^machine_rows=')" >> progress.txt
done
for n in base head; do
  $L $W/self-$n/build/compiler -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/self-$n/out.o > $W/self-$n/run.txt 2>&1
done
$L $W/compiler-head -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/self-out-head.o > /dev/null 2>&1
echo "outputs: base $(cmp $W/self-base/out.o $W/self-out-head.o > /dev/null && echo same || echo differ), head $(cmp $W/self-head/out.o $W/self-out-head.o > /dev/null && echo same || echo differ)" >> progress.txt
# The head's self-built compiler on the suites its backend unit runs.
for s in test-ir test-ir-simd test-tier1-masks test-tier1-select test-x86-semantics test-ir-lowering; do
  (cd $H && $L $W/self-head/build/compiler $s > $W/self-head/$s.txt 2>&1)
  echo "self head $s: status $? $(grep -iE 'failures|failed|pass' $W/self-head/$s.txt | tail -1 | cut -c1-80)" >> progress.txt
done
S="--build self-base $W/self-base/build/compiler --build self-head $W/self-head/build/compiler --build self-base-again $W/self-base/build/compiler"
(cd $H && ./build/compiler ab --rounds 3 --cpu 2 --lock $L $W/compiler-head -- $TR $S --list -c --tier1 -march=znver5 $ARGS $H/src/buster/compiler/main_unit_backend.c -o $W/tr-self.o > $W/tr-self.txt 2>&1)
echo "time-runs self status $? $(date -u +%FT%TZ)" >> progress.txt
echo fmadone >> progress.txt
