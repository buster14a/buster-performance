#!/bin/bash
# floor.sh: builds floor.c and reads its user and kernel cycles and wall time on CPU 2, eleven fresh processes a variant,
# each variant's runs under one hold of the lock (a variant is under a tenth of a second).
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
out="$dir/results/floor"
rm -rf "$out"; mkdir -p "$out"
sq=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
clang="$HOME/.cache/buster/benchpress-clang"
cc=$(ls -d "$clang"/*/bin/clang 2>/dev/null | head -1)
[ -n "$cc" ] || cc=clang
"$cc" -O2 -march=native -static -o "$out/floor" "$dir/floor/floor.c"
ls -la "$out/floor" | awk '{print "floor binary bytes:", $5}' > "$out/binary.txt"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850 redesign: the fixed costs' floor" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
variant()
{
    local name=$1; shift
    "$HOME/buster-fast-bench/exclusive.sh" bash -c "
        cd '$out'
        cat /proc/loadavg > '$name.load'
        for i in 1 2 3; do taskset -c 2 $* > /dev/null 2>&1 || true; done
        taskset -c 2 perf stat -x, -r 11 -e cycles:u,cycles:k,instructions:u,page-faults,task-clock -o '$name.perf' -- $* > /dev/null 2> '$name.stderr' || true
        for i in 1 2 3 4 5 6 7 8 9 10 11; do taskset -c 2 python3 '$dir/wallrun.py' '$name.w'\$i -- $*; done
    " 2>> "$out/lock.log"
}
variant nothing /bin/true
variant map-scan "$out/floor" "$sq" "$out/x.o" 0 0 system
variant write-2mb "$out/floor" "$sq" "$out/x.o" 0 2061192 system
for mb in 8 16 32 64 128 238; do
    variant "fresh-$mb-system" "$out/floor" "$sq" "$out/x.o" "$mb" 2061192 system
    variant "fresh-$mb-huge" "$out/floor" "$sq" "$out/x.o" "$mb" 2061192 huge
    variant "fresh-$mb-base" "$out/floor" "$sq" "$out/x.o" "$mb" 2061192 base
done
printf 'int main(void) { return 0; }\n' > "$out/empty.c"
variant compiler-empty "$dir/trees/d541430bf/build/compiler" --lanes 1 -c "$out/empty.c" -o "$out/empty.o"
rm -f "$out/x.o" "$out/empty.o"
echo done > "$out/complete"
