#!/bin/bash
# #2086 on the 9700X: test-parser without files (plain) and on the repository's translation units (units, as
# tools/ci/correctness.tests runs it), by three builds: clear (this branch with #2087's clearing of each parser's scratch
# before every unit put back), reuse (this branch: no clearing) and reuse2 (a copy of reuse, the A/A floor). Every
# build reads the final tree's sources. Each run is one hold of the lock: the compiler's time-runs, one warm-up and one
# timed run, pinned to CPU 2. The builds' order rotates from round to round.
set -u
D=~/buster-fast-bench/2086-claude
export EXCLUSIVE_OWNER=claude-2086-k5 EXCLUSIVE_TITLE="Parser K5 stale scratch (#2086)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2086
rounds=${ROUNDS:-3}
mkdir -p $D/results
cd $D/final || exit 1
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $D/predefines.h
sources_file=$(mktemp)
./build.sh print-sources > "$sources_file"
mapfile -d '' -t sources < "$sources_file"
rm "$sources_file"
units=()
for unit in "${sources[@]}"; do
    [[ "${unit##*/}" == main_unit_* ]] || units+=("$unit")
done
mapfile -d '' -t host_flags < <(./build.sh print-host-flags)
printf '%s\n' "${units[@]}" > $D/results/units.txt
printf '%s\n' "${host_flags[@]}" > $D/results/host-flags.txt
builds=(clear reuse reuse2)
for round in $(seq 1 $rounds); do
    for command in ${COMMANDS:-plain units}; do
        for k in 0 1 2; do
            build=${builds[$(( (k + round - 1) % 3 ))]}
            if [ $command = plain ]; then
                args=()
            else
                args=(--files-only "${host_flags[@]}" -Isrc -fwrapv -funsigned-char --predefines $D/predefines.h "${units[@]}")
            fi
            ~/buster-fast-bench/exclusive.sh taskset -c 2 $D/bin/reuse time-runs --runs 1 --warmups 1 --build $build $D/bin/$build --list test-parser "${args[@]}" > $D/results/$command-$build-$round.txt 2>&1
            echo "$round $command $build: $(grep -E '^run 1 list 1:' $D/results/$command-$build-$round.txt)"
        done
    done
done
echo "== done $(date -u +%FT%TZ)"
