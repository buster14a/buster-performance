#!/bin/bash
# parse.sh TREE ARCH LABEL: the workflow's "Parse the compiler source" step.
tree=$1; arch=$2; label=$3
out=/home/user/keep/bench-files/final
cd "$tree" || exit 1
export BUSTER_HOST_ARCH=$arch
mapfile -d '' -t host_flags < <(./build.sh print-host-flags)
./build/compiler parse -fsyntax-only "${host_flags[@]}" -Isrc -fwrapv -funsigned-char --predefines build/predefines.h -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c > "$out/$label.log" 2>&1
echo "$label: exit $?" >> "$out/progress.txt"
