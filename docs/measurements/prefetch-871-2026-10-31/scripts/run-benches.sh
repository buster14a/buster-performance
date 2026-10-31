#!/bin/bash
# #871: stage-isolated benchmarks across prefetch variants.
# Usage: run-benches.sh BENCH REPS — interleaves variants per rep.
set -u
cd "$HOME/buster-fast-bench/devin-871"
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
OUT=measure-871/benches
mkdir -p "$OUT"
bench="$1"
reps="$2"
variants=(all none seq ind nonodes)
for rep in $(seq 1 "$reps"); do
    for k in 0 1 2 3 4; do
        v="${variants[$(((k + rep) % ${#variants[@]}))]}"
        case $bench in
            refinement)
                taskset -c 2 ./variants/compiler-$v benchmark-refinement "$C" > "$OUT/refinement-$v-r$rep.txt" 2>&1 ;;
            lowering)
                taskset -c 2 ./variants/compiler-$v benchmark-lowering > "$OUT/lowering-$v-r$rep.txt" 2>&1 ;;
            types)
                taskset -c 2 ./variants/compiler-$v benchmark-types > "$OUT/types-$v-r$rep.txt" 2>&1 ;;
            preprocessor)
                taskset -c 2 ./variants/compiler-$v benchmark-preprocessor "$C" > "$OUT/preprocessor-$v-r$rep.txt" 2>&1 ;;
            files)
                taskset -c 2 ./variants/compiler-$v benchmark-files --runs 3 "$C" > "$OUT/files-$v-r$rep.txt" 2>&1 ;;
            *) echo "unknown bench $bench" >&2; exit 2 ;;
        esac
    done
done
echo "done $bench x$reps"
