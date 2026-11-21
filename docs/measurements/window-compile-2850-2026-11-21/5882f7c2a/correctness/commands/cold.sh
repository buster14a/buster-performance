#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);r="$d/1d6c881a6";mkdir -p "$r";cd "$d/../window-constants-cold"
export PATH="~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
./build.sh --config Develop >"$r/build.log" 2>&1
ln -f build/compiler "$r/compiler"
"$r/compiler" --node-window-constants --time-stages --lanes 1 -g -c tests/checker/node-window-constants.c -o "$r/fixture.o" >"$r/fixture.out" 2>"$r/fixture.err"
rg '^constant-window: roots=4 removed=10' "$r/fixture.err"
"$r/compiler" test-checker --fixtures tests --clang "$(command -v clang)" --part 5/8 > "$r/part5.log" 2>&1
python "$d/perf.py" 1d6c881a6
