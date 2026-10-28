#!/usr/bin/env bash
# Invoked once per approved build/test/screen under exclusive.sh, with its own timeout and CPU affinity.
set -euo pipefail
root=/home/david/buster-fast-bench/unclaimed-perf-20261028
stage=$root/issue-529-b8ee-clang2314
toolroot=$root/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
export PATH="$toolroot/bin:$PATH"
base=$root/integrated-e7-672-clang2314/compiler-native
head=$stage/head/build/compiler
corpus=$root/corpus
input=$corpus/sqlite/sqlite3.c
flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
       -std=gnu17 --predefines "$corpus/gnu17-pinned-predefines.txt" --clang-features
       --target=x86_64-linux-gnu -march=znver5 -nostdinc
       -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
       -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite")
cd "$stage/head"
case ${1-} in
    checker) exec "$head" test-checker ;;
    driver) exec "$head" test-checker-driver --executable "$head" ;;
    deferred) exec "$head" test-checker-deferred ;;
    bytes)
        clang -O2 -Wall -Wextra -Werror "$stage/method/time-command-counters.c" -o "$stage/method/time-command-counters"
        "$stage/method/time-command-counters" "$stage/helper-positive.txt" /bin/true
        if "$stage/method/time-command-counters" "$stage/helper-negative.txt" /bin/false; then exit 1; else status=$?; test "$status" -eq 1; fi
        mkdir -p "$stage/byte-controls"
        for name in tiny comma-128 comma-1024; do
            source=$stage/method/$name.c
            clang -O0 -Wno-unused-value "$source" -o "$stage/byte-controls/$name-clang"
            "$stage/byte-controls/$name-clang" > "$stage/byte-controls/$name-clang.stdout"
            for mode in default scalar; do
                options=()
                if [[ $mode == scalar ]]; then options=(--scalar); fi
                for role in base head; do
                    binary=$base
                    if [[ $role == head ]]; then binary=$head; fi
                    prefix=$stage/byte-controls/$name-$role-$mode
                    "$binary" --lanes 1 "${options[@]}" -c -std=gnu17 --target=x86_64-linux-gnu "$source" -o "$prefix.o" > "$prefix.stdout" 2> "$prefix.stderr"
                    clang "$prefix.o" -o "$prefix.exe"
                    "$prefix.exe" > "$prefix.runtime"
                    cmp "$stage/byte-controls/$name-clang.stdout" "$prefix.runtime"
                done
                cmp "$stage/byte-controls/$name-base-$mode.o" "$stage/byte-controls/$name-head-$mode.o"
                cmp "$stage/byte-controls/$name-base-$mode.stdout" "$stage/byte-controls/$name-head-$mode.stdout"
                cmp "$stage/byte-controls/$name-base-$mode.stderr" "$stage/byte-controls/$name-head-$mode.stderr"
            done
        done
        for role in base head; do
            binary=$base
            if [[ $role == head ]]; then binary=$head; fi
            "$binary" --lanes 1 -c "${flags[@]}" "$input" -o "$stage/byte-controls/sql-$role.o" > "$stage/byte-controls/sql-$role.stdout" 2> "$stage/byte-controls/sql-$role.stderr"
        done
        cmp "$stage/byte-controls/sql-base.o" "$stage/byte-controls/sql-head.o"
        cmp "$stage/byte-controls/sql-base.stdout" "$stage/byte-controls/sql-head.stdout"
        cmp "$stage/byte-controls/sql-base.stderr" "$stage/byte-controls/sql-head.stderr"
        sha256sum "$stage"/byte-controls/*.o > "$stage/byte-controls/object-SHA256SUMS"
        printf 'target byte gate: 7/7 object/stdout/stderr pairs equal; 12/12 generated runtimes match Clang\n'
        ;;
    whole-sql|whole-tiny|whole-comma)
        kind=${1#whole-}
        command=(--lanes 1 -c)
        if [[ $kind == sql ]]; then command+=("${flags[@]}" "$input");
        else
            name=tiny
            if [[ $kind == comma ]]; then name=comma-1024; fi
            command+=(-std=gnu17 --target=x86_64-linux-gnu "$stage/method/$name.c")
        fi
        command+=(-o "$stage/time-output-$kind.o")
        exec "$base" time-runs --runs 11 --warmups 1 --copies 2 --directory /tmp \
            --build base "$base" --build head "$head" --build base-again "$base" --list "${command[@]}"
        ;;
    reader)
        copyroot=$(mktemp -d /tmp/b529-reader-XXXXXX)
        trap 'rm -rf "$copyroot"' EXIT
        mkdir -p "$stage/reader"
        for round in 0 1 2 3 4; do
            for turn in 0 1 2; do
                role=$(((round + turn) % 3))
                binary=$base
                if ((role == 1)); then binary=$head; fi
                copy=$copyroot/r$round-role$role
                mkdir "$copy"
                cp --reflink=never "$binary" "$copy/compiler"
                prefix=$stage/reader/r$round-role$role
                sha256sum "$copy/compiler" > "$prefix.SHA256"
                "$stage/method/time-command-counters" "$prefix.time" "$copy/compiler" benchmark-checker-bindings \
                    --only direct --passes 11 "${flags[@]}" "$input" > "$prefix.out" 2> "$prefix.err"
                grep -q 'status=0 .*counted=1 ' "$prefix.time"
            done
        done
        ;;
    *) exit 2 ;;
esac
