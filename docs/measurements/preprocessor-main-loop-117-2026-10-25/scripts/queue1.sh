#!/usr/bin/env bash
# The first measurements of main's dc8fe2e, each under its own lock.
here="$HOME/buster-fast-bench/pp-117-claude"
cd "$here"
mkdir -p results
./probe.sh base-dc8fe2e sqlite --runs 21 > results/probe-base-sqlite.txt 2>&1
./probe.sh base-dc8fe2e main --runs 11 > results/probe-base-main.txt 2>&1
PROBE_SMAPS=1 ./probe.sh base-dc8fe2e sqlite --runs 3 > results/smaps-base-sqlite.txt 2>&1
./perf.sh base-dc8fe2e sqlite results/perf-base-sqlite --runs 21 > results/perf-base-sqlite.txt 2>&1
echo done > results/queue1.done
