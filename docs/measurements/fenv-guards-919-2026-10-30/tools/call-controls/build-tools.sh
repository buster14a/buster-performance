#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
clang=${1:?usage: build-tools.sh OFFICIAL_CLANG OUTPUT_DIRECTORY}
output=${2:?}
source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$output"
output=$(cd -- "$output" && pwd)
clang=$(realpath -- "$clang")
sha256sum "$clang" "$source_dir/probe_adapter.c" "$source_dir/validate_counts.c" "$source_dir/build-tools.sh" > "$output/tools-before-build.sha256"
printf '%s\0' "$clang" -std=c17 -O2 -Wall -Wextra -Werror "$source_dir/probe_adapter.c" -o "$output/probe_adapter" > "$output/adapter-compile.argv0"
"$clang" -std=c17 -O2 -Wall -Wextra -Werror "$source_dir/probe_adapter.c" -o "$output/probe_adapter"
printf '%s\0' "$clang" -std=c17 -O2 -Wall -Wextra -Werror "$source_dir/validate_counts.c" -o "$output/validate_counts" > "$output/reader-compile.argv0"
"$clang" -std=c17 -O2 -Wall -Wextra -Werror "$source_dir/validate_counts.c" -o "$output/validate_counts"
sha256sum --check "$output/tools-before-build.sha256" > "$output/tools-after-build-check.txt"
sha256sum "$output/probe_adapter" "$output/validate_counts" > "$output/tools-built.sha256"
"$clang" --version > "$output/clang-version.txt"
