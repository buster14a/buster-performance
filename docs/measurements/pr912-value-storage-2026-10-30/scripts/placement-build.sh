#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
test ! -e "$Q/stop-placement-series"
variant=$1
shift=$2
case "$variant:$shift" in base:0|base:64|base:512|candidate:0|candidate:64|candidate:512) ;; *) exit 2 ;; esac
root="$Q/hot-$variant-$shift"
test ! -e "$root"
mkdir "$root"
tar -xf "$Q/pr912-$([ "$variant" = base ] && echo base || echo head).tar" -C "$root"
clang -std=c17 -O2 -Wall -Wextra -Werror "$Q/scripts/place.c" -o "$Q/place"
"$Q/place" "$root/src/buster/compiler/main.c" "$shift" > "$root/src/buster/compiler/main.c.placed"
mv "$root/src/buster/compiler/main.c.placed" "$root/src/buster/compiler/main.c"
diff -u "$Q/$variant/src/buster/compiler/main.c" "$root/src/buster/compiler/main.c" > "$Q/evidence/placement-$variant-$shift.patch" || test "$?" = 1
cd "$root"
mkdir -p "$Q/wrappers" "$Q/objects-$variant-$shift"
cp "$Q/scripts/clang" "$Q/wrappers/clang"
chmod +x "$Q/wrappers/clang"
export PR912_REAL_CLANG="$TC/bin/clang" PR912_OBJECTS="$Q/objects-$variant-$shift"
export PATH="$Q/wrappers:$PATH"
date -u
taskset -c 0-7 ./build.sh
sha256sum build/compiler src/buster/compiler/main.c
if [ "$shift" = 0 ]; then
    cmp build/compiler "$Q/$variant/build/compiler"
    echo 'zero-padding control byte-identical to normal build'
fi
nm -n build/compiler | awk '$3 ~ /^check_input_expressions|^check_literal_value|^check_driver/ { print }'
date -u
