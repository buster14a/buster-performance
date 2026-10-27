#!/usr/bin/env bash
# Each executable's object of sqlite3.c, which must be one: main's and the branch's by default, with --scalar and with
# --verify, and the switch build's in each mode (full: branch_sizing_validate as main ran it; vector and scalar: the
# columns' paths).
set -u
source ./common.sh
uname -a; clang --version | head -1; sha256sum "$sqlite/sqlite3.c"
for v in main head; do
    taskset -c 2 ./$v/build/compiler "${options[@]}" -o out/$v.o; echo "$v status $?"
    taskset -c 2 ./$v/build/compiler --scalar "${options[@]}" -o out/$v-scalar.o; echo "$v --scalar status $?"
    taskset -c 2 ./$v/build/compiler --verify "${options[@]}" -o out/$v-verify.o; echo "$v --verify status $?"
done
for m in full vector scalar; do
    BUSTER_532_CHECK=$m taskset -c 2 ./switch/build/compiler "${options[@]}" -o out/switch-$m.o; echo "switch $m status $?"
done
sha256sum out/*.o
