#!/bin/bash
# Profile the candidate's unused-intrinsics case and attribute user-cycle samples to the macro run lookup.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p profile
bin=$PWD/candidate/build/compiler
export EXCLUSIVE_OWNER=codex-1364 EXCLUSIVE_TITLE='Issue 1364 macro run lookup profile' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1364
"$HOME/buster-fast-bench/exclusive.sh" timeout -k 5 90 taskset -c 2 perf record -q -e cycles:u -c 16381 -o profile/cycles.data -- "$bin" time-runs --runs 12 --list -w -fsyntax-only -flazy-system-headers "$PWD/comparison/intrinsic.c" > profile/run.log 2>&1
perf script -i profile/cycles.data -F ip,dso | awk '$2 ~ /\/candidate\/build\/compiler\)$/ {print $1}' | sort | uniq -c > profile/ip-counts.txt
awk '{print $2}' profile/ip-counts.txt | addr2line -a -f -i -e "$bin" > profile/lines.txt
awk '
FNR == NR {ip=$2; sub(/^0*/,"",ip); hits["0x"ip]=$1; total+=$1; next}
/^0x/ {ip=$0; sub(/^0x0*/,"0x",ip); next}
/\.c:[0-9]+/ {mapped[ip]=1}
/c_check_lazy.c:[0-9]+/ {
    line=$0; sub(/^.*c_check_lazy.c:/,"",line); line+=0
    if (line>=153 && line<=188) body[ip]=1
    if (line>=169 && line<=183) lookup[ip]=1
}
END {
    for (ip in mapped) symbolized+=hits[ip]
    for (ip in body) classified+=hits[ip]
    for (ip in lookup) searched+=hits[ip]
    print "candidate executable user-cycle samples:", total
    print "with a C source line:", symbolized+0
    print "at definition system-level lookup (including inlined frames):", classified+0
    print "at its macro run binary search, lines 169-183:", searched+0
    exit !(symbolized>total/2)
}' profile/ip-counts.txt profile/lines.txt > profile/summary.txt
cat profile/summary.txt
