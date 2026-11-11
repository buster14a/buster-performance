#!/bin/bash
# The processes test-preprocessor --clang --part K/4 starts with a clang server: each part traced for execve and the
# fork calls (strace -f), then
#   - results/children/NAME-partK-execs.txt: its successful execs counted by program and first two arguments, with the
#     temporary directories' names folded to TMP (as served-oracles-remaining-2071-2026-11-11's children.sh counts them);
#   - results/children/NAME-partK-kinds.txt: its clang processes by kind (classify.py: the arguments and the program
#     whose process started them).
# Usage: children.sh NAME EXECUTABLE SERVER OUTPUT_DIRECTORY [PART...] (from the buster checkout's root)
set -euo pipefail
name=$1
executable=$2
server=$3
output=$4
shift 4
parts=("$@")
[ ${#parts[@]} -ne 0 ] || parts=(1 2 3 4)
here=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$output"
for part in "${parts[@]}"; do
    trace=$(mktemp)
    BUSTER_ORACLE_CACHE=check BUSTER_PARALLEL_CPUS=1 strace -f -qq -e trace=execve,clone,clone3,fork,vfork -e signal=none -o "$trace" \
        "$executable" test-preprocessor --clang --jobs 1 --part "$part/4" --clang-server "$server" > "$output/$name-part$part.log" 2>&1 || true
    grep -v ENOENT "$trace" | grep 'execve(' | grep -v ' = -1 ' |
        sed -E 's/^[0-9]+ +execve\("([^"]*)", \[("[^"]*")?(, "([^"]*)")?(, "([^"]*)")?.*/\1 \4 \6/' |
        sed -E 's#/tmp/buster-pp-test-[A-Za-z0-9]+#TMP#g; s#/tmp/buster-[a-z-]+-[A-Za-z0-9]+#TMP#g' | sort | uniq -c | sort -rn > "$output/$name-part$part-execs.txt"
    python3 -I "$here/classify.py" "$trace" > "$output/$name-part$part-kinds.txt"
    rm -f "$trace"
done
