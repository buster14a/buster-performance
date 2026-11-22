#!/bin/bash
# main-only.sh COMPILER OUT [EXTRA...]: measure-node-machine --shadow --bodies on the compiler's own source alone.
set -uo pipefail
cc=$1; out=$2; shift 2
tree=$(dirname "$(dirname "$(dirname "$(dirname "$(dirname "$cc")")")")")
mkdir -p "$out"
"$cc" measure-node-machine --shadow --bodies --passes 0 --list 24 "$@" -march=native "-I$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h" "$tree/src/buster/compiler/main.c" > "$out/main.txt" 2>&1
echo "main exit $?"
grep "node-shadow: bodies" "$out/main.txt" | cut -c1-640
