#!/bin/bash
# run_flat.sh FIRST LAST: for each fault N in FIRST..LAST: the flat front's source mutated, the compiler built (Develop), the
# census's part of test-checker run and the three corpora's comparison (sqlite3.c, Lua; musl where MUSL=1), the source
# restored. A line a fault: what showed it. Results in mutations.txt.
set -u
cd /home/user/buster
src=src/buster/compiler/c_check_node_machine_flat.c
keep=~/.cache/claude-2524m/mut/unmutated.c
cp $src $keep
for n in $(seq $1 $2); do
    cp $keep $src
    name=$(python3 ~/.cache/claude-2524m/mut/mutate_flat.py $src $n) || { cp $keep $src; break; }
    ./build.sh > ~/.cache/claude-2524m/mut/build-$n.log 2>&1
    status=$?
    if [ $status != 0 ]; then
        echo "fault $n ($name): BUILD FAILED" >> ~/.cache/claude-2524m/mut/mutations.txt
        continue
    fi
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    ./build/compiler test-checker --seed 133 --part 5/8 > ~/.cache/claude-2524m/mut/tests-$n.log 2>&1
    tests=$(grep -c "^test-checker: node-flat\|^test-checker: node-shadow\|^test-checker: node-front" ~/.cache/claude-2524m/mut/tests-$n.log)
    failures=$(sed -n 's/^test-checker: [0-9]* checks, \([0-9]*\) failures/\1/p' ~/.cache/claude-2524m/mut/tests-$n.log)
    sq=$(~/.cache/claude-2524s/shapes-local.sh ./build/compiler sqlite --front-flat 2>&1 | sed -n 's/.*against the lean front: compared=[0-9]* differences=\([0-9]*\) only-the-flat-front.s=\([0-9]*\) only-the-lean-front.s=\([0-9]*\).*/\1 differ, \2 flat-only, \3 lean-only/p')
    lu=$(~/.cache/claude-2524s/shapes-local.sh ./build/compiler lua --front-flat 2>&1 | sed -n 's/.*against the lean front: compared=[0-9]* differences=\([0-9]*\) only-the-flat-front.s=\([0-9]*\) only-the-lean-front.s=\([0-9]*\).*/\1 differ, \2 flat-only, \3 lean-only/p')
    echo "fault $n ($name): tests ${failures:-?} failures ($tests lines); sqlite3.c: ${sq:-crashed}; Lua: ${lu:-crashed}" >> ~/.cache/claude-2524m/mut/mutations.txt
done
cp $keep $src
cmp $keep $src && echo restored
