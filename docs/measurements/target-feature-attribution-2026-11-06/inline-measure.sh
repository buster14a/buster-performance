#!/usr/bin/env bash
set -euo pipefail
root="$HOME/buster-fast-bench/1313-extract-current-codex"
base=e124528504f665fa33b6925146ecaa47b0cb1a9d
head=5929d0e2e2ab5a179313c082811b59a3ccdd0e0d
input="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
out="$root/inline-results"
export EXCLUSIVE_OWNER=codex-1313-inline EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313 LC_ALL=C
mkdir "$out"
git -C "$root/repository" fetch origin refs/heads/main:refs/remotes/origin/main refs/pull/1313/head:refs/remotes/origin/pr1313
[[ $(git -C "$root/repository" rev-parse origin/main) == "$base" && $(git -C "$root/repository" rev-parse origin/pr1313) == "$head" ]]
git -C "$root/repository" worktree add --detach "$root/inline" "$base"
git -C "$root/inline" -c user.name='Codex diagnostic' -c user.email='codex-diagnostic@localhost' merge --no-commit --no-ff "$head"
git -C "$root/inline" apply "$HOME/buster-fast-bench/1313-current-codex-scripts/extract-inline-fixtures.patch"
git -C "$root/inline" add cmake/BusterSettings.cmake src/buster/compiler/c_check_target_feature_emission_test.c src/buster/compiler/c_check_target_feature_fixtures.c src/buster/compiler/c_check_target_feature_fixtures.h src/buster/compiler/foreign_corpus_test.c
printf 'base=%s\n1313=%s\nbase-tree=%s\nvariant-tree=%s\n' "$base" "$head" "$(git -C "$root/base-compiler" write-tree)" "$(git -C "$root/inline" write-tree)" > "$out/identities.txt"
sha256sum "$HOME/buster-fast-bench/1313-current-codex-scripts/extract-inline-fixtures.patch" "$input/sqlite3.c" > "$out/inputs-before.sha256"
export EXCLUSIVE_TITLE='PR 1313 inline test records compiler build'
(cd "$root/inline" && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --jobs 4) > "$out/build.log" 2>&1
sha256sum "$root/base-compiler/build/compiler" "$root/inline/build/compiler" > "$out/binaries.sha256"
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$input" "$input/sqlite3.c")
run_one() {
 local role="$1" label="$2" mode="$3"; export EXCLUSIVE_TITLE="PR 1313 inline test records $label"
 local -a args=("$mode" "${opts[@]}"); [[ "$mode" != '-c' ]] || args+=(-o "$out/out.o")
 "$HOME/buster-fast-bench/exclusive.sh" bash -c 'set -euo pipefail; cp "$1" "$2"; sha256sum "$2" > "$3"; shift 3; taskset -c 2 perf stat -x, -e instructions:u -o "$1" -- "$2" "${@:3}"' -- "$root/$role/build/compiler" "$out/compiler" "$out/$label.bin.sha256" "$out/$label.perf" "$out/compiler" "${args[@]}" > "$out/$label.stdout" 2> "$out/$label.stderr"
 [[ "$mode" != '-c' ]] || sha256sum "$out/out.o" >> "$out/objects.sha256"
}
run_one base-compiler aa-base-1 -fsyntax-only
run_one base-compiler aa-base-2 -fsyntax-only
run_one inline aa-candidate-1 -fsyntax-only
run_one inline aa-candidate-2 -fsyntax-only
for mode in syntax object; do
 flag=-fsyntax-only; [[ $mode != object ]] || flag=-c
 for n in 1 2 3 4 5; do
  if (( n % 2 )); then run_one base-compiler "$mode-base-$n" "$flag"; run_one inline "$mode-candidate-$n" "$flag"; else run_one inline "$mode-candidate-$n" "$flag"; run_one base-compiler "$mode-base-$n" "$flag"; fi
 done
done
sha256sum "$HOME/buster-fast-bench/1313-current-codex-scripts/extract-inline-fixtures.patch" "$input/sqlite3.c" > "$out/inputs-after.sha256"
cmp "$out/inputs-before.sha256" "$out/inputs-after.sha256"
sha256sum -c "$out/binaries.sha256" > "$out/binaries-after.txt"
git ls-remote https://github.com/buster14a/buster.git refs/heads/main refs/pull/1313/head > "$out/refs-after.txt"
printf 'done\n' > "$out/complete.txt"
