#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);cd "$d/../window-constant-unit-screen";r="$d/180e3b23e";mkdir -p "$r"
export PATH="/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
./build.sh --config Develop >"$r/build.log" 2>&1
ln -f build/compiler "$r/compiler"
python "$d/unit-screen.py"
