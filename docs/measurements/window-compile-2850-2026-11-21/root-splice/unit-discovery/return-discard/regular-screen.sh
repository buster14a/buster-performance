#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);cd "$d/../window-regular-unit-screen";r="$d/5dc7d5cca";mkdir -p "$r"
export PATH="/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
./build.sh --config Develop >"$r/build.log" 2>&1
ln -f build/compiler "$r/compiler"
python "$d/regular-screen.py"
python "$d/regular-boundaries.py"
