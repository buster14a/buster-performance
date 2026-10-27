#!/bin/bash
# speedtest1's builds, the compile times, the runs, the counts and the profiles, one after another under one hold of
# the lock (about 60 s).
cd "$(dirname "$0")" || exit 1
echo "== st-build.sh $(date -Is)"
./st-build.sh || { echo "speedtest1's builds failed"; exit 1; }
echo "== st-compile.sh $(date -Is)"
./st-compile.sh
echo "== st-runs.sh $(date -Is)"
./st-runs.sh 11
echo "== st-counts.sh $(date -Is)"
./st-counts.sh 3
echo "== st-profile.sh $(date -Is)"
./st-profile.sh
