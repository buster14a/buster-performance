#!/usr/bin/env bash
# Original bounded functional control; source paths are identical for both compiler roles.
set -euo pipefail
root=/home/david/Documents/Codex/2026-10-28/solv/work
evidence=$root/evidence-529
host=${1:?native or generic}
head=$root/next-529/build/compiler
if [[ $host == generic ]]; then head=$root/next-529-generic/build/compiler; fi
base=$root/baseline-e7f89091/build/compiler
out=$evidence/controls-$host
mkdir -p "$out"
for name in tiny comma-128 comma-1024; do
    source=$evidence/$name.c
    clang -O0 -Wno-unused-value "$source" -o "$out/$name-clang"
    "$out/$name-clang" > "$out/$name-clang.stdout"
    for mode in default scalar; do
        options=()
        if [[ $mode == scalar ]]; then options=(--scalar); fi
        for role in base head; do
            binary=$base
            if [[ $role == head ]]; then binary=$head; fi
            prefix=$out/$name-$role-$mode
            "$evidence/time-command" "$prefix.time" "$binary" --lanes 1 "${options[@]}" -c "$source" -o "$prefix.o" > "$prefix.stdout" 2> "$prefix.stderr"
            clang "$prefix.o" -o "$prefix.exe"
            "$prefix.exe" > "$prefix.runtime"
            cmp "$out/$name-clang.stdout" "$prefix.runtime"
        done
        cmp "$out/$name-base-$mode.o" "$out/$name-head-$mode.o"
        cmp "$out/$name-base-$mode.stdout" "$out/$name-head-$mode.stdout"
        cmp "$out/$name-base-$mode.stderr" "$out/$name-head-$mode.stderr"
    done
done
printf '%s: 6/6 object, stdout and stderr pairs equal; 12/12 executables equal Clang runtime output\n' "$host"
