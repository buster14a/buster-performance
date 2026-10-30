#!/bin/bash
# Runs test-calling-convention --cross-check for seeds FIRST to LAST through the core queue, one at a time, each
# seed's log in logs/TAG-seed-N.log, and prints each seed's failure lines. It runs a copy of the build
# (bin/compiler-TAG, made when the sweep starts), so that the worktree may be rebuilt while it runs: the copy is also
# our side's compiler (--buster defaults to /proc/self/exe).
# Usage: sweep.sh TAG FIRST LAST [extra options]
W=/home/david/dev/ai/claude/buster/.claude/worktrees/agent-aed5708ccc63e8d99
S=/home/david/.cache/claude-solve-137-147-148/abi
tag=$1
first=$2
last=$3
shift 3
mkdir -p "$S/logs" "$S/tmp" "$S/bin"
binary="$S/bin/compiler-$tag"
[ -x "$binary" ] || cp "$W/build/compiler" "$binary" || exit 1
for seed in $(seq "$first" "$last"); do
    log="$S/logs/$tag-seed-$seed.log"
    start=$(date +%s)
    TMPDIR="$S/tmp" CORES_TITLE="#137 compiled worlds rest" CORES_LINK="https://github.com/buster14a/buster/issues/137" \
        timeout 3600 cores -n 3 -- "$binary" test-calling-convention --cross-check --seed "$seed" "$@" > "$log" 2>&1
    status=$?
    end=$(date +%s)
    failed=$(grep -cE 'FAIL|failed: [1-9]|[1-9][0-9]* failed|failures [1-9]' "$log")
    echo "seed $seed: status $status, $((end - start)) s, failure lines $failed"
    grep -E '^cross-check +compiled' "$log" | sed 's/^/    /'
    grep -E 'cross-check.*[1-9][0-9]* failed|^test-calling-convention:' "$log" | head -5 | sed 's/^/    /'
done
