#!/bin/bash
# run_sweeps.sh FIRST LAST: for each fault N in FIRST..LAST: the source mutated (mutate_sweeps.py), the compiler built
# (Develop), the census's part of test-checker run and sqlite3.c's and Lua's comparison with the lean front, the source
# restored. A line a fault: what showed it. Results in mutations.txt. No other build while it runs.
set -u
cd /home/user/buster
dir=~/.cache/claude-2524m/mutsw
for f in c_check_node_machine_reader.c c_check_node_census.c; do cp src/buster/compiler/$f $dir/unmutated-$f; done
restore() { for f in c_check_node_machine_reader.c c_check_node_census.c; do cp $dir/unmutated-$f src/buster/compiler/$f; done; }
for n in $(seq $1 $2); do
    restore
    name=$(python3 $dir/mutate_sweeps.py /home/user/buster $n) || { restore; break; }
    ./build.sh > $dir/build-$n.log 2>&1
    status=$?
    if [ $status != 0 ]; then
        echo "fault $n ($name): BUILD FAILED" >> $dir/mutations.txt
        continue
    fi
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    ./build/compiler test-checker --seed 133 --part 5/8 > $dir/tests-$n.log 2>&1
    failures=$(sed -n 's/^test-checker: [0-9]* checks, \([0-9]*\) failures/\1/p' $dir/tests-$n.log)
    sq=$(~/.cache/claude-2524s/shapes-local.sh ./build/compiler sqlite --front-lean --front-sweeps 2>&1 | sed -n 's/.*reader-time C and X compared=\([0-9]*\) (entries [0-9]*) differences=\([0-9]*\) (root \([0-9]*\), refusal \([0-9]*\), tape \([0-9]*\), labels-and-calls \([0-9]*\)).*/\2 of \1 differ (root \3, refusal \4, tape \5, side \6)/p; s/.*reader-time T lowered.*compared=\([0-9]*\) (records [0-9]*) differences=\([0-9]*\) .*/T \2 of \1/p' | tr '\n' ';')
    lu=$(~/.cache/claude-2524s/shapes-local.sh ./build/compiler lua --front-lean --front-sweeps 2>&1 | sed -n 's/.*reader-time C and X compared=\([0-9]*\) (entries [0-9]*) differences=\([0-9]*\) (root \([0-9]*\), refusal \([0-9]*\), tape \([0-9]*\), labels-and-calls \([0-9]*\)).*/\2 of \1 differ (root \3, refusal \4, tape \5, side \6)/p; s/.*reader-time T lowered.*compared=\([0-9]*\) (records [0-9]*) differences=\([0-9]*\) .*/T \2 of \1/p' | tr '\n' ';')
    echo "fault $n ($name): tests ${failures:-?} failures; sqlite3.c: ${sq:-crashed}; Lua: ${lu:-crashed}" >> $dir/mutations.txt
done
restore
for f in c_check_node_machine_reader.c c_check_node_census.c; do cmp $dir/unmutated-$f src/buster/compiler/$f; done && echo restored
