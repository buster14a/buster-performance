#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Build only the adapted checker, then relink the other40 retained objects.
# This diagnostic compiler is NEVER an input to timing commands.
set -euo pipefail
tree=$(realpath -- "${1:?usage: build-probe.sh TREE RETAINED_OBJECTS NEW_OUTPUT OFFICIAL_CLANG PROBE_ADAPTER}")
retained=$(realpath -- "${2:?}")
output=${3:?}
clang=$(realpath -- "${4:?}")
adapter=$(realpath -- "${5:?}")
test ! -e "$output"
mkdir -p "$output"
output=$(realpath -- "$output")
source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
sed '$s/,$//' "$retained/8.json" > "$output/production-checker-command.json"
jq -e '.file == "src/buster/compiler/main_unit_checker.c" and (.arguments | type == "array") and (.arguments | length > 5)' "$output/production-checker-command.json" > /dev/null
mapfile -d '' arguments < <(jq -j '.arguments[] | . + "\u0000"' "$output/production-checker-command.json")
test "${#arguments[@]}" -gt 5
test "$(realpath -- "${arguments[0]}")" = "$clang"
arguments[0]=$clang
outputs=0
sources=0
for ((index=1; index<${#arguments[@]}; index++)); do
    if [[ "${arguments[index]}" = -o ]]; then
        index=$((index + 1))
        test "$index" -lt "${#arguments[@]}"
        arguments[index]="$output/checker.o"
        outputs=$((outputs + 1))
    elif [[ "${arguments[index]}" = src/buster/compiler/main_unit_checker.c ]]; then
        sources=$((sources + 1))
    fi
done
test "$outputs" = 1
test "$sources" = 1
objects=()
for index in {0..40}; do
    test -s "$retained/$index.o"
    if [[ "$index" = 8 ]]; then objects+=("$output/checker.o"); else objects+=("$retained/$index.o"); fi
done
cp -a "$tree/src" "$output/src"
"$adapter" "$tree/src/buster/compiler/c_check_actions.c" "$tree/src/buster/compiler/c_checker.c" \
    "$output/src/buster/compiler/c_check_actions.c" "$output/src/buster/compiler/c_checker.c" > "$output/adapter.log"
sha256sum "$clang" "$adapter" "$source_dir/build-probe.sh" "$retained/8.json" "$retained"/{0..40}.o > "$output/before-compile.sha256"
find "$tree/src" "$output/src" -type f -print0 | sort -z | xargs -0 sha256sum >> "$output/before-compile.sha256"
printf '%s\0' "${arguments[@]}" > "$output/checker-compile.argv0"
date -u '+before_checker_compile_utc=%Y-%m-%dT%H:%M:%SZ' > "$output/execution-receipt.txt"
(cd "$output" && "${arguments[@]}") > "$output/checker-build.log" 2>&1
link=("$clang" -no-pie -fuse-ld=wild "${objects[@]}" -lm -ldl -o "$output/compiler-probe")
printf '%s\0' "${link[@]}" > "$output/link.argv0"
"${link[@]}" > "$output/link.log" 2>&1
date -u '+after_probe_link_utc=%Y-%m-%dT%H:%M:%SZ' >> "$output/execution-receipt.txt"
sha256sum --check "$output/before-compile.sha256" > "$output/after-compile-check.txt"
sha256sum "$output/checker.o" "$output/compiler-probe" > "$output/built.sha256"
printf 'Diagnostic probe built; production sources and all41 retained objects verified unchanged.\n'
