#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
variant=$1
case "$variant" in base|candidate) ;; *) exit 2 ;; esac
cd "$Q/$variant"
date -u
clang --version
sha256sum build.sh src/buster/compiler/c_check_actions.c src/buster/compiler/c_check_literals.c
taskset -c 0-7 ./build.sh shifts "$Q/placements-$variant" main.c 0 64 512
sha256sum build/compiler "$Q/placements-$variant"/compiler-*
for executable in "$Q/placements-$variant"/compiler-*; do
    printf '%s\n' "$executable"
    nm -n "$executable" | awk '$3 == "check_input_expressions" || $3 == "check_literal_value" || $3 == "main" { print }'
done
date -u
