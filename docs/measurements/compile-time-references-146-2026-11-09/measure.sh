#!/bin/bash
# #146: sqlite3.c's -c against tcc -c, clang -O0 -c and gcc -O0 -c, interleaved, with --time-stages' cycles per token,
# on the 9700X under its lock, pinned to CPU 2 as the 9700X job's compile-time step is. Writes results/ in this directory.
set -euo pipefail
dir=~/buster-fast-bench/146-claude
out="$dir/results"
mkdir -p "$out"
cd "$dir/buster"
unset CPATH C_INCLUDE_PATH
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check
options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tcc="$(command -v tcc)"
clang="$(command -v clang)"
gcc="$(command -v gcc)"
{
    echo "revision $(git rev-parse HEAD)"
    echo "host $(uname -n) $(uname -r)"
    grep -m1 'model name' /proc/cpuinfo
    echo "governor $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor 2>/dev/null || echo unknown)"
    echo "boost $(cat /sys/devices/system/cpu/cpufreq/boost 2>/dev/null || echo unknown)"
    echo "perf_event_paranoid $(cat /proc/sys/kernel/perf_event_paranoid)"
    echo "== compiler"; sha256sum build/compiler
    echo "== tcc $tcc"; "$tcc" -v; sha256sum "$tcc"
    echo "== clang $clang"; "$clang" --version | head -1; sha256sum "$(readlink -f "$clang")"; pacman -Qo "$clang" 2>/dev/null || true
    echo "== gcc $gcc"; "$gcc" --version | head -1; sha256sum "$gcc" "$("$gcc" -print-prog-name=cc1)" "$(command -v as)"; pacman -Qo "$gcc" 2>/dev/null || true; as --version | head -1
    echo "== options"; printf '%s\n' "${options[@]}"
} > "$out/provenance.txt" 2>&1
export EXCLUSIVE_OWNER=claude-146 EXCLUSIVE_TITLE="#146 compile time against tcc, clang -O0 and gcc -O0" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/146
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-compile --runs "${RUNS:-21}" --warmups 2 \
    --reference "$tcc" --reference "$clang" --reference-option -O0 --reference "$gcc" --reference-option -O0 \
    -- "${options[@]}" > "$out/measure-compile.txt" 2>&1
echo "done $?"
