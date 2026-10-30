#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -uo pipefail
qual_receipt=$1
qual_label=$2
shift 2
printf 'cwd=%s\nCORES=%s\nCORES_CPUS=%s\n' "$PWD" "${CORES-}" "${CORES_CPUS-}" > "$qual_receipt/$qual_label-command.txt"
printf 'argv=' >> "$qual_receipt/$qual_label-command.txt"
printf '%q ' "$@" >> "$qual_receipt/$qual_label-command.txt"
printf '\n' >> "$qual_receipt/$qual_label-command.txt"
printf '%s\0' "$@" > "$qual_receipt/$qual_label-argv.nul"
"$@" > "$qual_receipt/$qual_label.log" 2>&1
qual_rc=$?
printf '%s\n' "$qual_rc" > "$qual_receipt/$qual_label.status"
exit "$qual_rc"
