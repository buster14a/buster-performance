#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/pr-numbers-codex-6b0809fc"
bench="$HOME/buster-fast-bench"
clang_root="$HOME/.cache/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378"
tools_root="$HOME/.cache/buster/build-tools/cmake-4.4.3-ninja-1.13.2"
export PATH="$clang_root/bin:$tools_root/bin:$PATH"
export LD_LIBRARY_PATH="$clang_root/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export BUSTER_CLANG_RESOURCE_DIR="$clang_root/lib/clang/23"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
export EXCLUSIVE_OWNER=codex-6b0809fc
export LC_ALL=C
clang --version
grep -Em1 '^model name[[:space:]]*:[[:space:]]*AMD Ryzen 7 9700X([[:space:]]|$)' /proc/cpuinfo
lock_run() {
    "$bench/exclusive.sh" timeout -k 5 420 "$@"
}
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3663
root=$PWD
out="$root/qualify-3663"
mkdir -p "$out"
sha=d1abb572fef5f0cda6d77e6234feeeb67a3c6a15
side=pr3663
if [[ ! -d "$side/.git" ]]; then
    git init -q "$side"
    git -C "$side" remote add origin https://github.com/buster14a/buster.git
fi
git -C "$side" fetch -q --depth=2 origin "$sha"
git -C "$side" checkout -q --detach FETCH_HEAD
[[ $(git -C "$side" rev-parse HEAD) == "$sha" ]]
base=pr3661
[[ $(git -C "$side" rev-parse HEAD^) == "$(git -C "$base" rev-parse HEAD)" ]]
{
    uname -srnm
    grep -m1 '^model name' /proc/cpuinfo
    clang --version
    git -C "$base" rev-parse HEAD
    git -C "$side" rev-parse HEAD
} > "$out/identity.txt"
export EXCLUSIVE_TITLE='PR 3663 Release build'
(cd "$side" && lock_run taskset -c 0-7 ./build.sh --config Release --jobs 8) > "$out/build.log" 2>&1
sha256sum "$base/build/compiler" "$side/build/compiler" >> "$out/identity.txt"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check >> "$out/identity.txt"
{
    printf '#define PRESENT 1\n'
    for ((i = 0; i < 512; i++)); do printf '#ifdef PRESENT trailing\n#endif trailing\n'; done
} > "$out/warnings.c"
export EXCLUSIVE_TITLE='PR 3663 successful SQLite preprocessing and 1,024 directive warnings, paired perf'
lock_run taskset -c 2 bash -s "$root" "$out" "$sqlite" <<'MEASURE'
set -euo pipefail
root=$1 out=$2 sqlite=$3
cd "$out"
sqlite_flags=(-E -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
warning_flags=(-std=gnu23 -E -ferror-limit=0 warnings.c)
for workload in sqlite warnings; do
    opts=("${sqlite_flags[@]}")
    if [[ "$workload" == warnings ]]; then opts=("${warning_flags[@]}"); fi
    mkdir -p "$workload"
    for round in {0..20}; do
        order=(pr3661 pr3663)
        if (( round % 2 )); then order=(pr3663 pr3661); fi
        for side in "${order[@]}"; do
            label="$workload/$round-$side"
            perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$label.csv" -- "$root/$side/build/compiler" "${opts[@]}" -o "$label.i" 2> "$label.stderr"
            if [[ "$round" != 0 ]]; then
                cmp "$label.stderr" "$workload/0-$side.stderr"
                cmp "$label.i" "$workload/0-$side.i"
                rm "$label.stderr" "$label.i"
            fi
        done
    done
    cmp "$workload/0-pr3661.i" "$workload/0-pr3663.i"
    sha256sum "$workload"/0-*.i >> identity.txt
    if [[ "$workload" == warnings ]]; then
        for side in pr3661 pr3663; do test "$(grep -c ': warning:' "$workload/0-$side.stderr")" == 1024; done
    else
        cmp "$workload/0-pr3661.stderr" "$workload/0-pr3663.stderr"
    fi
done
MEASURE
export EXCLUSIVE_TITLE='PR 3663 native 83-case caret oracle'
(cd "$side" && lock_run taskset -c 2 ./build/compiler test-carets --clang "$(command -v clang)" --fixtures "$PWD/tests/carets") > "$out/caret-oracle.txt" 2>&1
touch "$out/finished"
