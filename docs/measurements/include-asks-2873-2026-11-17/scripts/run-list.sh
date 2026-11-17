#!/bin/bash
# run-list.sh TREE ARCH LIST LABEL JOBS: the list's commands by the tree's own compiler, as the row for ARCH runs them,
# with this container's corpus and JOBS commands at once.
tree=$1; arch=$2; list=$3; label=$4; jobs=$5
out=/home/user/keep/bench-files/final
cd "$tree" || exit 1
export BUSTER_HOST_ARCH=$arch BUSTER_CORPUS=/home/user/corpus BUSTER_PARALLEL_CPUS=4
mapfile -d '' -t host_flags < <(./build.sh print-host-flags)
clang -dM -E "${host_flags[@]}" -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
start=$(date +%s)
timeout 3000 ./build/compiler parallel --jobs "$jobs" "$list" > "$out/$label.log" 2>&1
status=$?
echo "$label: exit $status in $(( $(date +%s) - start )) s" >> "$out/progress.txt"
