#!/usr/bin/env bash
# Standalone sanitized invocation of the committed metadata/scaling tests; no production source is edited.
set -euo pipefail
root=$(realpath "${1:?usage: focus.sh BUSTER_SOURCE}")
here=$(cd "$(dirname "$0")" && pwd)
temporary=$(mktemp -d "$root/build/vla-focus-XXXXXX")
trap 'rm -rf "$temporary"' EXIT
sed 's/^#define BUSTER_ELSEWHERE inline __attribute__((noinline))$/#define BUSTER_ELSEWHERE static/' "$root/src/buster/compiler/main.c" > "$temporary/probe_main.c"
cp "$here/focus.c" "$temporary/focus.c"
clang -O0 -march=native -I"$root/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Wno-unused-function -ffunction-sections -fdata-sections -Wl,--gc-sections -fsanitize=address,undefined -fno-sanitize=function -fno-omit-frame-pointer "$temporary/focus.c" -pthread -lm -o "$temporary/focus"
ASAN_OPTIONS=detect_leaks=1 UBSAN_OPTIONS=halt_on_error=1 "$temporary/focus"
