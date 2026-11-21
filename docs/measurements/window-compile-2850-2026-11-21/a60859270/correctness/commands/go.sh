#!/bin/bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/.." && pwd)
rev=5882f7c2a; parent=b86eadcbd
r="$d/$rev";mkdir -p "$r"
until grep -q 'published as build/compiler' "$w/pure-interior-study/current-build.log";do if grep -Eq ' error:|build stopped|FAILED:' "$w/pure-interior-study/current-build.log";then exit 1;fi;sleep 3;done
ln -f "$w/window-constants/build/compiler" "$r/compiler"
cd "$w/window-constants"
CC23=~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
"$r/compiler" --node-window-constants --time-stages --lanes 1 -c tests/checker/node-window-constants.c -o "$r/fixture.o" >"$r/fixture.out" 2>"$r/fixture.err"
rg 'constant-window:' "$r/fixture.err"
CORES_TITLE='Validate real checked integer window values, source locations and attested ownership' CORES_LINK=https://github.com/buster14a/buster/issues/2850 cores -n 1 -- bash -c '"$1" test-checker --clang "$2" --fixtures tests --part 5/8 >"$3/part5.log" 2>&1 && "$1" test-checker --clang "$2" --fixtures tests --attested >"$3/attested.log" 2>&1' _ "$r/compiler" "$CC23" "$r"
