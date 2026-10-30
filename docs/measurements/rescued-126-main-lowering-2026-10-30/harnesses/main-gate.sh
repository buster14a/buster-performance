#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See Buster's LICENSE and LICENSING.md.
# Invoke once per host lock acquisition, from the frozen source root.
set -euo pipefail
[[ $# == 3 ]]
mode=$1
flags_file=$2
evidence=$3
mapfile -d '' -t flags < "$flags_file"
[[ ${#flags[@]} -gt 0 ]]
case "$mode" in
    check) exec taskset -c 2 ./build/compiler --lanes 1 -fsyntax-only "${flags[@]}" src/buster/compiler/main.c ;;
    selected) exec taskset -c 2 ./build/compiler --lanes 1 --verify -c "${flags[@]}" -o "$evidence/main-selected.o" src/buster/compiler/main.c ;;
    all) exec taskset -c 2 ./build/compiler --lanes 1 --verify --lower-all -c "${flags[@]}" -o "$evidence/main-all.o" src/buster/compiler/main.c ;;
    symbols) exec taskset -c 2 ./build/compiler test-checker-corpus --clang clang --symbols-minimum 1 --report "$evidence/main-symbols.tsv" "${flags[@]}" src/buster/compiler/main.c ;;
    *) echo 'mode must be check, selected, all or symbols' >&2; exit 2 ;;
esac
