#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
clang=$(realpath -- "${1:?usage: build-stage-reader.sh OFFICIAL_CLANG NEW_OUTPUT_DIRECTORY}")
output=${2:?}
test ! -e "$output"
mkdir -p "$output"
output=$(realpath -- "$output")
source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
printf '%s  %s\n' c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67 "$clang" > "$output/expected-compiler.sha256"
sha256sum --check "$output/expected-compiler.sha256" > "$output/compiler-check.txt"
sha256sum "$clang" "$source_dir/stage_summary.c" "$source_dir/build-stage-reader.sh" > "$output/before-build.sha256"
printf '%s\0' "$clang" -std=c17 -O2 -Wall -Wextra -Werror "$source_dir/stage_summary.c" -lm -o "$output/stage_summary" > "$output/compile.argv0"
"$clang" -std=c17 -O2 -Wall -Wextra -Werror "$source_dir/stage_summary.c" -lm -o "$output/stage_summary"
sha256sum --check "$output/before-build.sha256" > "$output/after-build-check.txt"
sha256sum "$output/stage_summary" > "$output/built.sha256"
