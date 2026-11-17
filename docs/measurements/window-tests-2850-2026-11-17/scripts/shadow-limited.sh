#!/bin/bash
# shadow-limited.sh OUT COMPILER "CORPORA" LIMIT MODE...: measure-node-machine --shadow MODE on each corpus named (sqlite,
# lua, musl, main), from the checkout TREE (main's paths are relative to it), at most LIMIT runs side by side (the
# compiler's own source takes 5 GB a run). A file a corpus and mode in OUT, and a line each in OUT/status.txt.
set -u
out=$1; compiler=$2; corpora=$3; limit=$4
shift 4
cd "${TREE:-/home/user/buster}"
. /home/user/keep/corpora.sh
mkdir -p "$out"
running=0
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
        if [ "$running" -ge "$limit" ]; then wait -n; running=$((running - 1)); fi
        (
            bash -c "$compiler measure-node-machine --shadow $mode $arguments" > "$out/$c$tag.out" 2> "$out/$c$tag.err"
            echo "$c $mode status $?" >> "$out/status.txt"
        ) &
        running=$((running + 1))
    done
done
wait
echo "all done" >> "$out/status.txt"
