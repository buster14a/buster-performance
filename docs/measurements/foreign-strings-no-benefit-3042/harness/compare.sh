#!/usr/bin/env bash
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
out=$1
head=$2
base=$(git rev-parse HEAD)
mkdir -p "$out"
bash "$here/inputs.sh" "$out/inputs"
for revision in base head; do
    if [ "$revision" = head ]; then
        git fetch -q --depth=1 origin "$head"
        git checkout -q --detach FETCH_HEAD
        test "$(git rev-parse HEAD)" = "$head"
    fi
    for variant in clean trace; do
        if [ "$variant" = trace ]; then bash "$here/instrument.sh"; fi
        printf 'BUILD %s %s %s\n' "$revision" "$variant" "$(git rev-parse HEAD)"
        ./build.sh --config Release
        dest="$out/$revision-$variant"
        bash "$here/cases.sh" ./build/compiler "$out/inputs" "$dest"
        if [ "$variant" = clean ]; then
            test_run=0
            ./build/compiler test-foreign --cross-check > "$out/test-$revision.log" 2>&1 || test_run=$?
            tail -n 55 "$out/test-$revision.log"
            printf 'CROSSCHECK %s status=%d\n' "$revision" "$test_run"
            test "$test_run" = 0
        fi
    done
    git restore src/buster/compiler/main.c src/buster/compiler/foreign_strings.c src/buster/compiler/foreign_strings_link.c
    rm -- src/buster/compiler/foreign_strings_3042_trace.h
done
for name in libgcc ordinary unique duplicate probe; do
    for variant in base-trace head-clean head-trace; do
        cmp "$out/base-clean/$name.elf" "$out/$variant/$name.elf"
        cmp "$out/base-clean/$name.stdout" "$out/$variant/$name.stdout"
    done
done
cmp "$out/base-clean/malformed.err" "$out/head-clean/malformed.err"
readelf -sW "$out/head-clean/duplicate.elf" | awk '$8 ~ /^(first_shared|second_shared|first_alias|first_wide|first_wide_alias|second_wide|first_wide4|first_wide4_alias|second_wide4)$/ {print $2, $3, $8}'
printf 'All complete ELF files, program outputs and malformed diagnoses match for %s and %s.\n' "$base" "$head"
