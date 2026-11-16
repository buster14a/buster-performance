#!/bin/bash
# shadow-modes2.sh COMPILER TREE OUT: measure-node-machine --shadow in each mode on sqlite3.c, Lua, musl and the
# compiler's own main.c (TREE's, with its build/predefines.h); each run's output in OUT/MODE-INPUT.txt and its exit
# status, census and shadow totals a line each in OUT/summary.txt.
S=/root/.cache/claude-2891
compiler=$1; tree=$2; out=$3
mkdir -p "$out"; : > "$out/summary.txt"
export CORPUS_ROOT=/home/user/buster/build/corpus LUA_SRC=$S/inputs/lua-5.4.8/src
cd $S/scripts && . ./corpora.sh
for mode in plain verify g fused facts reads front-types front-sweeps front-tests front-tests-wall; do
    case $mode in plain) flags=();; verify) flags=(--verify);; g) flags=(-g);; fused) flags=(--fused);; facts) flags=(--facts --facts-operators);; reads) flags=(--facts-reads);;
        front-types) flags=(--front-types);; front-sweeps) flags=(--front-sweeps);; front-tests) flags=(--front-tests);; front-tests-wall) flags=(--front-tests -Wall -Wextra);; esac
    for name in sqlite3 lua musl main; do
        if [ $name = main ]; then
            inputs=(-march=native -I"$tree/src" -fwrapv -funsigned-char --predefines "$tree/build/predefines.h" "$tree/src/buster/compiler/main.c")
        else
            eval "options=($(corpus_options "$name"))"
            mapfile -t files < <(corpus_files "$name")
            inputs=("${options[@]}" "${files[@]}")
        fi
        nice -n 5 "$compiler" measure-node-machine --shadow "${flags[@]}" --list 3 "${inputs[@]}" > "$out/$mode-$name.txt" 2>&1
        status=$?
        echo "$mode $name status $status | $(grep -h '^node-census: taken\|^node-shadow: machine-taken\|^node-shadow: differences\|taken there and refused' "$out/$mode-$name.txt" | cut -c1-120 | tr '\n' '|')" >> "$out/summary.txt"
    done
done
echo done >> "$out/summary.txt"
