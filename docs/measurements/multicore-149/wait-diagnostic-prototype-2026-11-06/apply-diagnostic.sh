#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
if [ "$#" -ne 1 ]; then
    printf 'usage: %s CLEAN_COMPILER_CHECKOUT\n' "$0" >&2
    exit 2
fi
script_dir=$(cd -- "$(dirname -- "$0")" && pwd -P)
compiler=$(cd -- "$1" && pwd -P)
expected=e1fa1575b0ee112ecac733e09eb727cbbad4df64
expected_tree=041bf7789e49e7cc1d5c20a9f76f183947376238
(cd "$script_dir" && sha256sum --check --status PATCHES.sha256) || { echo 'diagnostic: patch digest mismatch' >&2; exit 1; }
root=$(git -C "$compiler" rev-parse --show-toplevel)
[ "$root" = "$compiler" ] || { echo 'diagnostic: use the repository root' >&2; exit 1; }
[ "$(git -C "$compiler" rev-parse HEAD)" = "$expected" ] || { echo 'diagnostic: compiler revision does not match the pinned prototype base' >&2; exit 1; }
[ "$(git -C "$compiler" rev-parse 'HEAD^{tree}')" = "$expected_tree" ] || { echo 'diagnostic: compiler tree does not match the pinned prototype base' >&2; exit 1; }
index_entries=$(git -C "$compiler" ls-files -v)
[ -n "$index_entries" ] && printf '%s\n' "$index_entries" | awk 'substr($0, 1, 2) != "H " { bad = 1 } END { exit bad }' || {
    echo 'diagnostic: compiler index has assume-unchanged, skip-worktree or other unsupported flags' >&2
    exit 1
}
[ -z "$(git -C "$compiler" status --porcelain=v1 --untracked-files=all)" ] || { echo 'diagnostic: compiler checkout is not clean' >&2; exit 1; }
[ ! -e "$compiler/build" ] || { echo 'diagnostic: use a fresh checkout without an existing build directory' >&2; exit 1; }
[ -z "$(git -C "$compiler" ls-files --others --ignored --exclude-standard --directory)" ] || { echo 'diagnostic: ignored files are present; use a fresh checkout' >&2; exit 1; }
git -C "$compiler" apply --unidiff-zero --check "$script_dir/provisional-1522-build-repair.patch" "$script_dir/instrumentation.patch"
git -C "$compiler" apply --unidiff-zero "$script_dir/provisional-1522-build-repair.patch" "$script_dir/instrumentation.patch"
printf 'Applied provisional repair and diagnostic to %s. This is not a qualified compiler.\n' "$expected"
