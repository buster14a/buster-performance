#!/bin/bash
# run.sh TREE ARCH LIST LABEL: the list's commands by the tree's own compiler, as the row for ARCH runs them.
tree=$1; arch=$2; list=$3; label=$4
out=/home/user/keep/window/fix
cd "$tree" || exit 1
export BUSTER_HOST_ARCH=$arch
mapfile -d '' -t host_flags < <(./build.sh print-host-flags)
clang -dM -E "${host_flags[@]}" -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
start=$(date +%s)
timeout 3000 ./build/compiler parallel --jobs 1 "$list" > "$out/$label.log" 2>&1
status=$?
echo "$label: exit $status in $(( $(date +%s) - start )) s" >> "$out/progress.txt"
