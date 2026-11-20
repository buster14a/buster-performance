#!/bin/bash
# make-fault-patch.sh OUT [TREE]: the working tree's code for a 9700X fault round's label: the piece's nine files
# (TREE's, default /home/user/buster-x1) over main 00faef7dd's src and tools (the labels' lineage), with no switch.
out=$1; tree=${2:-/home/user/buster-x1}
s=/tmp/claude-0/-home-user/750b08ae-4cd9-565b-b66d-6cb5ef06cd50/scratchpad/xbf
rm -rf $s && mkdir -p $s/a $s/b || exit 1
git -C "$tree" archive 00faef7dd src tools | tar -x -C $s/a
git -C "$tree" archive 00faef7dd src tools | tar -x -C $s/b
for f in src/buster/compiler/c_check_node_census.c src/buster/compiler/c_check_node_census_test.c src/buster/compiler/c_check_node_machine_facts.c \
         src/buster/compiler/c_check_node_machine_front.c src/buster/compiler/c_check_node_machine_reader.c src/buster/compiler/c_check_node_machine_rows.c \
         src/buster/compiler/c_check_node_machine_window.c src/buster/compiler/main.c tools/ci/build_regression.c; do
    cp "$tree/$f" "$s/b/$f" || exit 1
done
(cd $s && diff -ruN a b) > "$out"
grep -c "^+++ " "$out"; wc -c < "$out"
