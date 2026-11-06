#!/usr/bin/env bash
set -euo pipefail
measurement_root="$HOME/buster-fast-bench/1313-current-codex"
source_url=https://github.com/buster14a/buster.git
sqlite_dir="$HOME/buster-fast-bench/1296-codex-20261105/corpus/sqlite"
expected_sqlite=0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d
export EXCLUSIVE_OWNER=codex-1313-current
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1313
export LC_ALL=C
mkdir "$measurement_root"
cd "$measurement_root"
git clone --no-checkout "$source_url" repository
git -C repository fetch origin refs/heads/main:refs/remotes/origin/main refs/pull/1313/head:refs/remotes/origin/pr-1313
base_sha=$(git -C repository rev-parse origin/main)
head_sha=$(git -C repository rev-parse origin/pr-1313)
git -C repository worktree add --detach "$measurement_root/base" "$base_sha"
git -C repository worktree add --detach "$measurement_root/integrated" "$base_sha"
git -C integrated -c user.name='Codex experiment' -c user.email='codex-experiment@localhost' merge --no-commit --no-ff "$head_sha"
integration_tree=$(git -C integrated write-tree)
printf 'base=%s\nhead=%s\nintegration_tree=%s\nbuild=Clang, Release, BUSTER_HOST_ARCH=znver5, BUSTER_DEBUG_INFO=0\ncpu=2\nevent=instructions:u\n' "$base_sha" "$head_sha" "$integration_tree" > identities.txt
printf '%s  %s\n' "$expected_sqlite" "$sqlite_dir/sqlite3.c" | sha256sum -c > sqlite-identity.txt
clang --version > clang-version.txt
uname -a > uname.txt
sed -n '1,/^$/p' /proc/cpuinfo > cpu.txt
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor > cpu2-governor.txt
git -C integrated diff --cached --stat > integration-stat.txt
for variant in base integrated; do
  export EXCLUSIVE_TITLE="PR 1313 current $variant compiler build"
  (cd "$measurement_root/$variant" && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 "$HOME/buster-fast-bench/exclusive.sh" ./build.sh --jobs 4) > "$measurement_root/build-$variant.log" 2>&1
  sha256sum "$measurement_root/$variant/build/compiler" >> "$measurement_root/executables.sha256"
done
opts=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite_dir" "$sqlite_dir/sqlite3.c")
printf 'argv=' >> identities.txt
printf '%q ' -c "${opts[@]}" -o "$measurement_root/out.o" >> identities.txt
printf '\n' >> identities.txt
export EXCLUSIVE_TITLE='PR 1313 current base preprocessed input'
"$HOME/buster-fast-bench/exclusive.sh" "$measurement_root/base/build/compiler" -E "${opts[@]}" -o "$measurement_root/sqlite.i" > preprocessed.out 2> preprocessed.err
sha256sum sqlite.i >> sqlite-identity.txt
if grep -En '__attribute__[[:space:]]*\(\([^)]*(__target__|target)[[:space:]]*\(' sqlite.i > target-attributes.txt; then
  echo 'target attribute found in preprocessed input' >&2
  exit 1
fi
# Copy to one common executable path inside the locked run. Every run uses identical argv and output path.
run_one() {
  local variant="$1" label="$2" source="$measurement_root/$1/build/compiler"
  export EXCLUSIVE_TITLE="PR 1313 current $label"
  "$HOME/buster-fast-bench/exclusive.sh" bash -c 'set -euo pipefail; cp "$1" "$2"; sha256sum "$2" > "$3"; shift 3; taskset -c 2 perf stat -x, -e instructions:u -o "$1" -- "$2" -c "${@:3}"' \
    -- "$source" "$measurement_root/compiler" "$measurement_root/$label.bin.sha256" "$measurement_root/$label.perf" "$measurement_root/compiler" "${opts[@]}" -o "$measurement_root/out.o" \
    > "$measurement_root/$label.stdout" 2> "$measurement_root/$label.stderr"
  sha256sum "$measurement_root/out.o" >> "$measurement_root/objects.sha256"
}
# Within-binary A/A runs, then seven alternating paired orders; counts are retained individually.
run_one base aa-base-1
run_one base aa-base-2
run_one integrated aa-integrated-1
run_one integrated aa-integrated-2
for n in 1 2 3 4 5 6 7; do
  if (( n % 2 )); then
    run_one base "base-$n"
    run_one integrated "integrated-$n"
  else
    run_one integrated "integrated-$n"
    run_one base "base-$n"
  fi
done
printf 'done\n' > complete.txt
