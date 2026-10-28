#!/usr/bin/env bash
set -euo pipefail
root=/home/david/buster-fast-bench/unclaimed-perf-20261028
stage=$root/issue-529-b8ee-clang2314
toolroot=$root/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH="$toolroot/bin:$PATH"
corpus=$root/corpus
flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
       -std=gnu17 --predefines "$corpus/gnu17-pinned-predefines.txt" --clang-features
       --target=x86_64-linux-gnu -march=znver5 -nostdinc
       -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
       -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite")
for role in base head; do sha256sum -c "$stage/hot-$role/placements/SHA256SUMS" > "$stage/placement-$role-identity-before.log"; done
test ! -e "$stage/placement-byte-controls"
mkdir "$stage/placement-byte-controls"
for shift in 0 704 1408 2112 2752 3456; do
    for role in base head; do
        binary=$stage/hot-$role/placements/compiler-$shift
        for name in tiny comma-128 comma-1024; do
            for mode in default scalar; do
                options=()
                if [[ $mode == scalar ]]; then options=(--scalar); fi
                prefix=$stage/placement-byte-controls/$shift-$role-$name-$mode
                "$binary" --lanes 1 "${options[@]}" -c -std=gnu17 --target=x86_64-linux-gnu "$stage/method/$name.c" -o "$prefix.o" > "$prefix.stdout" 2> "$prefix.stderr"
                cmp "$stage/byte-controls/$name-base-$mode.o" "$prefix.o"
                cmp "$stage/byte-controls/$name-base-$mode.stdout" "$prefix.stdout"
                cmp "$stage/byte-controls/$name-base-$mode.stderr" "$prefix.stderr"
                clang "$prefix.o" -o "$prefix.exe"
                "$prefix.exe" > "$prefix.runtime"
                cmp "$stage/byte-controls/$name-clang.stdout" "$prefix.runtime"
            done
        done
        prefix=$stage/placement-byte-controls/$shift-$role-sql
        "$binary" --lanes 1 -c "${flags[@]}" "$corpus/sqlite/sqlite3.c" -o "$prefix.o" > "$prefix.stdout" 2> "$prefix.stderr"
        cmp "$stage/byte-controls/sql-base.o" "$prefix.o"
        cmp "$stage/byte-controls/sql-base.stdout" "$prefix.stdout"
        cmp "$stage/byte-controls/sql-base.stderr" "$prefix.stderr"
    done
done
sha256sum "$stage"/placement-byte-controls/*.o > "$stage/placement-byte-controls/object-SHA256SUMS"
for role in base head; do sha256sum -c "$stage/hot-$role/placements/SHA256SUMS" > "$stage/placement-$role-identity-after.log"; done
printf 'placement byte gate: 84/84 object/stdout/stderr outputs equal original; 72/72 runtimes equal Clang\n'
