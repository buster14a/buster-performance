#!/usr/bin/env bash
set -euo pipefail
work=$(pwd)
dest="$work/carrier-evidence/restore-apps"
mkdir -p "$dest"
export SOURCE_DATE_EPOCH=1792454400
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
cd compile-evidence
for opt in O2 O0; do
  for input in inputs/lua/*.c inputs/sqlite3.c; do
    name=$(basename "$input" .c)
    more=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
    if [[ $name == sqlite3 ]]; then more=(-DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION); fi
    for v in parent candidate; do
      c="$work/visible-regions/build/compiler"
      [[ $v == candidate ]] && c="$work/debug-carriers/build/compiler"
      "$c" --tier1 "-$opt" -g -march=znver5 --lanes 1 -w "${more[@]}" -c "$input" -o "$dest/$opt-$v-$name.o"
    done
    cmp "$dest/$opt-parent-$name.o" "$dest/$opt-candidate-$name.o"
    digest=$(sha256sum "$dest/$opt-candidate-$name.o" | cut -d' ' -f1)
    printf '%s\t%s\t%s\n' "$opt" "$input" "$digest"
  done
  for v in parent candidate; do
    objects=()
    for obj in "$dest/$opt-$v-"*.o; do
      case "$obj" in *-sqlite3.o|*-luac.o|*-onelua.o) continue;; esac
      objects+=("$obj")
    done
    "$cc" -no-pie "${objects[@]}" -lm -ldl -o "$dest/$opt-$v-lua"
    for script in calls tables strings arithmetic closures; do
      "$dest/$opt-$v-lua" "$work/lua-layout-evidence/scripts/$script.lua" > "$dest/$opt-$v-$script.result"
      cmp "$dest/$opt-$v-$script.result" "$work/lea-evidence/lua-clang/$script.result"
    done
  done
  cmp "$dest/$opt-parent-lua" "$dest/$opt-candidate-lua"
  printf '%s\tlinked-lua\t%s\n' "$opt" "$(sha256sum "$dest/$opt-parent-lua" | cut -d' ' -f1)"
done
