#!/bin/bash
# run8.sh STEP ...: #2531's step 4 (a memo kept across processes), one hold of the lock's work (the caller takes it).
#   warm TREE                     the memo of TREE, made by a process a musl preprocessed unit, then by sqlite3.c twice
#   ppu ROUND TREE WAY...         a round of musl's preprocessed units, a process each, CPU 2, under perf stat: each WAY
#                                 (none: no memo; memo: the warm memo, read only, copied for the round)
#   sqlite ROUND TREE WAY...      a round of -c sqlite3.c, CPU 2, each WAY as ppu's
#   faultprof TREE WAY...        every fourth musl preprocessed unit, a process each, CPU 2: perf record of the page
#                                 faults (by DSO and symbol) and of the kernel's cycles (by symbol), each WAY as ppu's
#   sqliteprof TREE WAY...       -c sqlite3.c, CPU 2: perf record of its page faults (by symbol) and its user and kernel
#                                 cycles (by symbol), each WAY as ppu's
#   ppucompare TREE               every object and the diagnostics of the units by a process each, without and with the memo
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/../672-rest-claude/common.sh"
out=$here/results
scratch=$here/scratch
mkdir -p "$out" "$scratch"
record=$here/../672-rest-claude/scratch
mapfile -t names < "$record/musl-names.txt"
step=$1
shift
loop()
{
    # loop COMPILER MEMO: every musl preprocessed unit by a process of its own, -c, in the current directory
    local compiler=$1 memo=$2 n
    for n in "${names[@]}"; do
        if [ -n "$memo" ]; then
            "$compiler" -std=c99 -nostdinc -ffreestanding --attested-memo="$memo" -c "$record/musl-i/$n.i" 2>> diagnostics.err
        else
            "$compiler" -std=c99 -nostdinc -ffreestanding -c "$record/musl-i/$n.i" 2>> diagnostics.err
        fi
    done
}
case $step in
warm)
    tree=$1
    rm -rf "$scratch/memo-$tree" "$scratch/w"; mkdir -p "$scratch/w"
    (cd "$scratch/w" && taskset -c 2 bash -c "$(declare -f loop); names=(${names[*]}); record=$record; loop $here/$tree/build/compiler $scratch/memo-$tree")
    for i in 1 2; do
        (cd "$scratch/w" && taskset -c 2 "$here/$tree/build/compiler" "${sqlite_options[@]}" --attested-memo="$scratch/memo-$tree" -c "$sqlite/sqlite3.c" 2>> diagnostics.err)
    done
    ls -la "$scratch/memo-$tree" | tee "$out/memo-$tree.txt"
    rm -rf "$scratch/w"
    ;;
ppu)
    round=$1 tree=$2
    shift 2
    for way in "$@"; do
        memo=""
        if [ "$way" = memo ]; then rm -rf "$scratch/m"; cp -r "$scratch/memo-$tree" "$scratch/m"; chmod -R a-w "$scratch/m"; memo=$scratch/m; fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        (cd "$scratch/t" && setarch -R taskset -c 2 perf stat -x, -o "$out/stat-ppu-$tree$way-$round.csv" -e 'cycles:u,instructions:u,cycles:k,instructions:k' -e task-clock,page-faults -- \
            bash -c "$(declare -f loop); names=(${names[*]}); record=$record; loop $here/$tree/build/compiler '$memo'")
        chmod -R u+w "$scratch/m" 2>/dev/null
    done
    rm -rf "$scratch/t" "$scratch/m"
    ;;
sqlite)
    round=$1 tree=$2
    shift 2
    for way in "$@"; do
        option=()
        if [ "$way" = memo ]; then rm -rf "$scratch/m"; cp -r "$scratch/memo-$tree" "$scratch/m"; chmod -R a-w "$scratch/m"; option=(--attested-memo="$scratch/m"); fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        (cd "$scratch/t" && setarch -R taskset -c 2 perf stat -r 3 -x, -o "$out/stat-sqlite4-$tree$way-$round.csv" -e 'cycles:u,instructions:u,cycles:k,instructions:k' -e task-clock,page-faults -- "$here/$tree/build/compiler" "${sqlite_options[@]}" "${option[@]}" -c "$sqlite/sqlite3.c" > /dev/null 2>&1)
        chmod -R u+w "$scratch/m" 2>/dev/null
    done
    rm -rf "$scratch/t" "$scratch/m"
    ;;
