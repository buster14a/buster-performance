#!/bin/bash
# perf14.sh FILE...: one run of the front with the window on sqlite3.c (--front-window) under IBS fetch sampling for
# each compiler FILE (a path under results/), under the lock, CPU 2: the fetch samples in the executable's own text by
# the L1 ITLB's page size, their op cache misses and instruction cache misses, and the front's ticks.
cd "$(dirname "$0")"
. ./corpora.sh
data=/dev/shm/claude-2850-tests.perf.data
for file in "$@"; do
    ./lock.sh bash -c "perf record -q -e ibs_fetch/swfilt=1/u -c 100003 --raw-samples -o $data -- taskset -c 2 $PWD/results/$file measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > /dev/shm/claude-2850-perf14-run.txt 2>&1"
    perf script -i $data -D 2>/dev/null | awk -v file="$file" -v front="$(grep -o 'the front with the window: ticks=[0-9]*' /dev/shm/claude-2850-perf14-run.txt | grep -o '[0-9]*$')" '
        /^ibs_fetch_ctl:/ { ctl = $0 }
        /PERF_RECORD_SAMPLE/ { ip = ""; for (i = 1; i <= NF; i++) { if ($i == "period:") ip = $(i - 1) } v = strtonum(ip); if (v >= 0x171eb40 && v < 0x4566000) { n++; if (match(ctl, /L1TlbPgSz [^ ]+/)) size[substr(ctl, RSTART + 10, RLENGTH - 10)]++; if (ctl ~ /FetchOcMiss 1/) oc++; if (ctl ~ /IcMiss 1/) ic++; if (ctl ~ /L1TlbMiss 1/) tlb++ } }
        END { printf "%s: front %s; fetch samples in its text %d; op cache misses %d; instruction cache misses %d; L1 ITLB misses %d; by page size:", file, front, n, oc, ic, tlb; for (s in size) printf " %s %d", s, size[s]; printf "\n" }'
    rm -f $data /dev/shm/claude-2850-perf14-run.txt
done
echo perf14 done
