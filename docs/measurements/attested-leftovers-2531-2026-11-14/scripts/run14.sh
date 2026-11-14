#!/bin/bash
# run14.sh STEP ...: #2531's leftovers' final rounds on the 9700X (the caller takes the lock). Trees under this directory
# (TREE, TREE:off for --attested=off); $OPTS (say -g) is added to every command, $LABEL to the results' names. One lane
# pinned to CPU 2, eight to CPUs 0 to 15, setarch -R (one page state).
#   time CORPUS LANES ROUND WAY...     one round, each way in turn under perf stat, its thp_fault_alloc beside it
#   compare CORPUS LANES TREE          TREE --attested=on against TREE --attested=off: every object, the diagnostics
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/../672-rest-claude/common.sh"
out=$here/results
scratch=$here/scratch
mkdir -p "$out" "$scratch"
mapfile -t musl_sources < "$here/../672-rest-claude/scratch/musl-units.txt"
glibc_sources=("$here"/../672-rest-claude/scratch/glibc-src/*.c)
OPTS=${OPTS:-}
LABEL=${LABEL:-}
step=$1
shift
units()
{
    case $1 in
    musl) printf '%s\n' "${musl_options[@]}" "${musl_sources[@]}" ;;
    glibc) printf '%s\n' "${glibc_sources[@]}" ;;
    esac
}
cpus()
{
    if [ "$1" = 1 ]; then echo 2; else echo 0-15; fi
}
case $step in
time)
    corpus=$1 lanes=$2 round=$3
    shift 3
    mapfile -t arguments < <(units "$corpus")
    for way in "$@"; do
        tree=${way%%:*}
        mode=(--attested=on)
        if [ "$way" != "$tree" ]; then mode=(--attested=off); fi
        rm -rf "$scratch/t"; mkdir -p "$scratch/t"
        before=$(awk '/^thp_fault_alloc /{print $2}' /proc/vmstat)
        start=$EPOCHREALTIME
        # shellcheck disable=SC2086
        (cd "$scratch/t" && setarch -R taskset -c "$(cpus "$lanes")" perf stat -x, -o "$out/stat14-$corpus$LABEL-$lanes-${way/:/}-$round.csv" -e 'cycles:u,instructions:u,cycles:k,instructions:k' -e task-clock,page-faults -- \
            "$here/$tree/build/compiler" "${mode[@]}" $OPTS --lanes "$lanes" -c "${arguments[@]}" > /dev/null 2>&1)
        end=$EPOCHREALTIME
        after=$(awk '/^thp_fault_alloc /{print $2}' /proc/vmstat)
        echo "$start $end" | awk '{ printf "%.1f\n", ($2 - $1) * 1000 }' > "$out/wall14-$corpus$LABEL-$lanes-${way/:/}-$round.txt"
        echo "$((after - before))" > "$out/thp14-$corpus$LABEL-$lanes-${way/:/}-$round.txt"
    done
    rm -rf "$scratch/t"
    ;;
compare)
    corpus=$1 lanes=$2 tree=$3
    mapfile -t arguments < <(units "$corpus")
    for mode in off on; do
        rm -rf "$scratch/$mode" "$scratch/work"; mkdir -p "$scratch/work"
        # shellcheck disable=SC2086
        (cd "$scratch/work" && setarch -R taskset -c "$(cpus "$lanes")" "$here/$tree/build/compiler" --attested=$mode $OPTS --lanes "$lanes" -c "${arguments[@]}" > /dev/null 2> "$scratch/$mode.err"; echo $? > "$scratch/$mode.status")
        mv "$scratch/work" "$scratch/$mode"
    done
    same=0 different=0
    for f in "$scratch"/off/*.o; do
        if cmp -s "$f" "$scratch/on/${f##*/}"; then same=$((same + 1)); else different=$((different + 1)); fi
    done
    d=different
    cmp -s <(grep -v -e '^time-' -e '^attested declarations' "$scratch/off.err") <(grep -v -e '^time-' -e '^attested declarations' "$scratch/on.err") && d=same
    echo "$tree $corpus lanes=$lanes $OPTS on against off: status $(cat "$scratch/on.status") $(cat "$scratch/off.status"); objects $same the same, $different different; diagnostics $d ($(grep -c warning: "$scratch/off.err") warnings)" | tee -a "$out/compare14.txt"
    rm -rf "$scratch/on" "$scratch/off" "$scratch"/*.err "$scratch"/*.status
    ;;
esac
