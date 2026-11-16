#!/bin/bash
# shadow-modes.sh COMPILER OUT: measure-node-machine --shadow in each mode on sqlite3.c, Lua and musl; each run's census
# and shadow totals and its exit status in OUT/MODE-CORPUS.txt, a line each in OUT/summary.txt.
S=/tmp/claude-0/-home-user-buster/c45a68bf-d025-5d42-ba16-5bb54ca5630c/scratchpad
compiler=$1; out=$2
mkdir -p "$out"; : > "$out/summary.txt"
export CORPUS_ROOT=/home/user/buster/build/corpus LUA_SRC=$S/inputs/lua-5.4.8/src
cd $S/scripts && . ./corpora.sh
for mode in plain verify g fused facts reads; do
    case $mode in plain) flags=();; verify) flags=(--verify);; g) flags=(-g);; fused) flags=(--fused);; facts) flags=(--facts --facts-operators);; reads) flags=(--facts-reads);; esac
    for name in sqlite3 lua musl; do
        eval "options=($(corpus_options "$name"))"
        mapfile -t files < <(corpus_files "$name")
        nice -n 5 "$compiler" measure-node-machine --shadow "${flags[@]}" --list 3 "${options[@]}" "${files[@]}" > "$out/$mode-$name.txt" 2>&1
        status=$?
        echo "$mode $name status $status $(grep -h '^node-shadow: differences\|^node-shadow: machine-taken' "$out/$mode-$name.txt" | tr '\n' ' ')" >> "$out/summary.txt"
    done
done
echo done >> "$out/summary.txt"
