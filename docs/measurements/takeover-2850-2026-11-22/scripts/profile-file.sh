#!/bin/bash
# profile-file.sh REV NAME FILE: eight cycle profiles (perf record, user and kernel) of -c FILE on CPU 2, under the lock.
set -euo pipefail
dir="$HOME/buster-fast-bench/2850-claude-5a14"
rev=$1; name=$2; file=$3
cc="$dir/trees/$rev/build/compiler"
out="$dir/results/profile-$name-$rev"
rm -rf "$out"; mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-2850-5a14 EXCLUSIVE_TITLE="#2850: profile of -c $name at $rev" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2850
"$HOME/buster-fast-bench/exclusive.sh" bash -c "
    cd '$out'
    cat /proc/loadavg > before.txt
    for i in 1 2 3 4 5 6 7 8; do
        taskset -c 2 perf record -q -e cycles -c 100003 -o perf-\$i.data -- '$cc' --lanes 1 -c '$file' -o x.o 2> /dev/null
    done
    rm -f x.o
" 2> "$out/lock.log"
cd "$out"
for i in 1 2 3 4 5 6 7 8; do perf report -i perf-$i.data --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' > report-$i.txt; done
rm -f perf-*.data
echo done > complete
