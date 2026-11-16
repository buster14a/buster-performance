#!/bin/bash
# stat.sh LABEL CORPUS RUNS [ROUND]: perf stat of the corpus's -c compiles (compile-all.sh, one pass), RUNS times, CPU 2,
# in ONE hold of the lock: user cycles, instructions, mispredicted branches and first-level fills, the kernel's cycles
# and the minor faults. For Lua and musl the counts have the list's shell too (a bash and a fork a file). The objects
# stay in /dev/shm/claude-2891-o-LABEL for objects.sh and shapes.sh. With ROUND, one of several holds that alternate
# between two labels (queue-rounds.txt), so that the machine's drift between holds shows in a label's own rounds.
# results/LABEL/stat-CORPUS.txt, or stat-CORPUS-ROUND.txt.
set -u
cd "$(dirname "$0")"
label=$1; name=$2; runs=$3; round=${4:+-$4}
out=$PWD/results/$label
busy="ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg"
./lock.sh bash -c "
    head -1 /var/lib/buster-9700x/owner | cut -c1-200; $busy
    perf stat -x, -r $runs -e cycles:u,instructions:u,ex_ret_brn_misp:u,ls_dmnd_fills_from_sys.all:u,cycles:k,minor-faults,task-clock -- taskset -c 2 ./compile-all.sh $label $name 1
    $busy" > "$out/stat-$name$round.txt" 2>&1
echo "status $?" >> "$out/stat-$name$round.txt"
echo done
