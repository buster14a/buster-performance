#!/usr/bin/env bash
# Main's dc8fe2e: the build, then the measurements, each under its own lock, in order.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
mkdir -p results
./build.sh base-dc8fe2e > results/build-base.txt 2>&1
./bench.sh base-dc8fe2e sqlite > results/bench-base-sqlite.txt 2>&1
./probe.sh base-dc8fe2e sqlite --runs 21 > results/probe-base-sqlite.txt 2>&1
./probe.sh base-dc8fe2e main --runs 11 > results/probe-base-main.txt 2>&1
PROBE_SMAPS=1 ./probe.sh base-dc8fe2e sqlite --runs 3 > results/smaps-base-sqlite.txt 2>&1
./perf.sh base-dc8fe2e sqlite results/perf-base-sqlite --runs 21 > results/perf-base-sqlite.txt 2>&1
echo done > results/queue2.done
