#!/bin/bash
# faults-local5.sh TREE OUT CONFIG INDEX...: the rows piece's fifth round's faults in the cloud container, in the tree
# copy TREE (at the commit under test): the tree as it is first (the control, which must pass), then each fault INDEX
# of faults-rows-5.py alone: a native CONFIG build and test-checker's part 5 of 8; the two files restored after each. A
# line a fault in OUT: caught, not-built or SURVIVED.
tree=$1; out=$2; config=$3; shift 3
faults=/home/user/keep/xrows/faults/faults-rows-5.py
rows=src/buster/compiler/c_check_node_machine_rows.c
census=src/buster/compiler/c_check_node_census.c
keep=$out.pristine
mkdir -p "$keep"
cd "$tree" || exit 1
cp "$rows" "$keep/rows.c" && cp "$census" "$keep/census.c" || exit 1
: > "$out"
run() {
    name=$1
    BUSTER_HOST_ARCH=native ./build.sh --config "$config" > "$out.build.log" 2>&1
    if [ $? != 0 ] || ! test -x build/compiler; then echo "not-built $name" >> "$out"; cp "$out.build.log" "$out.not-built-$name.log"; return; fi
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    timeout 900 ./build/compiler test-checker --seed 133 --part 5/8 > "$out.part5.out" 2>&1
    status=$?
    summary=$(grep 'test-checker:.*checks' "$out.part5.out" | tail -1)
    if [ $status = 0 ]; then verdict=SURVIVED; else verdict=caught; fi
    if [ "$name" = control ]; then if [ $status = 0 ]; then verdict=control-passes; else verdict=CONTROL-FAILS; fi; fi
    echo "$verdict $name status $status; $summary" >> "$out"
}
run control
grep -q control-passes "$out" || { echo "the control fails" >> "$out"; exit 1; }
for n in "$@"; do
    cp "$keep/rows.c" "$rows"; cp "$keep/census.c" "$census"
    name=$(python3 "$faults" "$tree" "$n") || { echo "not-applied $n" >> "$out"; continue; }
    run "$name"
done
cp "$keep/rows.c" "$rows"; cp "$keep/census.c" "$census"
echo "done" >> "$out"
