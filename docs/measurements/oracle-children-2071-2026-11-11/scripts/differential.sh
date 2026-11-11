#!/bin/bash
# --differential runs of the converted commands: test-preprocessor --clang's four parts and its run on the repository's
# units (with -march=native and -march=x86-64), each with a clang server, an empty check-mode cache and the inventory's
# CPUs. Every run the server takes also runs as before, and a difference fails the command; each log ends with the
# command's oracle cache and clang server lines, and results/differential/status.tsv has each command's exit status.
# Usage: differential.sh EXECUTABLE SERVER OUTPUT_DIRECTORY [COMMAND...] (from the buster checkout's root; COMMAND is
# part1 to part4, units-native or units-x86-64, all by default)
set -euo pipefail
executable=$1
server=$2
output=$3
shift 3
commands=("$@")
[ ${#commands[@]} -ne 0 ] || commands=(part1 part2 part3 part4 units-native units-x86-64)
mkdir -p "$output"
units=(-target x86_64-pc-linux-gnu -Isrc -fwrapv -funsigned-char -DBUSTER_COMPLETE_DRIVER=1 src/buster/compiler/main.c src/buster/compiler/*_benchmark.c)
for command in "${commands[@]}"; do
    cache=$(mktemp -d)
    case $command in
        part[1-4]) cpus=2; parallel=1; arguments=(test-preprocessor --clang --jobs 1 --part "${command#part}/4") ;;
        units-native) cpus=2,3; parallel=2; arguments=(test-preprocessor --clang -march=native "${units[@]}") ;;
        units-x86-64) cpus=2,3; parallel=2; arguments=(test-preprocessor --clang -march=x86-64 "${units[@]}") ;;
    esac
    status=0
    XDG_CACHE_HOME=$cache BUSTER_ORACLE_CACHE=check BUSTER_PARALLEL_CPUS=$parallel taskset -c "$cpus" "$executable" "${arguments[@]}" --clang-server "$server" --differential \
        > "$output/$command.log" 2>&1 || status=$?
    rm -rf "$cache"
    printf '%s\t%s\t%s\n' "$command" "$status" "$(grep 'clang server (' "$output/$command.log" | tail -1)" | tee -a "$output/status.tsv"
done
