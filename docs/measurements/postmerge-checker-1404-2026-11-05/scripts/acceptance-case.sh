#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -uo pipefail
name=$1
shift
status=0
"$BUSTER_COMPILER" "$@" > "$BUSTER_1404_OUTPUT/$name.log" 2>&1 || status=$?
printf '%s\t%s\n' "$name" "$status" >> "$BUSTER_1404_OUTPUT/status.tsv"
cat "$BUSTER_1404_OUTPUT/$name.log"
exit "$status"
