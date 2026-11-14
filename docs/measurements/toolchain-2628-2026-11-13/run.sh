#!/usr/bin/env bash
# #2628: clean builds of one tree with the host's clang 23.1.1 (BUSTER_TOOLCHAIN=path) and CI's 23.1.4 (ci), Develop
# and Release (-g), alternating, two rounds; each build its own hold of the 9700X lock, timed inside it.
set -euo pipefail
cd ~/buster-fast-bench/2628-claude/tree
out=~/buster-fast-bench/2628-claude/results.txt
: > "$out"
export EXCLUSIVE_OWNER=claude-2628 EXCLUSIVE_TITLE="Build with CI's toolchain (#2628)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2628
for round in 1 2; do
    for toolchain in path ci; do
        for config in Develop Release; do
            log=~/buster-fast-bench/2628-claude/log-$round-$toolchain-$config.txt
            ~/buster-fast-bench/exclusive.sh env BUSTER_TOOLCHAIN=$toolchain bash -c '
                rm -rf build
                start=${EPOCHREALTIME//[!0-9]/}
                ./build.sh --config "$1" > "$2" 2>&1
                end=${EPOCHREALTIME//[!0-9]/}
                printf "wall %s\n" "$(( (end - start) / 1000 ))" >> "$2"' timed "$config" "$log"
            printf '%s %s %s %s ms | %s\n' "$round" "$toolchain" "$config" "$(sed -n 's/^wall //p' "$log")" \
                "$(grep -o 'the build took [0-9.]* s.*' "$log" | head -1)" >> "$out"
            grep -o "configuring build/cmake/native with [^:]*" "$log" | head -1 >> "$out"
        done
    done
done
echo done >> "$out"
