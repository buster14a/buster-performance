#!/usr/bin/env bash
set -euo pipefail
root="$HOME/buster-fast-bench/1313-current-codex"
repo="$root/repository"
input="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
export EXCLUSIVE_OWNER=codex-1313-hybrid EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313 LC_ALL=C
cd "$root"
git -C "$repo" worktree add --detach "$root/hybrid-no-fixtures" a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6
git -C hybrid-no-fixtures -c user.name='Codex experiment' -c user.email='codex-experiment@localhost' merge --no-commit --no-ff 5929d0e2e2ab5a179313c082811b59a3ccdd0e0d
git -C hybrid-no-fixtures restore --source=a581e20b8cd202196d8f2dcfff22ce7a5e09e9b6 --staged --worktree -- src/buster/compiler/c_driver_compatibility_test.c
git -C hybrid-no-fixtures rm -f src/buster/compiler/c_check_target_feature_emission_test.c
printf 'diagnostic tree=%s\n' "$(git -C hybrid-no-fixtures write-tree)" > hybrid-identities.txt
printf 'diagnostic fixture removal only; never candidate for PR\n' >> hybrid-identities.txt
git -C hybrid-no-fixtures diff --cached --stat >> hybrid-identities.txt
export EXCLUSIVE_TITLE='PR 1313 fixture-omission diagnostic build'
(cd hybrid-no-fixtures && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --jobs 4) > hybrid-build.log 2>&1
for variant in base integrated hybrid-no-fixtures; do sha256sum "$root/$variant/build/compiler" >> hybrid-binaries.sha256; readelf -SW "$root/$variant/build/compiler" > "hybrid-$variant.sections"; done
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$input" "$input/sqlite3.c")
names=(base integrated hybrid-no-fixtures)
for ((r=0;r<3;r++)); do
 for ((j=0;j<3;j++)); do
  idx=$(((j+r)%3)); variant=${names[idx]}; label="hybrid-$variant-$r"; export EXCLUSIVE_TITLE="PR 1313 diagnostic $label"
  "$HOME/buster-fast-bench/exclusive.sh" bash -c 'set -euo pipefail; cp "$1" "$2"; sha256sum "$2" > "$3"; shift 3; taskset -c 2 perf stat -x, -e instructions:u -o "$1" -- "$2" -fsyntax-only "${@:3}"' -- "$root/$variant/build/compiler" "$root/compiler" "$root/$label.bin.sha256" "$root/$label.perf" "$root/compiler" "${opts[@]}" > "$root/$label.stdout" 2> "$root/$label.stderr"
 done
done
printf 'done\n' > hybrid-complete.txt
