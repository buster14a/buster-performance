#!/usr/bin/env bash
set -euo pipefail
root="$HOME/buster-fast-bench/1313-1530-current-codex"
base=e124528504f665fa33b6925146ecaa47b0cb1a9d
h1530=e94fd0d2bcada50d237ac14206a32cf2b68dc1ff
h1313=5929d0e2e2ab5a179313c082811b59a3ccdd0e0d
input="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1313-1530 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313 LC_ALL=C
mkdir "$root"
cd "$root"
git clone --no-checkout https://github.com/buster14a/buster.git repository
git -C repository fetch origin refs/heads/main:refs/remotes/origin/main refs/pull/1530/head:refs/remotes/origin/pr1530 refs/pull/1313/head:refs/remotes/origin/pr1313
[[ $(git -C repository rev-parse origin/main) == "$base" && $(git -C repository rev-parse origin/pr1530) == "$h1530" && $(git -C repository rev-parse origin/pr1313) == "$h1313" ]]
git -C repository worktree add --detach "$root/only1530" "$base"
git -C repository worktree add --detach "$root/both" "$base"
git -C only1530 -c user.name='Codex diagnostic' -c user.email='codex-diagnostic@localhost' merge --no-commit --no-ff "$h1530"
git -C both -c user.name='Codex diagnostic' -c user.email='codex-diagnostic@localhost' merge --no-ff -m 'Local diagnostic integration' "$h1530"
git -C both -c user.name='Codex diagnostic' -c user.email='codex-diagnostic@localhost' merge --no-commit --no-ff "$h1313"
printf 'base=%s\n1530=%s\n1313=%s\nonly1530-tree=%s\nboth-tree=%s\n' "$base" "$h1530" "$h1313" "$(git -C only1530 write-tree)" "$(git -C both write-tree)" > identities.txt
sha256sum "$input/sqlite3.c" > input-before.sha256
for role in only1530 both; do
 export EXCLUSIVE_TITLE="PR 1313 and 1530 diagnostic $role compiler build"
 (cd "$root/$role" && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --jobs 4) > "$root/build-$role.log" 2>&1
 sha256sum "$root/$role/build/compiler" >> binaries.sha256
done
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$input" "$input/sqlite3.c")
run_one() {
 local role="$1" label="$2" mode="$3"; export EXCLUSIVE_TITLE="PR 1313 and 1530 diagnostic $label"
 local -a args=("$mode" "${opts[@]}")
 if [[ "$mode" == '-c' ]]; then args+=(-o "$root/out.o"); fi
 "$HOME/buster-fast-bench/exclusive.sh" bash -c 'set -euo pipefail; cp "$1" "$2"; sha256sum "$2" > "$3"; shift 3; taskset -c 2 perf stat -x, -e instructions:u -o "$1" -- "$2" "${@:3}"' -- "$root/$role/build/compiler" "$root/compiler" "$root/$label.bin.sha256" "$root/$label.perf" "$root/compiler" "${args[@]}" > "$root/$label.stdout" 2> "$root/$label.stderr"
 if [[ "$mode" == '-c' ]]; then sha256sum "$root/out.o" >> objects.sha256; fi
}
run_one only1530 aa-only-1 -fsyntax-only
run_one only1530 aa-only-2 -fsyntax-only
run_one both aa-both-1 -fsyntax-only
run_one both aa-both-2 -fsyntax-only
for mode in syntax object; do
 flag=-fsyntax-only; [[ $mode != object ]] || flag=-c
 for n in 1 2 3 4 5; do
  if (( n % 2 )); then run_one only1530 "$mode-only-$n" "$flag"; run_one both "$mode-both-$n" "$flag"; else run_one both "$mode-both-$n" "$flag"; run_one only1530 "$mode-only-$n" "$flag"; fi
 done
done
sha256sum "$input/sqlite3.c" > input-after.sha256
cmp input-before.sha256 input-after.sha256
sha256sum -c binaries.sha256 > binaries-after.txt
git ls-remote https://github.com/buster14a/buster.git refs/heads/main refs/pull/1530/head refs/pull/1313/head > refs-after.txt
printf 'done\n' > complete.txt
