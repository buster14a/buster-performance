#!/bin/bash
# totals.sh LABEL [IPS-DIRECTORY]: the profiles' samples against perf stat's counts of the same compiles: for each
# corpus and event, the samples' periods summed over a profile's runs, a run (compile-CORPUS-EVENT.ips, the runs from
# its log), beside perf stat's count (stat-CORPUS.txt), and the ways the samples were charged (brips.c: 0 own address,
# 1 a call found in the branch stack, 3 the stack's end before the call, 2 libc's own address). perf stat counts the
# list's shell too (a bash and a fork a file for Lua and musl); the samples are the compiler's alone. No lock.
# IPS-DIRECTORY is where the .ips files are (default results/LABEL; the record keeps them in profiles.tar.xz).
# results/LABEL/tables/totals.txt.
set -u
cd "$(dirname "$0")"
[ -d results ] || cd ..
label=$1
out=results/$label
ips=${2:-$out}
{
    printf '%-8s %-13s %16s %16s %8s %8s %8s %8s %8s\n' corpus event "samples a run" "perf stat" "ratio" "own %" "call %" "end %" "libc %"
    for name in sqlite3 lua musl; do
        for event in instructions cycles mispredicts fills; do
            case $event in
            cycles) stat_event=cycles:u ;;
            instructions) stat_event=instructions:u ;;
            mispredicts) stat_event=ex_ret_brn_misp:u ;;
            fills) stat_event=ls_dmnd_fills_from_sys.all:u ;;
            esac
            runs=$(awk '$1 == "runs" { print $2 }' "$out/compile-$name-$event.log")
            passes=$(awk '$1 == "runs" { print ($3 == "passes" ? $4 : 1) }' "$out/compile-$name-$event.log")
            counted=$(awk -F, -v e="$stat_event" '$3 == e { print $1 }' "$out/stat-$name.txt")
            awk -v name="$name" -v event="$event" -v runs="$((runs * passes))" -v counted="$counted" '
                { way[$2] += $3; total += $3 }
                END { printf "%-8s %-13s %16.0f %16.0f %8.4f %8.3f %8.3f %8.3f %8.3f\n", name, event, total / runs, counted, total / runs / counted, 100 * way[0] / total, 100 * way[1] / total, 100 * way[3] / total, 100 * way[2] / total }' "$ips/compile-$name-$event.ips"
        done
    done
} > "$out/tables/totals.txt"
cat "$out/tables/totals.txt"
