#!/bin/bash
# step.sh STEP TREE [ARGS]: #2769 on the 9700X, each call one hold of the lock (run by q.sh), pinned to CPU 2 with
# address-space randomization off (setarch -R). TREE is a directory beside this script holding a buster checkout.
#   build    ./build.sh --config Release in TREE
#   memo     a warm memo of sqlite3.c's -c by TREE (one cold run)
#   stat     -c sqlite3.c with TREE's warm memo (read-only), N runs under perf stat; and --attested=off
#   record   perf record cycles:u of five warm -c compiles; the attested symbols and the top ones
#   annotate SYMBOL...: perf annotate of each named symbol from the last record
#   census   measure-attested --passes 5 of musl's units and of sqlite3.c with shell.c
#   compare  TREE's warm-memo objects and diagnostics against its --attested=off ones and against base's
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$HOME/buster-fast-bench/672-rest-claude/common.sh"
out=$here/results
scratch=$here/scratch
mkdir -p "$out" "$scratch"
step=$1
tree=${2:-base}
shift 2 || true
compiler=$here/$tree/build/compiler
runs=${RUNS:-15}
{ echo "== $step $tree $(date -u +%FT%TZ)"; head -3 /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/holds.txt"
case $step in
build)
    (cd "$here/$tree" && ./build.sh --config Release > "$out/build-$tree.log" 2>&1; echo "status $?" >> "$out/build-$tree.log")
    tail -1 "$out/build-$tree.log"
    sha256sum "$compiler" >> "$out/compilers.sha256"
    ;;
memo)
    rm -rf "$scratch/memo-$tree" "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 "$compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c" > /dev/null 2> "$out/memo-$tree.err"; echo "memo $tree $?" | tee -a "$out/status.txt")
    chmod -R a-w "$scratch/memo-$tree"
    rm -rf "$scratch/t"
    ;;
stat)
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    for way in memo off; do
        option=(--attested=off)
        [ "$way" = memo ] && option=(--attested-memo="$scratch/memo-$tree")
        (cd "$scratch/t" && setarch -R taskset -c 2 perf stat -r "$runs" -x, -o "$out/stat-$tree-$way.csv" -e cycles:u,instructions:u,cycles:k,task-clock,page-faults -- \
            "$compiler" "${sqlite_options[@]}" "${option[@]}" -c "$sqlite/sqlite3.c" > /dev/null 2> "$out/stat-$tree-$way.err"; echo "stat $tree $way $?" | tee -a "$out/status.txt")
        grep -E 'cycles:u|instructions:u|page-faults' "$out/stat-$tree-$way.csv"
    done
    rm -rf "$scratch/t"
    ;;
record)
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    for i in 1 2 3 4 5; do printf '%q ' "$compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c"; echo; done > "$scratch/five.sh"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -F 50000 -o "$scratch/rec-$tree.data" -- bash "$scratch/five.sh" > /dev/null 2>&1)
    perf report -i "$scratch/rec-$tree.data" --no-children --comm compiler --sort symbol --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' > "$scratch/r.txt"
    { perf report -i "$scratch/rec-$tree.data" --stdio 2> /dev/null | grep -m1 'of event'; grep -E 'attested' "$scratch/r.txt"; echo "-- top"; head -30 "$scratch/r.txt"; } > "$out/record-$tree.txt"
    cat "$out/record-$tree.txt" | head -24
    rm -rf "$scratch/t" "$scratch/r.txt"
    ;;
annotate)
    for symbol in "$@"; do
        perf annotate -i "$scratch/rec-$tree.data" --stdio -s "$symbol" 2> /dev/null > "$out/annotate-$tree-$symbol.txt"
    done
    ;;
all)
    # memo, record (with annotations of the attested symbols) and stat in one hold of the lock: about 30 s.
    "$0" memo "$tree"
    "$0" record "$tree"
    "$0" annotate "$tree" check_attested_lists check_attested_reach check_attested_chain check_attested_ids check_attested_levels check_attested_hashes check_attested_literals check_attested_after.buster_split
    RUNS=${RUNS:-10} "$0" stat "$tree"
    ;;
census)
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    mapfile -t sources < "$HOME/buster-fast-bench/672-rest-claude/scratch/musl-units.txt"
    (cd "$scratch/t" && setarch -R taskset -c 2 "$compiler" measure-attested --passes 5 "${musl_options[@]}" -c "${sources[@]}" > "$out/census-musl-$tree.txt" 2>&1; echo "census musl $tree $?" | tee -a "$out/status.txt")
    (cd "$scratch/t" && setarch -R taskset -c 2 "$compiler" measure-attested --passes 5 "${sqlite_options[@]}" -c "$sqlite/sqlite3.c" "$sqlite/shell.c" > "$out/census-sqlite-$tree.txt" 2>&1; echo "census sqlite $tree $?" | tee -a "$out/status.txt")
    grep -E 'pass=' "$out/census-sqlite-$tree.txt" "$out/census-musl-$tree.txt" | sed 's/ ticks-per-token.*//'
    rm -rf "$scratch/t"
    ;;
compare)
    for name in base $tree; do
        for way in memo off; do
            option=(--attested=off)
            [ "$way" = memo ] && option=(--attested-memo="$scratch/memo-$name")
            rm -rf "$scratch/c-$name-$way"; mkdir -p "$scratch/c-$name-$way"
            (cd "$scratch/c-$name-$way" && "$here/$name/build/compiler" "${sqlite_options[@]}" "${option[@]}" -c "$sqlite/sqlite3.c" > stdout.txt 2> diagnostics.err; echo "$?" > status.txt)
        done
    done
    {
        for pair in "$tree-memo $tree-off" "base-memo base-off" "$tree-memo base-memo" "$tree-off base-off"; do
            set -- $pair
            same=yes
            for f in sqlite3.o stdout.txt diagnostics.err status.txt; do
                cmp -s "$scratch/c-$1/$f" "$scratch/c-$2/$f" || same="no ($f)"
            done
            echo "$1 vs $2: $same"
        done
    } | tee "$out/compare-$tree.txt"
    ;;
esac
