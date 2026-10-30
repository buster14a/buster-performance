#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Read-only extraction of all matching function bodies, not objdump's
# single-name convenience option, which can conceal duplicate local symbols.
set -euo pipefail
Q=/home/david/buster-fast-bench/codex-pr912-20261030
variant=$1
case "$variant" in base|candidate) ;; *) exit 2 ;; esac
objdump -d -M intel "$Q/$variant/build/compiler" | \
  awk '/^[0-9a-f]+ <(check_input_expressions|check_literal_value)>:/ { emitting=1; functions++; } emitting { print; } emitting && /^$/ { emitting=0; } END { if (functions != 2) { exit 1; } }' \
  > "$Q/evidence/assembly-$variant.txt"
sha256sum "$Q/evidence/assembly-$variant.txt"