faultprof)
    tree=$1
    shift
    subset=()
    for ((i = 0; i < ${#names[@]}; i += 4)); do subset+=("${names[$i]}"); done
    for way in "$@"; do
        memo=""
        if [ "$way" = memo ]; then rm -rf "$scratch/m"; cp -r "$scratch/memo-$tree" "$scratch/m"; chmod -R a-w "$scratch/m"; memo=$scratch/m; fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e page-faults -c 1 -d -o "$scratch/pf.data" -- \
            bash -c "$(declare -f loop); names=(${subset[*]}); record=$record; loop $here/$tree/build/compiler '$memo'" > /dev/null 2>&1)
        perf report -i "$scratch/pf.data" --no-children --comm compiler --sort dso,symbol --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | head -60 > "$out/faults-$tree$way.txt"
        (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e cycles:k -F 20000 -o "$scratch/k.data" -- \
            bash -c "$(declare -f loop); names=(${subset[*]}); record=$record; loop $here/$tree/build/compiler '$memo'" > /dev/null 2>&1)
        perf report -i "$scratch/k.data" --no-children --comm compiler --sort symbol --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | head -60 > "$out/kppu-$tree$way.txt"
        head -12 "$out/faults-$tree$way.txt"
        head -12 "$out/kppu-$tree$way.txt"
        chmod -R u+w "$scratch/m" 2>/dev/null
    done
    rm -rf "$scratch/t" "$scratch/m" "$scratch/pf.data" "$scratch/k.data"
    ;;
sqliteprof)
    tree=$1
    shift
    for way in "$@"; do
        option=()
        if [ "$way" = memo ]; then rm -rf "$scratch/m"; cp -r "$scratch/memo-$tree" "$scratch/m"; chmod -R a-w "$scratch/m"; option=(--attested-memo="$scratch/m"); fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        for event in page-faults cycles:u cycles:k; do
            rate=(-c 1)
            [ "$event" != page-faults ] && rate=(-F 20000)
            for i in 1 2 3; do
                (cd "$scratch/t" && setarch -R taskset -c 2 perf record -q -e "$event" "${rate[@]}" -o "$scratch/s$i.data" -- "$here/$tree/build/compiler" "${sqlite_options[@]}" "${option[@]}" -c "$sqlite/sqlite3.c" > /dev/null 2>&1)
            done
            name=${event%%:*}${event#*:}
            [ "$event" = page-faults ] && name=faults
            perf report -i "$scratch/s3.data" --no-children --comm compiler --sort symbol --stdio 2> /dev/null | grep -v '^#' | grep -v '^$' | head -70 > "$out/sq-$name-$tree$way.txt"
            perf report -i "$scratch/s3.data" --no-children --comm compiler --sort symbol --stdio 2> /dev/null | grep -m1 'Samples\|Event count' >> "$out/sq-$name-$tree$way.txt"
            echo "== $event $way"; head -15 "$out/sq-$name-$tree$way.txt"
        done
        chmod -R u+w "$scratch/m" 2>/dev/null
    done
    rm -rf "$scratch/t" "$scratch/m" "$scratch"/s?.data
    ;;
ppucompare)
    tree=$1
    rm -rf "$scratch/a" "$scratch/b" "$scratch/m"; mkdir -p "$scratch/a" "$scratch/b"; cp -r "$scratch/memo-$tree" "$scratch/m"
    (cd "$scratch/a" && bash -c "$(declare -f loop); names=(${names[*]}); record=$record; loop $here/$tree/build/compiler ''")
    (cd "$scratch/b" && bash -c "$(declare -f loop); names=(${names[*]}); record=$record; loop $here/$tree/build/compiler $scratch/m")
    same=0; different=0
    for f in "$scratch"/a/*.o; do if cmp -s "$f" "$scratch/b/${f##*/}"; then same=$((same+1)); else different=$((different+1)); fi; done
    d=different; cmp -s "$scratch/a/diagnostics.err" "$scratch/b/diagnostics.err" && d=same
    echo "ppu $tree none against memo: objects $same the same, $different different; diagnostics $d ($(grep -c warning: "$scratch/a/diagnostics.err") warnings)" | tee -a "$out/compare.txt"
    rm -rf "$scratch/a" "$scratch/b" "$scratch/m"
    ;;
esac
