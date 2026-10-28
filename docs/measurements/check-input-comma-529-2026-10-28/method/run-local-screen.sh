#!/usr/bin/env bash
# Original orchestration; all benchmark work remains inside the caller's cores grant.
set -euo pipefail
root=/home/david/Documents/Codex/2026-10-28/solv/work
evidence=$root/evidence-529
corpus=/home/david/Documents/Codex/2026-10-27/exp/work/corpus
base=$root/baseline-e7f89091/build/compiler
head=$root/next-529/build/compiler
input=$corpus/sqlite/sqlite3.c
flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
       -std=gnu17 --predefines "$corpus/gnu17-pinned-predefines.txt" --clang-features
       --target=x86_64-linux-gnu -march=znver5 -nostdinc
       -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include"
       -isystem "$corpus/headers/usr/include" -I"$corpus/sqlite")
case ${1-} in
    pages)
        "$evidence/comma-pages" "${flags[@]}" "$input"
        "$evidence/comma-pages" "$evidence/tiny.c"
        "$evidence/comma-pages" "$evidence/comma-1024.c"
        ;;
    tiny)
        input=$evidence/tiny.c
        exec "$evidence/samples" 12 1 20 "$input" "$evidence/tiny-ab-local" "$evidence/cohort-local" "$base" "$head" \
            --lanes 1 -c -std=gnu17 --target=x86_64-linux-gnu "$input" -o @OUTPUT@
        ;;
    comma)
        input=$evidence/comma-1024.c
        exec "$evidence/samples" 12 1 2 "$input" "$evidence/comma-ab-local" "$evidence/cohort-local" "$base" "$head" \
            --lanes 1 -c -std=gnu17 --target=x86_64-linux-gnu "$input" -o @OUTPUT@
        ;;
    aa)
        exec "$evidence/samples" 12 1 2 "$input" "$evidence/sql-aa-local" "$evidence/cohort-local" "$base" "$base" \
            --lanes 1 -c "${flags[@]}" "$input" -o @OUTPUT@
        ;;
    reader)
        mkdir -p "$evidence/reader-ab-local-valid"
        for round in 0 1 2 3 4; do
            for turn in 0 1; do
                role=$(((round + turn) % 2))
                binary=$base
                if ((role == 1)); then binary=$head; fi
                prefix=$evidence/reader-ab-local-valid/r$round-role$role
                "$evidence/time-command" "$prefix.time" "$binary" benchmark-checker-bindings --only direct --passes 11 \
                    "${flags[@]}" "$input" > "$prefix.out" 2> "$prefix.err"
            done
        done
        ;;
    *) exit 2 ;;
esac
