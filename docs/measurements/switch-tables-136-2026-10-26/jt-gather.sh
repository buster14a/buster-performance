#!/bin/bash
# The record's identities and objects, under one hold of the lock: the executables' and inputs' sha256, the toolchain,
# `size -A` of each tree's sqlite3.o (the -c runs' output), the branch's jump tables' symbols, and the shells' outputs.
export EXCLUSIVE_OWNER=claude-switch-136 EXCLUSIVE_TITLE="Solve 133 136 137 145" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
B=~/buster-fast-bench
Q=$B/preprocessor-corpora-astra-01a158dd/sqlite
$B/exclusive.sh bash -c '
    B=~/buster-fast-bench
    Q='"$Q"'
    {
        echo "== host"; uname -r; grep -m1 "model name" /proc/cpuinfo
        echo "== toolchain"; clang --version | head -1; cc --version | head -1; ld --version | head -1; perf --version
        echo "== executables"
        sha256sum $B/backend-136-main/build/compiler $B/jump-136-claude/build/compiler $B/jump-136-toggle/build/compiler
        echo "== inputs"
        sha256sum $Q/sqlite3.c $Q/shell.c $Q/sqlite3.h $B/jump-136-claude/work.sql
        echo "== the shells"
        sha256sum $B/backend-136-main/sq $B/jump-136-claude/sq
        md5sum $B/backend-136-main/out.txt $B/jump-136-claude/out.txt
    } > $B/jump-136-claude/identities.txt 2>&1
    {
        for d in backend-136-main jump-136-claude; do echo "== $d sqlite3.o"; size -A $B/$d/sqlite3.o; done
        echo "== jump-136-claude sqlite3.o: tables and their labels"
        readelf -sW $B/jump-136-claude/sqlite3.o | grep -c "\.Lbuster_switch_"
        readelf -sW $B/jump-136-claude/sqlite3.o | grep -c "\.Lbuster_case_"
        readelf -rW $B/jump-136-claude/sqlite3.o | grep -A1 "^Relocation section .\.rela\.rodata" | head -2
    } > $B/jump-136-claude/objects.txt 2>&1
' 2>&1 | grep -v "^exclusive.sh\|^  title:\|^  link:\|^  pull request:"
cat $B/jump-136-claude/identities.txt $B/jump-136-claude/objects.txt
