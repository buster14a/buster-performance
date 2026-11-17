#!/bin/bash
# checker5.sh TREE ARCH LABEL: the node machine's tests (test-checker's part 5 of 8) by the tree's compiler.
tree=$1; arch=$2; label=$3
out=/home/user/keep/window/fix
cd "$tree" || exit 1
export BUSTER_HOST_ARCH=$arch
start=$(date +%s)
timeout 2400 ./build/compiler test-checker --seed 133 --part 5/8 > "$out/$label.log" 2>&1
status=$?
echo "$label: exit $status in $(( $(date +%s) - start )) s: $(tail -1 "$out/$label.log" | cut -c1-200)" >> "$out/progress.txt"
