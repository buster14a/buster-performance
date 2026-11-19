#!/bin/bash
# shadow.sh OUT COMPILER "CORPORA" MODE...: measure-node-machine --shadow MODE on each corpus named (sqlite, lua, musl,
# main), from the buster checkout (main's paths are relative to it). A file a corpus and mode in OUT, and a line each in
# OUT/status.txt. A corpus's modes run side by side.
set -u
out=$1; compiler=$2; corpora=$3
shift 3
cd "${TREE:-/home/user/buster}"
. /home/user/keep/corpora.sh
mkdir -p "$out"
for c in $corpora; do
    case $c in
        sqlite) arguments=$sqlite_arguments ;;
        lua) arguments=$lua_arguments ;;
        musl) arguments=$musl_arguments ;;
        main) arguments=$main_arguments ;;
        *) echo "unknown corpus $c"; exit 1 ;;
    esac
    for mode in "$@"; do
        tag=$(echo "$mode" | tr -d ' ' | tr -c 'A-Za-z0-9\n-' '_')
        (
            bash -c "$compiler measure-node-machine --shadow $mode $arguments" > "$out/$c$tag.out" 2> "$out/$c$tag.err"
            echo "$c $mode status $?" >> "$out/status.txt"
        ) &
    done
    wait
done
