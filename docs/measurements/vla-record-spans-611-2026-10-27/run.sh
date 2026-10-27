#!/usr/bin/env bash
# Original reproduction glue. Run on the approved 9700X with the two source trees built by ./build.sh.
set -euo pipefail
root=${1:?usage: run.sh ROOT}
root=$(realpath "$root")
evidence="$root/evidence"
mkdir -p "$evidence"
export EXCLUSIVE_OWNER=codex-vla-611
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/611
lock="$HOME/buster-fast-bench/exclusive.sh"
head="$root/head/build/compiler"
base="$root/base/build/compiler"
test -x "$head"
test -x "$base"
if ! test -x "$evidence/generate"; then
    EXCLUSIVE_TITLE='Buster 611 generator build' "$lock" clang -O2 -Wall -Wextra -Werror "$evidence/generate.c" -o "$evidence/generate"
fi
if ! test -x "$evidence/objects"; then
    EXCLUSIVE_TITLE='Buster 611 object test build' "$lock" clang -O2 -Wall -Wextra -Werror "$evidence/objects.c" -o "$evidence/objects"
fi
for n in 2000 4000 8000 16000 32000; do
    "$evidence/generate" vla "$n" > "$evidence/vla-$n.c"
done
sha256sum "$evidence"/vla-*.c "$base" "$head" > "$evidence/identities.sha256"
clang --version > "$evidence/clang.txt"
lscpu > "$evidence/cpu.txt"
args=()
for n in 2000 4000 8000 16000 32000; do
    args+=(--list --lanes 1 -c "$evidence/vla-$n.c" -o "$evidence/timed.o")
done
EXCLUSIVE_TITLE='Buster 611 matched scaling measurement' "$lock" taskset -c 2 "$head" time-runs --runs 11 --warmups 1 --build base "$base" --build head "$head" "${args[@]}" > "$evidence/scaling.txt"
# A/A rows reveal process and inode-copy variability. This is one placement, with three fresh copies per build.
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
sha256sum "$sqlite" >> "$evidence/identities.sha256"
EXCLUSIVE_TITLE='Buster 611 SQLite control measurement' "$lock" taskset -c 2 "$head" time-runs --runs 11 --warmups 1 --copies 3 --directory "$evidence" --build base "$base" --build head "$head" --build base-again "$base" --list --lanes 1 -c "$sqlite" -o "$evidence/sqlite.o" > "$evidence/sqlite.txt"
EXCLUSIVE_TITLE='Buster 611 VLA object and stage verification' "$lock" taskset -c 2 "$evidence/objects" "$root" > "$evidence/objects.txt"
printf 'measurement complete\n'
