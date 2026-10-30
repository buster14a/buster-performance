#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Untimed diagnostic clones only; production archives/objects are immutable.
set -euo pipefail
. "$(dirname "$0")/env.sh"
cd "$Q"
test "$(cat logs/semantic.status)" = 0
kind=${1:?base or candidate}
case "$kind" in base|candidate) ;; *) exit 2;; esac
date -u +%FT%TZ > "$Q/logs/capacity-$kind.started"
trap 'status=$?; printf "%s\n" "$status" > "$Q/logs/capacity-$kind.status"; date -u +%FT%TZ > "$Q/logs/capacity-$kind.ended"' EXIT
cat /var/lib/buster-9700x/owner > "$Q/logs/capacity-$kind.lock-owner"
  diagnostic="$Q/diagnostic-$kind"
  test ! -e "$diagnostic"
  mkdir "$diagnostic"
  tar xzf "$Q/source/$kind.tar.gz" -C "$diagnostic"
  cd "$diagnostic"
  path=src/buster/compiler/c_check_control_input.c
  test "$(grep -c 'uint32_t\* labels = arena_push_array(reader->scratch, capacity' "$path")" = 1
  sed '/uint32_t\* labels = arena_push_array(reader->scratch, capacity/i\    fprintf(stderr, "label-capacity tokens=%u prefix=%u capacity=%llu bytes=%llu\\n", count, prefix ? limit : 0, (unsigned long long)capacity, (unsigned long long)(capacity * sizeof(uint32_t)));' "$path" > "$path.next"
  mv "$path.next" "$path"
  diff -u "$Q/$kind/$path" "$path" > "$Q/logs/capacity-$kind.patch" || test "$?" = 1
  mapfile -d '' -t flags < "$Q/$kind/build/flags.nul"
  clang -c src/buster/compiler/main_unit_checker.c -o "$diagnostic/checker.o" "${flags[@]}"
  mapfile -d '' -t sources < "$Q/$kind/build/sources.nul"
  linked=()
  for i in "${!sources[@]}"; do
    if [ "$i" = 8 ]; then linked+=("$diagnostic/checker.o"); else linked+=("$Q/$kind/build/$i.o"); fi
  done
  clang -no-pie --ld-path=/usr/bin/wild "${linked[@]}" -lm -ldl -o "$diagnostic/compiler"
  sha256sum "$diagnostic/compiler" "$path" > "$Q/logs/capacity-$kind.identities"
  taskset -c 2 "$diagnostic/compiler" "${sqlite[@]}" --lanes 1 -o "$diagnostic/sqlite.o" > "$Q/logs/capacity-$kind.stdout" 2> "$Q/logs/capacity-$kind.stderr"
  cmp "$Q/semantic/base-0.o" "$diagnostic/sqlite.o"
  cd "$Q"
