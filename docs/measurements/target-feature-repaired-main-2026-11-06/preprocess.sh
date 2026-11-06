#!/usr/bin/env bash
set -euo pipefail
root="$HOME/buster-fast-bench/1313-current-codex"
input="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
cd "$root"
export EXCLUSIVE_OWNER=codex-1313-current EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313 LC_ALL=C
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$input" "$input/sqlite3.c")
run_one() {
  local variant="$1" label="pre-$2"
  export EXCLUSIVE_TITLE="PR 1313 preprocess $label"
  "$HOME/buster-fast-bench/exclusive.sh" bash -c 'set -euo pipefail; cp "$1" "$2"; sha256sum "$2" > "$3"; shift 3; taskset -c 2 perf stat -x, -e instructions:u -o "$1" -- "$2" -E "${@:3}"' -- "$root/$variant/build/compiler" "$root/compiler" "$root/$label.bin.sha256" "$root/$label.perf" "$root/compiler" "${opts[@]}" -o "$root/out.i" > "$root/$label.stdout" 2> "$root/$label.stderr"
  sha256sum "$root/out.i" >> "$root/pre-outputs.sha256"
}
run_one base aa-base-1
run_one base aa-base-2
run_one integrated aa-integrated-1
run_one integrated aa-integrated-2
for n in 1 2 3 4; do
  if (( n % 2 )); then run_one base "base-$n"; run_one integrated "integrated-$n"; else run_one integrated "integrated-$n"; run_one base "base-$n"; fi
done
printf 'done\n' > pre-complete.txt
