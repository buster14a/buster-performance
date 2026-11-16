#!/bin/bash
# musl-cpuwide.sh RUN [MODE]: (MODE units, the default, or command: the units as one command on one lane, musl-loop.sh)
# compile: the kernel's cycles (period 100003 + 2 RUN) with kernel call chains and the first user frame, every minor
# fault with its address and page size, every mapping's record; -k mono, no address-space randomization (setarch -R);
# perf on CPU 4 with a 64 MB buffer. Then perf script's text (gzip). In one hold of the lock (lock.sh ./musl-cpuwide.sh 0).
set -u
cd "$(dirname "$0")"
here=$PWD
run=${1:?a run number}
mode=${2:-units}
out=results/musl
mkdir -p "$out" scratch
compiler=$here/src/build/compiler
period=$((100003 + 2 * run))
status=0
{ echo "== cpuwide $run $(date -u +%FT%TZ)"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
taskset -c 4 perf record -q -C 2 -m 16384 -k mono -d --data-page-size -o "scratch/musl-$mode-$run.data" \
    -e "cpu/cycles,period=$period/k" -e 'minor-faults/period=1,call-graph=no/' --call-graph fp -- \
    taskset -c 2 setarch -R bash scripts/musl-loop.sh "$mode" "$compiler" > /dev/null 2> "$out/cpuwide-$mode-$run.err" || status=1
{ echo "status $status"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
perf script --ns -i "scratch/musl-$mode-$run.data" --show-mmap-events --show-task-events -F comm,pid,tid,time,event,period,ip,sym,dso,addr,data_page_size \
    2> "$out/script-$mode-$run.err" | gzip -1 > "$out/script-$mode-$run.txt.gz" || status=1
perf report -i "scratch/musl-$mode-$run.data" -D 2> /dev/null | grep -c -E 'PERF_RECORD_(THROTTLE|LOST)' > "$out/throttle-$mode-$run.txt"
rm -f "scratch/musl-$mode-$run.data"
exit $status
