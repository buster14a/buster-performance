#!/usr/bin/env bash
# Builds one mutant tree at -O1 and runs the given test commands in it; prints one line per command: the mutant, the
# command, its exit status and its first failure (or its last line). A command stops at its first failure line (the
# suite has caught the mutant; the laptop's clang's fpclassify lines, main's too, and the oracle's retained files' lines before a failure don't count) or after 10 minutes, so
# that a mutant whose programs wait out their alarms doesn't hold the cores queue. Usage: run_mutant.sh NAME COMMAND...
set -u
here="$(cd "$(dirname "$0")" && pwd)"
name="$1"
shift
tree="$(python3 "$here/make_mutant.py" "$name")" || { echo "$name: no tree"; exit 1; }
cd "$tree"
export CORES_TITLE="Aligned objects (#136) mutant $name" CORES_LINK="https://github.com/buster14a/buster/issues/136"
if ! BUSTER_DEBUG_INFO=0 cores -n 2 -- ./build.sh > build.log 2>&1; then
    echo "$name: BUILD FAILED"; tail -5 build.log; exit 1
fi
for command in "$@"; do
    log="$tree/$(echo "$command" | tr ' /' '__').log"
    setsid timeout 600 cores -n 2 -- bash -c "./build/compiler $command" > "$log" 2>&1 &
    runner=$!
    first=""
    while kill -0 "$runner" 2> /dev/null; do
        first="$(grep -E '^test-[a-z0-9-]+: [a-z]' "$log" | grep -v -e fpclassify -e 'files retained' | head -1)"
        if [ -n "$first" ]; then
            kill -TERM -- "-$runner" 2> /dev/null
            break
        fi
        sleep 5
    done
    wait "$runner"
    status=$?
    first="${first:-$(grep -E '^test-[a-z0-9-]+: [a-z]' "$log" | grep -v -e fpclassify -e 'files retained' | head -1)}"
    echo "$name | $command | exit $status | ${first:-$(grep -v '^cores:' "$log" | tail -1)}"
done
