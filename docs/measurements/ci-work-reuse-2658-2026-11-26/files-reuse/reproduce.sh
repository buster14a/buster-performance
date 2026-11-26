#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail

bundle=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
checkout=${1:?usage: reproduce.sh BUSTER_CHECKOUT [OUTPUT_DIRECTORY]; set CC to clang 23.1.4}
output=${2:-"$bundle/run"}
compiler=${CC:-clang}
base_revision=${BASE_REVISION:-8e4d32879e17b7d9548cad54257a2f8461328366}
source_file="$checkout/src/buster/compiler/c_files_test.c"
mkdir -p "$output"
scratch_dir=$(mktemp -d "${TMPDIR:-/tmp}/buster-files-reuse.XXXXXX")
trap 'rm -rf -- "$scratch_dir"' EXIT

"$compiler" --version > "$output/compiler.txt" 2>&1
date -u '+%Y-%m-%dT%H:%M:%SZ' > "$output/recorded-at.txt"
git -C "$checkout" rev-parse HEAD > "$output/checkout-head.txt"
git -C "$checkout" rev-parse "$base_revision" > "$output/base-revision.txt"
git -C "$checkout" rev-parse 'HEAD^{tree}' > "$output/checkout-tree.txt"
cp "$source_file" "$output/c_files_test.c"
sha256sum "$output/c_files_test.c" > "$output/source-sha256.txt"
git -C "$checkout" diff "$base_revision" -- src/buster/compiler/c_files_test.c > "$output/source.patch"
test "$(git -C "$checkout" rev-parse HEAD)" = "$(cat "$output/checkout-head.txt")"
cmp "$source_file" "$output/c_files_test.c"

"$compiler" -std=c17 -O2 -Wall -Wextra -Werror "$bundle/extract.c" -o "$scratch_dir/extract" > "$output/extractor-compile.log" 2>&1
"$scratch_dir/extract" "$output/c_files_test.c" "$bundle/plumbing.h" "$output" > "$output/extraction.log" 2>&1

"$compiler" -std=c17 -O2 -Wall -Wextra -Werror -fsanitize=address,undefined -g "$output/harness.c" -o "$scratch_dir/harness" > "$output/harness-compile.log" 2>&1
printf 'case\texpected_exit\tactual_exit\n' > "$output/results.tsv"
if ASAN_OPTIONS=detect_leaks=0 "$scratch_dir/harness" > "$output/harness.log" 2>&1; then
    status=0
else
    status=$?
fi
printf 'harness_asan_ubsan\t0\t%s\n' "$status" >> "$output/results.tsv"
test "$status" -eq 0

"$compiler" -std=c17 -O2 -Wall -Wextra -Werror -fsanitize=address,undefined -g -I "$output" "$bundle/allocation-failure.c" -Wl,--wrap=realloc -o "$scratch_dir/allocation-failure" > "$output/allocation-failure-compile.log" 2>&1
if ASAN_OPTIONS=detect_leaks=0 "$scratch_dir/allocation-failure" > "$output/allocation-failure.log" 2>&1; then
    status=0
else
    status=$?
fi
printf 'allocation_failure_asan_ubsan\t0\t%s\n' "$status" >> "$output/results.tsv"
test "$status" -eq 0

for source in "$output"/mutant_*.c; do
    name=${source##*/}
    name=${name%.c}
    "$compiler" -std=c17 -O2 -Wall -Wextra -Werror "$source" -o "$scratch_dir/$name" > "$output/$name-compile.log" 2>&1
    if "$scratch_dir/$name" > "$output/$name.log" 2>&1; then
        status=0
    else
        status=$?
    fi
    printf '%s\t1\t%s\n' "$name" "$status" >> "$output/results.tsv"
    test "$status" -eq 1
done
cat "$output/results.tsv"
