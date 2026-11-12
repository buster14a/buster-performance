#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# clear.sh NAME ROUNDS [busy]: an eight-core list on the cores no other process computes on, inside one hold of the
# lock (lock.sh ./clear.sh NAME ROUNDS). A process outside the lock held a CPU of the host throughout this record's
# day (raw/stray.txt), and where it sat on one of CPUs 0 to 7 a list's eight lanes had seven CPUs. This takes the
# cores 0 to 7 but the one each process above half a CPU is on (its CPU, or the CPU whose sibling thread it is), writes
# lists/NAME-clear.list, the list with those CPUs and with their count for its commands' lanes and threads, and runs
# it into results/NAME-clear/ (run.sh's layout). With `busy`, tools/spin computes on the last of those CPUs all the
# while, and the results go to results/NAME-clear-busy/: lanes one CPU short, on purpose. CLEAR_TAG=T in the
# environment adds -T to the directory's name: a list run again, where that process moved onto one of the seven CPUs
# during the first run. CLEAR_NEED=N waits (up to 30 s, 2 s at a time) for N of the eight cores to be free of other
# processes and runs nothing without them (status 3): the eight-core pass after that process was gone
# (CLEAR_TAG=8 CLEAR_NEED=8).
set -u
cd "$(dirname "$0")"
. ./common.sh
name=${1:?a list}
rounds=${2:?rounds}
busy=${3:-}
out=$here/results/$name-clear${busy:+-busy}${CLEAR_TAG:+-$CLEAR_TAG}
mkdir -p "$out"
head -1 /var/lib/buster-9700x/owner >> "$out/holder.txt"
need=${CLEAR_NEED:-0}
tries=0
while :; do
    # A process above half a CPU that has run for a second or more (not this pipeline's own).
    taken=$(ps -eo psr,pcpu,etimes,comm --sort=-pcpu | awk 'NR > 1 && $2 > 50 && $3 >= 1 { print $1 % 8 }' | sort -u | tr '\n' ' ')
    set=""
    count=0
    last=0
    for cpu in 0 1 2 3 4 5 6 7; do
        case " $taken " in
            *" $cpu "*) ;;
            *) set="${set:+$set+}$cpu"; count=$((count + 1)); last=$cpu ;;
        esac
    done
    if ((count >= need || tries >= 15)); then break; fi
    tries=$((tries + 1))
    sleep 2
done
if ((count < need)); then
    {
        echo "## $(date -u +%FT%TZ): $count cores free of other processes, $need needed: nothing run"
        ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,4p'
    } >> "$out/others.txt"
    exit 3
fi
{
    echo "## $(date -u +%FT%TZ): cores taken by other processes: ${taken:-none}; CPUs used: $set ($count)"
    ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,4p'
} >> "$out/others.txt"
sed -e "s/cpus=0-7/cpus=$set/" -e "s/--lanes 8/--lanes $count/g" -e "s/--threads=8/--threads=$count/g" -e "s/--thread-count=8/--thread-count=$count/g" \
    "lists/$name.list" > "lists/$name-clear.list"
spinner=0
if [[ -n $busy ]]; then
    taskset -c $last tools/spin 600 &
    spinner=$!
    sleep 0.2
fi
tools/procbench --rounds "$rounds" --out "$out" "lists/$name-clear.list" >> "$out/runs.tsv" 2>> "$out/errors.txt" < /dev/null
status=$?
{
    echo "## after, $(date -u +%FT%TZ)"
    ps -eo psr,pcpu,etime,comm --sort=-pcpu | sed -n '2,4p'
} >> "$out/others.txt"
if ((spinner != 0)); then kill $spinner; wait $spinner 2> /dev/null; fi
echo "rounds $rounds on CPUs $set: status $status at $(date -u +%FT%TZ)" >> "$out/done.txt"
exit $status
