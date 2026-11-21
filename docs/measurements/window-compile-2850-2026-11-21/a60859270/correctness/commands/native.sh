#!/usr/bin/env bash
set -eu
d=$(cd "$(dirname "$0")" && pwd);cd "$d/../window-constant-native-oracle";r="$d/a60859270/native";mkdir -p "$r"
export PATH="~/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH"
./build.sh --config Develop >"$r/build.log" 2>&1
ln -f build/compiler "$r/witness-compiler"
python "$d/deletions.py" "$r/witness-compiler"
python "$d/natives.py" "$r/witness-compiler"
