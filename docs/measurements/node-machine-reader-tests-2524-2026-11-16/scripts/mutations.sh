#!/bin/bash
# run_tests.sh FIRST LAST: for each fault N in FIRST..LAST: the source mutated (mutate_tests.py), the compiler built
# (Develop), the census's part of test-checker run and sqlite3.c's and Lua's reader-time tests with all warnings on, the
# source restored. A line a fault: what showed it. Results in mutations.txt. No other build while it runs.
set -u
cd /home/user/buster
dir=~/.cache/claude-2524m/mutt
files="c_check_node_machine_reader.c c_check_node_census.c c_check_node_machine_type.c c_check_node_machine.c"
for f in $files; do cp src/buster/compiler/$f $dir/unmutated-$f; done
restore() { for f in $files; do cp $dir/unmutated-$f src/buster/compiler/$f; done; }
pattern='s/.*reader-time tests compared=\([0-9]*\) never-lowered=\([0-9]*\) taken-there=[0-9]* (nodes [0-9]*) taken-there-and-refused-by-the-census=\([0-9]*\) (for the lowering.s facts alone [0-9]*) differences=\([0-9]*\) root-kind-differences=\([0-9]*\) .*/\3 taken wrongly, \4 differ, \5 kinds, of \1+\2/p; s/.*reader-time tests expressions=\([0-9]*\) refused=\([0-9]*\) nodes-outside-the-records=\([0-9]*\) units-whose-enabled-warnings-differ=\([0-9]*\)/refused \2, outside \3, policy \4/p'
for n in $(seq $1 $2); do
    restore
    name=$(python3 $dir/mutate_tests.py /home/user/buster $n) || { restore; break; }
    ./build.sh > $dir/build-$n.log 2>&1
    status=$?
    if [ $status != 0 ]; then
        echo "fault $n ($name): BUILD FAILED" >> $dir/mutations.txt
        continue
    fi
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    ./build/compiler test-checker --seed 133 --part 5/8 > $dir/tests-$n.log 2>&1
    failures=$(sed -n 's/^test-checker: [0-9]* checks, \([0-9]*\) failures/\1/p' $dir/tests-$n.log)
    sq=$(~/.cache/claude-2524s/shapes-local.sh ./build/compiler sqlite --front-tests -Wall -Wextra 2>&1 | sed -n "$pattern" | tr '\n' ';')
    lu=$(~/.cache/claude-2524s/shapes-local.sh ./build/compiler lua --front-tests -Wall -Wextra 2>&1 | sed -n "$pattern" | tr '\n' ';')
    echo "fault $n ($name): tests ${failures:-?} failures; sqlite3.c: ${sq:-crashed}; Lua: ${lu:-crashed}" >> $dir/mutations.txt
done
restore
for f in $files; do cmp $dir/unmutated-$f src/buster/compiler/$f; done && echo restored
