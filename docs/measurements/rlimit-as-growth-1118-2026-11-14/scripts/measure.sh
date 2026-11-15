#!/usr/bin/env bash
# #1118: whole compiles, head's measure-compile with base as the reference (their processes in a Williams order), pinned
# to CPU 2, one hold of the lock per input; and the issue's program under a 6 GiB RLIMIT_AS, which both compile within.
set -u
W=$HOME/buster-fast-bench/1118-claude
export EXCLUSIVE_OWNER=claude-1118 EXCLUSIVE_TITLE="Arenas grow in place under a finite RLIMIT_AS (#1118)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1118
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
log() { echo "$(date -u +%FT%TZ) $*" >> $W/log.txt; }
mkdir -p $W/runs && cd $W/runs || exit 1
unset CPATH C_INCLUDE_PATH
test -x $W/compiler-base && test -x $W/compiler-head || { log "missing compilers"; exit 1; }
run() {
    local name=$1 runs=$2 limit=$3; shift 3
    $L bash -c "head -1 /var/lib/buster-9700x/owner; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; cat /proc/loadavg; ulimit -v $limit; taskset -c 2 $W/compiler-head measure-compile --runs $runs --reference $W/compiler-base -- $*; echo status \$?; cat /proc/loadavg" > $name.txt 2>&1
    log "$name exit $?"
}
run hello 41 unlimited -c $I/hello.c
run sys 31 unlimited -c $I/sys.c
run sqlite 21 unlimited -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite3.c
run sys-6g 31 6291456 -c $I/sys.c
log "measured"
