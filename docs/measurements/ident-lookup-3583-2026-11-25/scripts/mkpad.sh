#!/bin/bash
# mkpad.sh TREE NAME PAD: the harness of TREE's c_direct.c with a PAD-nop function ahead of the lexer's code (0 for
# none), as bin/direct-NAME-pPAD: another placement of the same code (buster#3593's note).
set -euo pipefail
tree=$1; name=$2; pad=$3
work=$(mktemp -d /tmp/claude-0/pad.XXXXXX)
cp -r "$tree/src" "$work/"
if [ "$pad" != 0 ]; then
    nops=$(printf 'nop\\n%.0s' $(seq "$pad"))
    python3 - "$work/src/buster/compiler/c_direct_lex.c" "$nops" <<'PY'
import sys
p, nops = sys.argv[1], sys.argv[2]
s = open(p).read()
anchor = 'typedef struct FastArena FastArena;'
assert s.count(anchor) == 1
s = s.replace(anchor, 'static __attribute__((used, noinline)) void fast_layout_pad(void) { __asm__ volatile("' + nops + '"); }\n' + anchor)
open(p, 'w').write(s)
PY
fi
cd "$tree"
PATH="$(bash tools/ci/session-toolchain.sh stage):$PATH"
mapfile -d '' -t flags < <(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release)
cd "$work"
clang "${flags[@]}" -g -static src/buster/compiler/c_direct.c /home/user/ceil/direct_main.c -o "/home/user/ceil/bin/direct-$name-p$pad" -Wno-error
rm -rf "$work"
