#!/bin/bash
set -euo pipefail
mode=$1 suite=$2 workers=$3 round=$4 slot=$5 version=$6 outdir=$7
shift 7
work=$PWD
output="$outdir/$suite-$workers-$version.o"
binary="$work/bin/$version"
if [[ $workers == 4 ]]; then binary+=-four; fi
printf '%s %s w%s r%s p%s %s\n' "$mode" "$suite" "$workers" "$round" "$slot" "$version" >&2
snapshot() {
    cat /proc/loadavg >&2
    ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -11 >&2 || :
}
snapshot
rm -f "$output" "$output".{0,1,2,3}
prefix=$(printf '%s\t%s\t%s\t%s\t%s' "$suite" "$workers" "$round" "$slot" "$version")
case $mode in
    time)
        stats=$("$work/bin/time-one" "$binary" -o "$output" "$@")
        printf '%s\t%s\n' "$prefix" "$stats" >> "$work/raw/times.tsv"
        ;;
    perf)
        perf stat --no-big-num -x ';' -o "$outdir/perf.csv" -e cycles:u,instructions:u,branches:u,branch-misses:u -- "$binary" -o "$output" "$@"
        awk -F ';' -v prefix="$prefix" '$3 ~ /^(cycles|instructions|branches|branch-misses):u$/ {print prefix "\t" $3 "\t" $1 "\t" $4 "\t" $5}' "$outdir/perf.csv" >> "$work/raw/pmu.tsv"
        ;;
    verify)
        "$binary" -o "$output" "$@"
        object=$output
        if [[ $workers == 4 ]]; then
            object=$output.0
            for cpu in 1 2 3; do cmp "$object" "$output.$cpu"; done
            cmp "$object" "$outdir/$suite-1-$version.o"
        fi
        marker=full
        if LC_ALL=C grep -aq 'buster direct' "$object"; then marker=direct; fi
        expected=direct
        if [[ $suite == locals-2000 && $version == baseline ]]; then expected=full; fi
        test "$marker" = "$expected"
        hash=$(sha256sum "$object")
        printf '%s\t%s\t%s\t%s\t%s\n' "$suite" "$workers" "$version" "$marker" "${hash%% *}" >> "$work/raw/objects.tsv"
        if [[ $version == candidate && $suite != locals-2000 ]]; then
            reference=$outdir/$suite-$workers-baseline.o
            if [[ $workers == 4 ]]; then reference+=.0; fi
            cmp "$object" "$reference"
        fi
        if [[ $suite == locals-2000 ]]; then
            cc -O0 "$work/input/check-locals.c" "$object" -o "$outdir/check-$version"
            timeout -k 2 10 "$outdir/check-$version"
        fi
        ;;
esac
snapshot
