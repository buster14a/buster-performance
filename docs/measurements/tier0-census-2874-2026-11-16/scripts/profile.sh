#!/bin/bash
# profile.sh LABEL CORPUS EVENT PERIOD RUNS [PASSES]: RUNS perf records of the corpus's -c compiles by results/LABEL/compiler
# (compile-all.sh, PASSES passes a record, default 1), on CPU 2, in ONE hold of the lock: user-mode samples of EVENT with
# their branch stacks (-b), run i at period PERIOD + 2i, since a deterministic compile sampled at one period samples the
# same instructions every time. After the hold, on CPU 7 at niceness 19: the samples by address, libc's charged to their
# callers (brips), in results/LABEL/compile-CORPUS-NAME.ips; the records are deleted.
# EVENT is cycles, instructions, mispredicts or fills.
set -u
cd "$(dirname "$0")"
label=$1; name=$2; event=$3; period=$4; runs=$5; passes=${6:-1}
case $event in
cycles) perf_event=cycles:u ;;
instructions) perf_event=instructions:u ;;
mispredicts) perf_event=ex_ret_brn_misp:u ;;
fills) perf_event=ls_dmnd_fills_from_sys.all:u ;;
*) echo "unknown event $event"; exit 1 ;;
esac
out=$PWD/results/$label
scratch=$PWD/scratch/profile-$name-$event
rm -rf "$scratch"; mkdir -p "$scratch"
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
./lock.sh bash -c "
    head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy
    for ((i = 0; i < $runs; i += 1)); do
        perf record -q -b -e $perf_event -c \$(($period + 2 * i)) -o $scratch/\$i.data -- taskset -c 2 ./compile-all.sh $out/compiler $name $passes
    done
    $busy" > "$out/compile-$name-$event.log" 2>&1
echo "status $?" >> "$out/compile-$name-$event.log"
for ((i = 0; i < runs; i += 1)); do
    taskset -c 7 nice -n 19 perf script -i "$scratch/$i.data" --comm compiler -F period,ip,brstack 2>> "$out/compile-$name-$event.log"
done | taskset -c 7 nice -n 19 build/brips "$out/transparent.txt" > "$out/compile-$name-$event.ips" 2>> "$out/compile-$name-$event.log"
echo "runs $runs passes $passes period $period event $perf_event" >> "$out/compile-$name-$event.log"
rm -rf "$scratch"
echo done
