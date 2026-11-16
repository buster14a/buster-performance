#!/bin/bash
# totals.sh ROUNDS: whole processes by procbench (a child subreaper, its counters read once every process a run started
# has ended), the compile and the fixed costs, CPU 2; in one hold of the lock (lock.sh ./totals.sh 3).
set -u
cd "$(dirname "$0")"
here=$PWD
rounds=${1:-3}
out=results/totals
mkdir -p "$out" scratch
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
compiler=$here/src/build/compiler
census=$here/census/build/compiler
opts="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
ev=events=cycles-u+cycles-k+instructions-u+instructions-k+page-faults+task-clock+context-switches
stamp=$(date -u +%Y%m%dT%H%M%SZ)
cat > "$out/list-$stamp.txt" <<EOL
sqlite|runs=5,warmups=1,cpus=2,$ev|$compiler -c $opts -o /dev/shm/2873-sqlite.o
sqlite-no-helper|runs=5,warmups=1,cpus=2,$ev,var=BUSTER_EXIT_HELPER=0|$compiler -c $opts -o /dev/shm/2873-sqlite-nh.o
sqlite-btrfs|runs=5,warmups=1,cpus=2,$ev|$compiler -c $opts -o $here/scratch/2873-sqlite.o
sqlite-census|runs=5,warmups=1,cpus=2,$ev|$census -c $opts -o /dev/shm/2873-sqlite-census.o
syntax|runs=5,warmups=1,cpus=2,$ev|$compiler -fsyntax-only $opts
empty|runs=11,warmups=1,cpus=2,$ev|$compiler -c $here/inputs/empty.c -o /dev/shm/2873-empty.o
dumpversion|runs=11,warmups=1,cpus=2,$ev|$compiler -dumpversion
true|runs=11,warmups=1,cpus=2,$ev|/usr/bin/true
EOL
{
    echo "== $stamp"; uname -a; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8
} > "$out/host-$stamp.txt"
./tools/procbench --rounds "$rounds" "$out/list-$stamp.txt" > "$out/totals-$stamp.tsv" 2> "$out/totals-$stamp.err"
status=$?
{ echo "status $status"; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> "$out/host-$stamp.txt"
sha256sum "$compiler" "$census" /dev/shm/2873-sqlite.o /dev/shm/2873-sqlite-census.o "$here/scratch/2873-sqlite.o" >> "$out/host-$stamp.txt"
rm -f /dev/shm/2873-*.o
exit $status
