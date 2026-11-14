#!/bin/bash
# One build of a tree with the given environment (VAR=VALUE...), timed; its log beside the run's other files.
set -u
tree=${1:?tree}
out=$(realpath -m "${2:?out}")
shift 2
mkdir -p "$out"
cd "$tree"
TIMEFORMAT='%R %U %S'
{ time env "$@" ./build.sh ${BUILD_ARGS:-} > "$out/build.log" 2>&1; } 2> "$out/time.txt"
status=$?
echo "status=$status time=$(cat "$out/time.txt")"
tail -5 "$out/build.log"
exit $status
