#!/bin/bash
# exes.sh EXE OUT MODE: Lua 5.4.8's interpreter linked by EXE as a dynamic PIE, -static, -static-pie and -no-pie, MODE
# default or scalar (--scalar), into OUT; each link's exit status and its run's. Every link runs in one directory,
# /dev/shm/2924-linker/exes-work, then moves to OUT, so that base's and head's files differ only by what they compute.
set -u
exe=$1; out=$2; mode=$3
lua=$HOME/buster-fast-bench/2924-c-df-claude/c3pr/inputs/lua-5.4.8/src
work=/dev/shm/2924-linker/exes-work
flag=()
[ "$mode" = scalar ] && flag=(--scalar)
rm -rf "$out" "$work"; mkdir -p "$work"
sources=()
for f in "$lua"/*.c; do [ "${f##*/}" = luac.c ] || sources+=("$f"); done
cd "$work"
for kind in pie static static-pie no-pie; do
  link=()
  [ "$kind" = pie ] || link=(-$kind)
  "$exe" "${flag[@]}" "${link[@]}" -O0 "${sources[@]}" -lm -o "lua-$kind" > "lua-$kind.err" 2>&1; status=$?
  ran=$(./"lua-$kind" -e 'print(string.format("%d %s", 6 * 7, table.concat({"a", "b"}, ",")))' 2>&1)
  echo "$kind link $status run: $ran"
done
cd /; mv "$work" "$out"
