#!/usr/bin/env bash
set -euo pipefail
root="$HOME/buster-fast-bench/1313-extract-current-codex"
base=e124528504f665fa33b6925146ecaa47b0cb1a9d
h1313=5929d0e2e2ab5a179313c082811b59a3ccdd0e0d
input="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1313-extract EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313 LC_ALL=C
mkdir "$root"
cd "$root"
git clone --no-checkout https://github.com/buster14a/buster.git repository
git -C repository fetch origin refs/heads/main:refs/remotes/origin/main refs/pull/1313/head:refs/remotes/origin/pr1313
[[ $(git -C repository rev-parse origin/main) == "$base" && $(git -C repository rev-parse origin/pr1313) == "$h1313" ]]
git -C repository worktree add --detach "$root/base-compiler" "$base"
git -C repository worktree add --detach "$root/candidate" "$base"
git -C candidate -c user.name='Codex diagnostic' -c user.email='codex-diagnostic@localhost' merge --no-commit --no-ff "$h1313"
git -C candidate apply "$HOME/buster-fast-bench/1313-current-codex-scripts/extract-fixtures.patch"
git -C candidate add cmake/BusterSettings.cmake src/buster/compiler/c_check_target_feature_emission_test.c src/buster/compiler/c_check_target_feature_fixtures.c src/buster/compiler/c_check_target_feature_fixtures.h src/buster/compiler/foreign_corpus_test.c
printf 'base=%s\n1313=%s\nbase-tree=%s\nvariant-tree=%s\n' "$base" "$h1313" "$(git -C base-compiler write-tree)" "$(git -C candidate write-tree)" > identities.txt
sha256sum "$HOME/buster-fast-bench/1313-current-codex-scripts/extract-fixtures.patch" > prototype-patch.sha256
sha256sum "$input/sqlite3.c" > input-before.sha256
for role in base-compiler candidate; do
 export EXCLUSIVE_TITLE="PR 1313 fixture-split diagnostic $role compiler build"
 (cd "$root/$role" && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --jobs 4) > "$root/build-$role.log" 2>&1
 sha256sum "$root/$role/build/compiler" >> binaries.sha256
done
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$input" "$input/sqlite3.c")
run_one() {
 local role="$1" label="$2" mode="$3"; export EXCLUSIVE_TITLE="PR 1313 fixture-split diagnostic $label"
 local -a args=("$mode" "${opts[@]}")
 if [[ "$mode" == '-c' ]]; then args+=(-o "$root/out.o"); fi
 "$HOME/buster-fast-bench/exclusive.sh" bash -c 'set -euo pipefail; cp "$1" "$2"; sha256sum "$2" > "$3"; shift 3; taskset -c 2 perf stat -x, -e instructions:u -o "$1" -- "$2" "${@:3}"' -- "$root/$role/build/compiler" "$root/compiler" "$root/$label.bin.sha256" "$root/$label.perf" "$root/compiler" "${args[@]}" > "$root/$label.stdout" 2> "$root/$label.stderr"
 if [[ "$mode" == '-c' ]]; then sha256sum "$root/out.o" >> objects.sha256; fi
}
run_one base-compiler aa-only-1 -fsyntax-only
run_one base-compiler aa-only-2 -fsyntax-only
run_one candidate aa-candidate-1 -fsyntax-only
run_one candidate aa-candidate-2 -fsyntax-only
for mode in syntax object; do
 flag=-fsyntax-only; [[ $mode != object ]] || flag=-c
 for n in 1 2 3 4 5; do
  if (( n % 2 )); then run_one base-compiler "$mode-base-$n" "$flag"; run_one candidate "$mode-candidate-$n" "$flag"; else run_one candidate "$mode-candidate-$n" "$flag"; run_one base-compiler "$mode-base-$n" "$flag"; fi
 done
done
sha256sum "$input/sqlite3.c" > input-after.sha256
cmp input-before.sha256 input-after.sha256
sha256sum -c binaries.sha256 > binaries-after.txt
git ls-remote https://github.com/buster14a/buster.git refs/heads/main refs/pull/1313/head > refs-after.txt
printf 'done\n' > complete.txt
