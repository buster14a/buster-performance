#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# tests.sh WAY NAME COMMAND...: one test command of the tree WAY (main or head), from its root, its output and status in
# results/tests/WAY-NAME.txt. Run it under the lock (queue.sh).
set -u
cd "$(dirname "$0")"
way=$1 name=$2
shift 2
mkdir -p results/tests
head -1 /var/lib/buster-9700x/owner > "results/tests/$way-$name.holder.txt"
start=$(date +%s%N)
(cd "$way" && "$@") > "results/tests/$way-$name.txt" 2>&1
status=$?
end=$(date +%s%N)
echo "$way $name status $status $(awk -v a="$start" -v b="$end" "BEGIN { printf \"%.1f\", (b - a) / 1e9 }") s: $*" >> results/tests/status.txt
