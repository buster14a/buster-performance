#!/bin/bash
# unit-stage-bench.sh: tools/unit_stage_bench.c on the static call graphs of the timed --tier1 builds of speedtest1 and
# Lua (scratch/main; tools/call_edges.py from their disassemblies), built by clang -O2 -march=native without the
# auto-vectorizers (the scalar forms are the twins as written) and run on CPU 2, three times. Run inside one hold of
# the lock. results/bench/unit-stage.txt, *.edges.
set -eu
cd "$(dirname "$0")"
out=$PWD/results/bench
mkdir -p "$out"
export LC_ALL=C
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
for p in speedtest1 lua; do
    objdump -d --no-show-raw-insn "scratch/main/$p-tier1" > "$out/$p.dis"
    python3 tools/call_edges.py "$out/$p.dis" > "$out/$p.edges"
    rm -f "$out/$p.dis"
done
clang -O2 -march=native -fno-vectorize -fno-slp-vectorize -o "$out/unit_stage_bench" tools/unit_stage_bench.c
clang --version | head -1 > "$out/unit-stage.txt"
for run in 1 2 3; do
    echo "run $run" >> "$out/unit-stage.txt"
    taskset -c 2 "$out/unit_stage_bench" "$out/speedtest1.edges" "$out/lua.edges" >> "$out/unit-stage.txt"
done
rm -f "$out/unit_stage_bench"
