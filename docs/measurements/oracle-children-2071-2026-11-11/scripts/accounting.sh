#!/bin/bash
# The CPU time a runner counts for each converted command against all of it: each command run under reap (reap.c, a
# child subreaper), before (main's executable) and after (this branch's), with a clang server, an empty check-mode
# cache and the inventory's CPUs. reap prints the command's CPU time as its wait gives it (what the parallel runner's
# rusage counts), the CPU time with the orphans it adopted and waited for (a forked part's server that outlived the
# part), and how many orphans there were. One line per run in results/accounting/accounting.tsv.
# Usage: accounting.sh REAP BEFORE_EXECUTABLE AFTER_EXECUTABLE SERVER OUTPUT_DIRECTORY [COMMAND...] (from the buster
# checkout's root; COMMAND is part1 to part4 or units, all by default)
set -euo pipefail
reap=$1
before=$2
after=$3
server=$4
output=$5
shift 5
commands=("$@")
[ ${#commands[@]} -ne 0 ] || commands=(part1 part2 part3 part4 units)
mkdir -p "$output"
units=(-target x86_64-pc-linux-gnu -march=x86-64 -Isrc -fwrapv -funsigned-char -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c)
for command in "${commands[@]}"; do
    for side in before after; do
        executable=$before
        [ "$side" = before ] || executable=$after
        cache=$(mktemp -d)
        case $command in
            part[1-4]) cpus=2; parallel=1; arguments=(test-preprocessor --clang --jobs 1 --part "${command#part}/4" --clang-server "$server") ;;
            units) cpus=2,3; parallel=2; arguments=(test-preprocessor --clang "${units[@]}" --clang-server "$server") ;;
        esac
        status=0
        line=$(XDG_CACHE_HOME=$cache BUSTER_ORACLE_CACHE=check BUSTER_PARALLEL_CPUS=$parallel taskset -c "$cpus" "$reap" "$executable" "${arguments[@]}" 2>&1 >"$output/$command-$side.log" | tee "$output/$command-$side.errors" | tail -1) || status=$?
        rm -rf "$cache"
        printf '%s\t%s\t%s\t%s\n' "$command" "$side" "$status" "$line" | tee -a "$output/accounting.tsv"
    done
done
