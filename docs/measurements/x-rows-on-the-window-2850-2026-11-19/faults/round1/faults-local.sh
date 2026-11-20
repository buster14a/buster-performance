#!/bin/bash
# faults-local.sh TREE FROM TO OUT: the rows piece's faults FROM to TO in the cloud container, in the tree copy TREE
# (built already at the commit under test): each fault applied alone, a native Release build, and test-checker's part
# 5 of 8; the two files restored after each. A line a fault in OUT: caught, not-built or SURVIVED.
tree=$1; from=$2; to=$3; out=$4
faults=/home/user/keep/xrows/faults/faults-rows.py
rows=src/buster/compiler/c_check_node_machine_rows.c
census=src/buster/compiler/c_check_node_census.c
keep=$out.pristine
mkdir -p "$keep"
cd "$tree" || exit 1
cp "$rows" "$keep/rows.c" && cp "$census" "$keep/census.c" || exit 1
: > "$out"
for n in $(seq "$from" "$to"); do
    cp "$keep/rows.c" "$rows"; cp "$keep/census.c" "$census"
    name=$(python3 "$faults" "$tree" "$n") || { echo "not-applied $n" >> "$out"; continue; }
    BUSTER_HOST_ARCH=native ./build.sh --config Release > "$out.build.log" 2>&1
    if [ $? != 0 ] || ! test -x build/compiler; then echo "not-built $name" >> "$out"; continue; fi
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    timeout 600 ./build/compiler test-checker --seed 133 --part 5/8 > "$out.part5.out" 2>&1
    status=$?
    summary=$(grep 'test-checker:.*checks' "$out.part5.out" | tail -1)
    if [ $status = 0 ]; then verdict=SURVIVED; else verdict=caught; fi
    echo "$verdict $name status $status; $summary" >> "$out"
done
cp "$keep/rows.c" "$rows"; cp "$keep/census.c" "$census"
echo "done" >> "$out"
