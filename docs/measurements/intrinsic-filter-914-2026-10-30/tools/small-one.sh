#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/codex-pr914-20261030"
case "$1" in
    capture-plain)
        DEBUGINFOD_URLS= taskset -c 2 gdb -q -nx -batch -ex "set \$capture_output = \"$PWD/results/plain.names.u32le\"" -x capture_names_binary.gdb --args fixed/compiler-0 -c -march=znver5 -o results/capture-plain.o plain.c
        ;;
    validate)
        for revision in base fixed; do
            for placement in 0 64 256; do
                for path in vector scalar; do
                    mode=()
                    if [ "$path" = scalar ]; then mode=(--scalar); fi
                    output="results/validation/plain-$revision-$placement-$path"
                    taskset -c 2 "placement-$revision/compiler-$placement" "${mode[@]}" -c -march=znver5 plain.c -o "$output.o"
                    cmp results/validation/plain-base-0-vector.o "$output.o"
                    taskset -c 2 "placement-$revision/compiler-$placement" "${mode[@]}" -march=znver5 plain.c -o "$output"
                    status=0
                    "$output" || status=$?
                    test "$status" = 21
                    printf 'plain validated %s %s %s exit=%d\n' "$revision" "$placement" "$path" "$status"
                done
            done
            taskset -c 2 "./setup-$revision" -c -march=znver5 plain.c -o "results/setup-$revision-plain.o"
            cmp results/validation/plain-base-0-vector.o "results/setup-$revision-plain.o"
        done
        sha256sum plain.c results/plain.names.u32le results/validation/plain-base-0-vector.o
        ;;
    whole)
        placement="$2"
        taskset -c 2 "placement-fixed/compiler-$placement" measure-compile --runs 51 --warmups 5 --keep --directory "$PWD/results" --reference "$PWD/placement-base/compiler-$placement" -- -c -march=znver5 plain.c
        ;;
    setup)
        taskset -c 2 ./setup_runner "$PWD/setup-base" "$PWD/setup-fixed" 51 1 -- -c -march=znver5 plain.c -o "$PWD/results/setup-measured-plain.o"
        ;;
    costs)
        for revision in base fixed; do taskset -c 2 "./cost-$revision" --format u32le results/plain.names.u32le; done
        ;;
    *) exit 2 ;;
esac
