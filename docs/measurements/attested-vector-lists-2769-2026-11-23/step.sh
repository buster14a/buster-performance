#!/bin/bash
# (Run from /tmp/2769-claude: benchpress's /home was full on 2026-11-23.)
# step.sh STEP TREE: #2769's before/after on the 9700X, each call one hold of the lock (queue.sh runs them), pinned to
# CPU 2 with the address-space randomization off (setarch -R). TREE is base (main a891cc05) or head (the branch).
#   build    ./build.sh --config Release in TREE
#   memo     a warm memo of sqlite3.c's -c by TREE (one cold run)
#   stat     -c sqlite3.c with TREE's warm memo (read-only), 15 runs under perf stat; and --attested=off, 15 runs
#   record   perf record cycles:u of the warm -c, 3 runs; the last's attested symbols and top symbols
#   census   measure-attested --passes 5 of musl's 1,336 units and of sqlite3.c with shell.c
#   compare  TREE's warm-memo objects and diagnostics against its --attested=off ones, and base's against head's
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$HOME/buster-fast-bench/672-rest-claude/common.sh"
out=$here/results
scratch=$here/scratch
mkdir -p "$out" "$scratch"
mapfile -t sources < "$HOME/buster-fast-bench/672-rest-claude/scratch/musl-units.txt"
step=$1
tree=${2:-}
compiler=$here/$tree/build/compiler
{ echo "== $step $tree $(date -u +%FT%TZ)"; head -3 /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/holds.txt"
case $step in
build)
    (cd "$here/$tree" && ./build.sh --config Release > "$out/build-$tree.log" 2>&1; echo "status $?" >> "$out/build-$tree.log")
    sha256sum "$compiler" >> "$out/compilers.sha256"
    ;;
memo)
    rm -rf "$scratch/memo-$tree" "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 "$compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c" > /dev/null 2> "$out/memo-$tree.err"; echo "memo $tree $?" >> "$out/status.txt")
    chmod -R a-w "$scratch/memo-$tree"
    rm -rf "$scratch/t"
    ;;
stat)
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    for way in memo off; do
        option=(--attested=off)
        [ "$way" = memo ] && option=(--attested-memo="$scratch/memo-$tree")
        (cd "$scratch/t" && setarch -R taskset -c 2 perf stat -r 15 -x, -o "$out/stat-$tree-$way.csv" -e cycles:u,instructions:u,cycles:k,task-clock,page-faults -- \
            "$compiler" "${sqlite_options[@]}" "${option[@]}" -c "$sqlite/sqlite3.c" > /dev/null 2> "$out/stat-$tree-$way.err"; echo "stat $tree $way $?" >> "$out/status.txt")
    done
    rm -rf "$scratch/t"
    ;;
record)
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    # (Five compiles under one record at 50 kHz: about 28,000 samples, so that a pass's 0.1% is 28 of them.)
    for i in 1 2 3 4 5; do printf '%q ' "$compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c"; echo; done > "$scratch/five.sh"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -F 50000 -o "$scratch/r3.data" -- bash "$scratch/five.sh" > /dev/null 2>&1)
    perf report -i "$scratch/r3.data" --no-children --comm compiler --sort symbol --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' > "$scratch/r.txt"
    { perf report -i "$scratch/r3.data" --stdio 2> /dev/null | grep -m1 'of event'; grep -E 'attested' "$scratch/r.txt"; echo "-- top"; head -25 "$scratch/r.txt"; } > "$out/record-$tree.txt"
    rm -rf "$scratch/t" "$scratch"/r?.data "$scratch/r.txt"
    ;;
annotate)
    # Where check_attested_list_run's cycles go: five warm compiles of sqlite3.c under one record, its hottest lines.
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    for i in 1 2 3 4 5; do printf '%q ' "$compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c"; echo; done > "$scratch/five.sh"
    (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:u -F 50000 -o "$scratch/a.data" -- bash "$scratch/five.sh" > /dev/null 2>&1)
    perf annotate -i "$scratch/a.data" --stdio -s check_attested_list_run 2> /dev/null | grep -E '^ +[0-9]+\.[0-9]+ ' | sort -rn | head -60 > "$out/annotate-$tree.txt"
    perf annotate -i "$scratch/a.data" --stdio -s check_attested_list_run 2> /dev/null > "$scratch/annotate-full-$tree.txt"
    rm -rf "$scratch/t" "$scratch/a.data"
    ;;
census)
    rm -rf "$scratch/t"; mkdir -p "$scratch/t"
    (cd "$scratch/t" && setarch -R taskset -c 2 "$compiler" measure-attested --passes 5 "${musl_options[@]}" -c "${sources[@]}" > "$out/census-musl-$tree.txt" 2>&1; echo "census musl $tree $?" >> "$out/status.txt")
    (cd "$scratch/t" && setarch -R taskset -c 2 "$compiler" measure-attested --passes 5 "${sqlite_options[@]}" -c "$sqlite/sqlite3.c" "$sqlite/shell.c" > "$out/census-sqlite-$tree.txt" 2>&1; echo "census sqlite $tree $?" >> "$out/status.txt")
    rm -rf "$scratch/t"
    ;;
compare)
    for name in base ${tree:-head}; do
        for way in memo off; do
            option=(--attested=off)
            [ "$way" = memo ] && option=(--attested-memo="$scratch/memo-$name")
            rm -rf "$scratch/c-$name-$way"; mkdir -p "$scratch/c-$name-$way"
            (cd "$scratch/c-$name-$way" && "$here/$name/build/compiler" "${sqlite_options[@]}" "${option[@]}" -c "$sqlite/sqlite3.c" > stdout.txt 2> diagnostics.err; echo "$?" > status.txt)
        done
    done
    {
        h=${tree:-head}
        for pair in "$h-memo $h-off" "base-memo base-off" "$h-memo base-memo" "$h-off base-off"; do
            set -- $pair
            same=yes
            for f in sqlite3.o stdout.txt diagnostics.err status.txt; do cmp -s "$scratch/c-$1/$f" "$scratch/c-$2/$f" || same="no ($f)"; done
            echo "$1 against $2: $same"
        done
    } > "$out/compare-${tree:-head}.txt"
    rm -rf "$scratch"/c-*
    ;;
esac
echo "== done $step $tree $(date -u +%FT%TZ)" >> "$out/holds.txt"
