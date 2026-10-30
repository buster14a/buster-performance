#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -uo pipefail
inv_root=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-cecd-inventory
inv_mode=${1:?trace or untraced required}
case "$inv_mode" in
    trace) inv_compiler="$inv_root/trace-cecd4962/build/compiler"; inv_stdout=sqlite.stdout; inv_stderr=sqlite.trace ;;
    untraced) inv_compiler=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-propagated-qualification/snapshot-address-native/build/compiler; inv_stdout=sqlite.untraced.stdout; inv_stderr=sqlite.untraced.stderr ;;
    *) exit 2 ;;
esac
test ! -e "$inv_root/$inv_mode-compile.status" || exit 2
test ! -e "$inv_root/$inv_stdout" || exit 2
test ! -e "$inv_root/sqlite.output.o" || exit 2
cd "$(cat "$inv_root/sqlite-working-directory.txt")" || exit 2
mapfile -d '' -t inv_args < "$inv_root/sqlite-command.argv0"
printf 'cwd=%s\nCORES=%s\nCORES_CPUS=%s\nSOURCE_DATE_EPOCH=%s\n' "$PWD" "${CORES-}" "${CORES_CPUS-}" "${SOURCE_DATE_EPOCH-}" > "$inv_root/$inv_mode-command.txt"
printf '%s\0' "$inv_compiler" "${inv_args[@]}" > "$inv_root/$inv_mode-command.argv0"
"$inv_compiler" "${inv_args[@]}" > "$inv_root/$inv_stdout" 2> "$inv_root/$inv_stderr"
inv_compile_rc=$?
printf '%s\n' "$inv_compile_rc" > "$inv_root/$inv_mode-compile.status"
if [ "$inv_compile_rc" -eq 0 ]; then
    mv "$inv_root/sqlite.output.o" "$inv_root/sqlite.$inv_mode.o"
    inv_rename_rc=$?
    printf '%s\n' "$inv_rename_rc" > "$inv_root/$inv_mode-rename.status"
    if [ "$inv_rename_rc" -ne 0 ]; then exit "$inv_rename_rc"; fi
fi
exit "$inv_compile_rc"
