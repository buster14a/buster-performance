#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);cd "$d/../window-constant-unit-typed-screen";r="$d/5c6a1ebac";mkdir -p "$r"
export PATH="/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
./build.sh --config Develop >"$r/build.log" 2>&1
ln -f build/compiler "$r/compiler"
python "$d/typed-unit-screen.py"
