#!/bin/bash
# final.sh STEP: the record's runs, each STEP one hold of the lock (queue.sh runs them in order), pinned to CPU 2 with the
# address-space randomization off (setarch -R: one page state, docs/attested-declarations.md's trap):
#   env          the host's and the tree's identity
#   musl-plain R -c of musl's 1,336 units as one command on one lane under perf stat, round R; round 1 keeps its objects
#   musl-census  measure-attested --passes 3 --twins of the same command (its objects compared with musl-plain's)
#   glibc-plain  -c of the 512 generated glibc units as one command, its objects kept
#   glibc-census measure-attested --passes 3 --twins of them (objects compared)
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/../672-rest-claude/common.sh"
compiler=$here/src/build/compiler
out=$here/results/final
mkdir -p "$out"
mapfile -t sources < "$here/../672-rest-claude/scratch/musl-units.txt"
glibc=("$here"/../672-rest-claude/scratch/glibc-src/*.c)
step=$1
head -1 /var/lib/buster-9700x/owner > "$out/holder-$step${2:+-$2}.txt"
stat_run()
{
    local name=$1; shift
    setarch -R taskset -c 2 perf stat -x, -o "$out/stat-$name.csv" -e '{cycles:u,instructions:u,cycles:k,instructions:k}' -e task-clock,page-faults -- "$@"
}
case $step in
env)
    {
        echo "## date"; date -u +%FT%TZ
        echo "## uname"; uname -a
        echo "## cpu"; grep -m1 'model name' /proc/cpuinfo
        echo "## governor and EPP, CPU 2"; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
        echo "## THP"; cat /sys/kernel/mm/transparent_hugepage/enabled
        echo "## perf_event_paranoid"; cat /proc/sys/kernel/perf_event_paranoid
        echo "## tools"; clang --version | head -1; perf --version
        echo "## tree"; cat "$here/COMMIT"
        echo "## sha256"; sha256sum "$compiler" "$here/../672-rest-claude/scratch/musl-units.txt"; cat "${glibc[@]}" | sha256sum
    } > "$out/env.txt" 2>&1
    ;;
musl-plain)
    dir=$out/musl-plain-objects-$2
    rm -rf "$dir"; mkdir -p "$dir"
    (cd "$dir" && stat_run "musl-plain-$2" "$compiler" "${musl_options[@]}" --lanes 1 -c "${sources[@]}" > /dev/null 2> "$out/musl-plain-$2.err"; echo "musl-plain $2 $?" >> "$out/status.txt")
    if [ "$2" != 1 ]; then rm -rf "$dir"; fi
    ;;
musl-census)
    rm -rf "$out/musl-census-objects"; mkdir -p "$out/musl-census-objects"
    (cd "$out/musl-census-objects" && setarch -R taskset -c 2 "$compiler" measure-attested --list 20 --passes 3 --twins "${musl_options[@]}" -c "${sources[@]}" > "$out/musl-census.txt" 2> "$out/musl-census.err"; echo "musl-census $?" >> "$out/status.txt")
    same=0; different=0
    for f in "$out"/musl-plain-objects-1/*.o; do
        if cmp -s "$f" "$out/musl-census-objects/${f##*/}"; then same=$((same + 1)); else different=$((different + 1)); fi
    done
    echo "musl objects: $same the same bytes, $different different, of $(ls "$out"/musl-plain-objects-1 | wc -l) plain and $(ls "$out"/musl-census-objects | wc -l) census" > "$out/musl-objects.txt"
    if cmp -s "$out/musl-plain-1.err" "$out/musl-census.err"; then echo "musl diagnostics: the same bytes ($(grep -c 'warning:' "$out/musl-census.err") warnings)" >> "$out/musl-objects.txt"; else echo "musl diagnostics: different" >> "$out/musl-objects.txt"; fi
    rm -rf "$out/musl-census-objects" "$out/musl-plain-objects-1"
    ;;
glibc-plain)
    rm -rf "$out/glibc-plain-objects"; mkdir -p "$out/glibc-plain-objects"
    (cd "$out/glibc-plain-objects" && stat_run glibc-plain "$compiler" --lanes 1 -c "${glibc[@]}" > /dev/null 2> "$out/glibc-plain.err"; echo "glibc-plain $?" >> "$out/status.txt")
    ;;
glibc-census)
    rm -rf "$out/glibc-census-objects"; mkdir -p "$out/glibc-census-objects"
    (cd "$out/glibc-census-objects" && setarch -R taskset -c 2 "$compiler" measure-attested --list 20 --passes 3 --twins -c "${glibc[@]}" > "$out/glibc-census.txt" 2> "$out/glibc-census.err"; echo "glibc-census $?" >> "$out/status.txt")
    same=0; different=0
    for f in "$out"/glibc-plain-objects/*.o; do
        if cmp -s "$f" "$out/glibc-census-objects/${f##*/}"; then same=$((same + 1)); else different=$((different + 1)); fi
    done
    echo "glibc objects: $same the same bytes, $different different, of $(ls "$out"/glibc-plain-objects | wc -l) plain and $(ls "$out"/glibc-census-objects | wc -l) census" > "$out/glibc-objects.txt"
    if cmp -s "$out/glibc-plain.err" "$out/glibc-census.err"; then echo "glibc diagnostics: the same bytes" >> "$out/glibc-objects.txt"; else echo "glibc diagnostics: different" >> "$out/glibc-objects.txt"; fi
    rm -rf "$out/glibc-census-objects" "$out/glibc-plain-objects"
    ;;
esac
date -u +%FT%TZ > "$out/.done-$step${2:+-$2}"
