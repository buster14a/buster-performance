#!/bin/bash
# Base vs head -fsyntax-only timings for buster #1447's -pedantic escape warnings (PR branch c8/1447-pedantic-escapes).
# Run under the 9700X lock from ~/buster-fast-bench/1447-c8-claude (head checked out and built).
set -e
IN=~/buster-fast-bench/refine-claude/inputs
cd ~/buster-fast-bench/1447-c8-claude
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > ../c8-predefines.h
sha256sum ../c8-base-compiler ../c8-head-compiler $IN/sqlite3.c
taskset -c 2 ../c8-head-compiler time-runs --runs 21 --warmups 2 --build base ../c8-base-compiler --build head ../c8-head-compiler \
  --list -fsyntax-only -march=native -I$IN -fwrapv -funsigned-char -fno-strict-aliasing --predefines ../c8-predefines.h $IN/sqlite3.c \
  --list -fsyntax-only -pedantic -march=native -I$IN -fwrapv -funsigned-char -fno-strict-aliasing --predefines ../c8-predefines.h $IN/sqlite3.c \
  --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing --predefines ../c8-predefines.h src/buster/compiler/main.c \
  --list -fsyntax-only -pedantic -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing --predefines ../c8-predefines.h src/buster/compiler/main.c
