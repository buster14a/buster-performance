#!/bin/bash
# files.sh BINARY: test-parser on the build's translation units (as tools/ci/correctness.tests runs it), from the main tree.
set -euo pipefail
binary="$1"
shift
cd ~/buster-fast-bench/2086-claude/main
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
sources_file=$(mktemp)
./build.sh print-sources > "$sources_file"
mapfile -d '' -t sources < "$sources_file"
rm "$sources_file"
units=()
for unit in "${sources[@]}"; do
    [[ "${unit##*/}" == main_unit_* ]] || units+=("$unit")
done
mapfile -d '' -t host_flags < <(./build.sh print-host-flags)
"$binary" test-parser "$@" --files-only "${host_flags[@]}" -Isrc -fwrapv -funsigned-char --predefines build/predefines.h "${units[@]}"
