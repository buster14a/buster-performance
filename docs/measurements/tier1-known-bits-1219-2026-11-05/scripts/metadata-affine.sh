#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 measurement receipt' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
"$HOME/buster-fast-bench/exclusive.sh" bash -s <<'INNER'
uname -a
grep -m1 'model name' /proc/cpuinfo
/usr/bin/clang --version
/usr/bin/ld --version | head -1
/usr/bin/objdump --version | head -1
env VALGRIND_LIB="$PWD/valgrind/lib/valgrind" "$PWD/valgrind/bin/valgrind" --tool=callgrind --version
printf 'Build settings: BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0; timing/count CPU=2\n'
printf 'Baseline source: d6cc7ed2634e0bad8993b435745ca8ebe722ebc4\nCandidate source: 08545d5c765912a08967dd66e19298c28f1eedb8\n'
sha256sum /usr/bin/clang /usr/bin/objdump tools/gap tools/gap.c base/build/compiler affine/build/compiler affine-source.tar.gz
sha256sum affine/src/buster/compiler/tier1_select.c affine/src/buster/compiler/tier1_select_burs_test.c affine/src/buster/compiler/tier1_select_test.c affine/docs/tier1-selection.md
INNER
