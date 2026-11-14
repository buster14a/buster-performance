#!/bin/bash
# #2627 prototype: Develop's run time, whole unit against pieces. Copies of the tree's Develop executable (whole) and
# of the pieces' (pieces), each round one hold of the lock: each side's -c sqlite3.c and -fsyntax-only of the
# checker's unit on CPU 2 (buster#2624's workloads, round.sh), perf stat's user instructions and cycles, a line each
# in results/runtime.tsv: round, side, workload, instructions, cycles.
set -euo pipefail
d=$HOME/buster-fast-bench/2627-claude
export EXCLUSIVE_OWNER=claude-2627 EXCLUSIVE_TITLE="#2627: the checker unit in pieces (prototype)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2627
. $HOME/buster-fast-bench/2626-claude/scripts/env.sh
cd "$d/base"
cp "$(./build.sh print-output)" "$d/compiler-whole"
cp "$d/n/compiler" "$d/compiler-pieces"
[ ! -e "$d/n10/compiler" ] || cp "$d/n10/compiler" "$d/compiler-pieces10"
sha256sum "$d"/compiler-whole "$d"/compiler-pieces* > "$d/results/runtime-compilers.txt"
clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$d/predefines.h"
out=$d/results/${RESULTS:-runtime}.tsv
: > "$out"
cat > "$d/round.sh" <<'INNER'
#!/bin/bash
set -euo pipefail
d=$1; round=$2; out=$3
unset CPATH C_INCLUDE_PATH
source=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sqlite=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$source" "$source/sqlite3.c" -o "$d/sqlite3.o")
checker=(-fsyntax-only -march=znver5 "-I$d/base/src" -fwrapv -funsigned-char -fno-strict-aliasing --predefines "$d/predefines.h" "$d/base/src/buster/compiler/main_unit_checker.c")
for side in ${SIDES:-whole pieces}; do
    for workload in sqlite checker; do
        if [ "$workload" = sqlite ]; then args=("${sqlite[@]}"); else args=("${checker[@]}"); fi
        perf stat -x, -e instructions:u,cycles:u -o "$d/stat.txt" -- taskset -c 2 "$d/compiler-$side" "${args[@]}" > /dev/null
        printf '%s\t%s\t%s\t%s\t%s\n' "$round" "$side" "$workload" "$(awk -F, '/instructions/ { print $1 }' "$d/stat.txt")" \
            "$(awk -F, '/cycles/ { print $1 }' "$d/stat.txt")" >> "$out"
    done
done
INNER
chmod +x "$d/round.sh"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh timeout 600 env SIDES="${SIDES:-whole pieces}" "$d/round.sh" "$d" "$round" "$out"
done
cat "$out"
echo runtime-done
