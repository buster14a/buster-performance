#!/bin/bash
# knob-counts.sh COMPILER OUT: the update's switch's executable on sqlite3.c, Lua and musl with the update's block off
# (BUSTER_TESTS_SKIP=1) and on (0): the expressions decided, the strides read and the updates asked, a line a run.
compiler=$1
out=$2
mkdir -p "$out"
cd /home/user/buster-upd || exit 1
. /home/user/keep/corpora.sh
for c in sqlite lua musl; do
    case $c in
        sqlite) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
        musl) arguments=$musl_arguments ;;
    esac
    for s in 1 0; do
        BUSTER_TESTS_SKIP=$s bash -c "$compiler measure-node-machine --shadow --passes 0 --window-contexts $arguments" > "$out/knob-$c-$s.out" 2>&1
        status=$?
        decided=$(grep -o 'decided=[0-9]* ([0-9.]*%)' "$out/knob-$c-$s.out" | head -1)
        strides=$(grep -o 'strides-read=[0-9]*' "$out/knob-$c-$s.out" | head -1)
        updates=$(grep -o 'window contexts updates=[0-9]*' "$out/knob-$c-$s.out")
        echo "$c skip=$s status $status $decided $strides $updates"
    done
done
