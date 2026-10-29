#!/bin/bash
# Gathers the #840 final campaign's evidence (../pr4) into pr4/evidence6, keeping only the lines the scripts and the
# compiler's tools print, with the identities, the trees' manifests and the host's description.
cd ~/buster-fast-bench/solve147-claude/pr4 || exit 1
O=evidence6
rm -rf $O && mkdir -p $O
keep() { grep -E "$1" "$2" > "$3"; true; }
keep '^(== round |run [0-9]+ list [0-9]+ |list [0-9]+|  (head|base|base-again): |time-runs: |ab: )' shifts6-ab.log $O/ab.log
keep '^(shifted |drive |objects identical|counted|ab status|  (head|base-again): |done)' shifts6.log $O/run.log
for t in base-da842410 head-623d0d18; do
    keep '^build\.sh' shifts-$t.log $O/build-$t.log
    grep -v -E '^(exclusive\.sh: waiting|  (title|link|pull request):)' drive-$t.log > $O/drive-$t.log; true
done
for f in perf6-*.txt; do grep -E '^[0-9]+,' $f > $O/$f; done
sha256sum shifts/base-da842410/compiler-* shifts/head-623d0d18/compiler-* head-623d0d18/build/compiler \
    drive-base-da842410.o drive-head-623d0d18.o ~/buster-fast-bench/exclusive.sh \
    ~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c \
    ~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.h \
    ~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3ext.h > $O/identities.sha256
for t in base-da842410 head-623d0d18; do
    (cd $t && find . -path ./build -prune -o -type f ! -path ./COMMIT -print0 | sort -z | xargs -0 sha256sum) > $O/tree-$t.sha256
    cat $t/COMMIT > $O/commit-$t.txt
done
{
    echo '$ uname -a'; uname -a
    echo '$ lscpu (model)'; lscpu | grep -E '^Model name'
    echo '$ clang --version'; clang --version
    echo '$ perf --version'; perf --version
    echo '$ CPU 2 governor and EPP'; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    echo '$ CPU 10 (CPU 2 sibling) online'; cat /sys/devices/system/cpu/cpu10/online
    echo '$ date -u'; date -u
} > $O/host.txt 2>&1
echo collected
