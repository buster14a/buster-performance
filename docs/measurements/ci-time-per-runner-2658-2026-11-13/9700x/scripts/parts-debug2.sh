#!/bin/bash
# What test-ssa-source's running part waits on: each non-zombie child of the command and its children, with their
# states and kernel wait channels, sampled every 0.5 s.
set -u
tree=$HOME/buster-fast-bench/2658-claude/glue
exe=$tree/build/cmake/x86-64-g0/Release/compiler
cd "$tree"
mapfile -t files < <(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt | head -80)
BUSTER_PARALLEL_CPUS=4 taskset -c 4,12,5,13 "$exe" test-ssa-source --typed --tier1 "${files[@]}" > /tmp/parts-debug.out 2>&1 &
main=$!
printf 'main %s wchan=%s\n' "$main" "$(cat /proc/$main/wchan 2>/dev/null)"
for i in $(seq 12); do
    sleep 0.5
    for k in $(ps -o pid= --ppid $main 2>/dev/null); do
        s=$(ps -o stat= -p $k | tr -d ' ')
        [ "$s" = Z ] && continue
        printf '%s part %s stat=%s wchan=%s age=%s\n' "$i" "$k" "$s" "$(cat /proc/$k/wchan 2>/dev/null)" "$(ps -o etimes= -p $k | tr -d ' ')"
        for g in $(ps -o pid= --ppid $k 2>/dev/null); do
            printf '      child %s stat=%s wchan=%s cmd=%s\n' "$g" "$(ps -o stat= -p $g | tr -d ' ')" "$(cat /proc/$g/wchan 2>/dev/null)" "$(ps -o args= -p $g | cut -c1-120)"
        done
    done
    printf '%s main wchan=%s zombies=%s\n' "$i" "$(cat /proc/$main/wchan 2>/dev/null)" "$(ps -o stat= --ppid $main | grep -c Z)"
    kill -0 $main 2>/dev/null || break
done
wait $main; echo status=$?
