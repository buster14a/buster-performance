#!/usr/bin/env bash
# identity-run.sh: (inside one hold) -c of the frozen sqlite3.c by each build on CPU 2, objects and diagnostics kept.
. "$HOME/buster-fast-bench/3022-claude/env.sh"
out="$W/identity"
mkdir -p "$out"
for b in base head; do
    taskset -c 2 "$W/bin/$b" "${OPTIONS[@]}" -o "$out/$b.o" > "$out/$b.stdout" 2> "$out/$b.stderr"
    echo "$b status $?"
done
