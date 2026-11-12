#!/bin/bash
# ibs.sh NAME RUNS COMMAND...: COMMAND run RUNS times on CPU 2 under AMD's IBS op sampling (perf record -e
# ibs_op/cnt_ctl=1,swfilt=1/u: each sample tags one dispatched macro-op with its exact address, at a randomized count
# of dispatched ops), with address-space randomization off (setarch -R: a PIE's code is then at 0x555555554000 plus its
# file addresses). Its samples by address go to results/ibs/NAME.addresses ("count address" lines, perf script's), with
# the runs' own user cycles and instructions (perf stat, one more run) in NAME.stat.csv. Run inside one hold of the lock.
# An equivalent of callgrind's per-instruction counts that needs nothing the 9700X lacks; tools/ibs_callgrind.py makes
# gap's input of it. If the command line contains the word FRESH, a fresh speedtest1 database directory is made before
# each run and the command runs inside it.
set -u
cd "$(dirname "$0")"
root=$PWD
name=$1; runs=$2; shift 2
out=$root/results/ibs
mkdir -p "$out"
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
tmp=$(mktemp -d /tmp/claude-tier1-quality-ibs.XXXXXX)
fresh=0; command=()
for a in "$@"; do if [ "$a" = FRESH ]; then fresh=1; else command+=("$a"); fi; done
: > "$tmp/ips.txt"
status=0
for run in $(seq 1 "$runs"); do
    if [ $fresh = 1 ]; then rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"; cd "$tmp/db"; export SQLITE_TMPDIR=$tmp/db/tmp; fi
    taskset -c 2 perf record -q -o "$tmp/perf.data" -e 'ibs_op/cnt_ctl=1,swfilt=1/u' -c 400009 -- setarch x86_64 -R "${command[@]}" > /dev/null 2> "$tmp/record.log" || status=1
    cd "$root"
    perf script -i "$tmp/perf.data" -F ip 2>> "$tmp/script.log" >> "$tmp/ips.txt" || status=1
done
sort "$tmp/ips.txt" | uniq -c > "$out/$name.addresses"
if [ $fresh = 1 ]; then rm -rf "$tmp/db"; mkdir -p "$tmp/db/tmp"; cd "$tmp/db"; fi
taskset -c 2 perf stat -x, -o "$out/$name.stat.csv" -e cycles:u,instructions:u,ex_ret_ops:u,ex_ret_brn:u,ex_ret_near_ret:u -- setarch x86_64 -R "${command[@]}" > /dev/null 2>&1 || status=1
cd "$root"
{ echo "samples $(wc -l < "$tmp/ips.txt") runs $runs status $status"; tail -2 "$tmp/record.log"; tail -2 "$tmp/script.log"; } > "$out/$name.log" 2>&1
rm -rf "$tmp"
