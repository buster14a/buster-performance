#!/bin/bash
# The processes test-preprocessor --clang --part K/4 still starts with a clang server: each part traced for execve
# (strace -f), then its successful execs counted by program and first two arguments, with the temporary directories'
# names folded to TMP. results/children/partK-execs.txt are its output.
# Usage: children.sh EXECUTABLE SERVER OUTPUT_DIRECTORY (from the buster checkout's root)
set -euo pipefail
executable=$1
server=$2
output=$3
mkdir -p "$output"
for part in 1 2 3 4; do
    trace=$(mktemp)
    BUSTER_ORACLE_CACHE=check BUSTER_PARALLEL_CPUS=1 strace -f -qq -e trace=execve -e signal=none -o "$trace" \
        "$executable" test-preprocessor --clang --jobs 1 --part "$part/4" --clang-server "$server" > "$output/part$part.log" 2>&1 || true
    grep -v ENOENT "$trace" | grep 'execve(' | grep -v ' = -1 ' |
        sed -E 's/^[0-9]+ +execve\("([^"]*)", \[("[^"]*")?(, "([^"]*)")?(, "([^"]*)")?.*/\1 \4 \6/' |
        sed -E 's#/tmp/buster-pp-test-[A-Za-z0-9]+#TMP#g; s#/tmp/buster-[a-z-]+-[A-Za-z0-9]+#TMP#g' | sort | uniq -c | sort -rn > "$output/part$part-execs.txt"
    rm -f "$trace"
done
