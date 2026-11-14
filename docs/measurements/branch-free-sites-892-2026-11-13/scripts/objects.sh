#!/bin/bash
# objects.sh TREE...: for #892, each tree's outputs of the frozen sqlite3.c (-c by default, on one lane, --scalar,
# --verify, -g) and of the compiler's own main.c (-fsyntax-only -Wall), with their diagnostics, hashed into
# results/TREE/objects.sha256, under the lock in one hold.
set -u
base=~/buster-fast-bench/892-claude
cd "$base/run" || exit 2
corpus=corpus
COMMON=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17
    -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
    -isystem "$corpus/headers/usr/include"
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
run_tree()
{
    local tree=$1 bin=$base/bin/compiler-$1 out=$base/results/$1 o=$base/scratch/objects-$1
    mkdir -p "$out" "$o"
    cp -f "$base/$tree/build/compiler" "$bin.tmp" && mv -f "$bin.tmp" "$bin"
    : > "$out/objects.status"
    for mode in default lanes1 scalar verify g; do
        case $mode in
            default) extra=() ;;
            lanes1) extra=(--lanes 1) ;;
            scalar) extra=(--scalar) ;;
            verify) extra=(--verify) ;;
            g) extra=(-g) ;;
        esac
        "$bin" "${COMMON[@]}" -c -o "$o/sq-$mode.o" "${extra[@]}" > "$o/sq-$mode.out" 2> "$o/sq-$mode.err"
        echo "sq-$mode status $?" >> "$out/objects.status"
    done
    (cd "$base/$tree" && "$bin" -fsyntax-only --predefines "$base/run/predefines-znver5.h" -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall \
        src/buster/compiler/main.c > "$o/self.out" 2> "$o/self.err")
    echo "self status $?" >> "$out/objects.status"
    (cd "$o" && sha256sum *.o *.out *.err) > "$out/objects.sha256"
}
[ -f "$base/run/predefines-znver5.h" ] || clang -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null > "$base/run/predefines-znver5.h"
export EXCLUSIVE_OWNER=claude-892 EXCLUSIVE_TITLE="#892: branch-free sites" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/892
if [ -z "${BUSTER_9700X_HELD:-}" ]; then
    exec ~/buster-fast-bench/exclusive.sh timeout 900 env BUSTER_9700X_HELD=1 "$base/objects.sh" "$@"
fi
head -n 1 /var/lib/buster-9700x/owner >> "$base/results/objects.holds"
for tree in "$@"; do
    run_tree "$tree"
done
echo done > "$base/results/objects.done"
