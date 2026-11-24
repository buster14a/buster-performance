#!/bin/bash
# warms-hold.sh OUT: as warm-hold.sh, with the scratch arena warm too as a third setting (an experiment: warm-v2-scratch.patch).
# file of a tmpfs mounted huge=always for this hold alone. Trees: warmbase = main 939732da; warm = that and the change.
# Settings: a = main; b = the change, no pool (what it costs unasked); p = the change with BUSTER_ARENA_POOL. The file is
# made by two compiles (the second clears what the first allocated and left unwritten), then rounds of a b p p b a, a
# counted run a position. Objects and diagnostics hashed by setting; a filled compile's too. Then Lua's 33 files, each a
# process, on sqlite3.c's leftovers, by a and p, counted and hashed.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1
base="$dir/trees/warmbase/build/compiler"
warm="$dir/trees/warms/build/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
lua=$dir/inputs/lua-5.4.8/src
export LC_ALL=C
mkdir -p "$out/scratch" "$dir/hugetmp"; cd "$out/scratch"
mnt="$dir/hugetmp"
sudo -n mount -t tmpfs -o huge=always,size=2G,mode=0700,uid=$(id -u) tmpfs "$mnt" && grep " $mnt " /proc/mounts > "$out/mount.txt"
args=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
one()
{
    local key=$1 s=$2 cc=$warm
    local -a e=(A=1)
    case $s in a) cc=$base;; p) e=(BUSTER_ARENA_POOL=$mnt);; s) e=(BUSTER_ARENA_POOL=$mnt BUSTER_EXPERIMENT_WARM_SCRATCH=1);; f) e=(BUSTER_TEST_ARENA_FILL=1 BUSTER_EXPERIMENT_WARM_SCRATCH=1);; esac
    rm -f ./*.o
    env "${e[@]}" taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,duration_time -o "$out/$key.$s.perf" -- "$cc" "${args[@]}" > /dev/null 2> "$out/$key.$s.err"
    echo "$? $(sha256sum < sqlite3.o | cut -c1-16) $(sha256sum < "$out/$key.$s.err" | cut -c1-16)" > "$out/$key.$s.sha"
}
taskset -c 2 "$base" "${args[@]}" > /dev/null 2>&1
one cold s
ls -ls "$mnt" > "$out/file-after-first.txt"; grep -E "ShmemHugePages|ShmemPmdMapped" /proc/meminfo >> "$out/file-after-first.txt"
one second s
ls -ls "$mnt" > "$out/file-after-second.txt"; grep -E "ShmemHugePages|ShmemPmdMapped" /proc/meminfo >> "$out/file-after-second.txt"
one fill f
for round in 1 2 3 4 5 6 7; do
    position=0
    for s in a p s s p a; do
        one "r$round.p$position" "$s"
        position=$((position + 1))
    done
done
ls -ls "$mnt" > "$out/file-after-rounds.txt"
for s in a p s; do
    cc=$warm; e=(A=1)
    case $s in a) cc=$base;; p) e=(BUSTER_ARENA_POOL=$mnt);; s) e=(BUSTER_ARENA_POOL=$mnt BUSTER_EXPERIMENT_WARM_SCRATCH=1);; esac
    for n in 1 2 3; do
        env "${e[@]}" taskset -c 2 "$cc" "${args[@]}" --time-stages > /dev/null 2> "$out/stages-$s-$n.txt"
    done
    env "${e[@]}" taskset -c 2 perf record -q -e cycles -c 100003 -o "$out/perf-$s.data" -- "$cc" "${args[@]}" > /dev/null 2>&1
    perf report -i "$out/perf-$s.data" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' | head -30 > "$out/report-$s.txt"
    rm -f "$out/perf-$s.data"
done
# Lua's files, each a process, on sqlite3.c's leftovers: three rounds of a p p a over the 33.
for round in 1 2 3; do
    position=0
    for s in a s s a; do
        cc=$warm; e=(A=1)
        case $s in a) cc=$base;; p) e=(BUSTER_ARENA_POOL=$mnt);; s) e=(BUSTER_ARENA_POOL=$mnt BUSTER_EXPERIMENT_WARM_SCRATCH=1);; esac
        : > "$out/lua.r$round.p$position.$s.sha"
        for f in "$lua"/*.c; do
            n=$(basename "$f" .c)
            env "${e[@]}" taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults -o "$out/lua.one.perf" -- "$cc" --lanes 1 -c "$f" -o lua.o > /dev/null 2> lua.err
            echo "$n $? $(sha256sum < lua.o | cut -c1-16) $(sha256sum < lua.err | cut -c1-16) $(grep -E 'cycles:u|cycles:k|instructions:u|page-faults' "$out/lua.one.perf" | cut -d, -f1 | tr '\n' ' ')" >> "$out/lua.r$round.p$position.$s.sha"
        done
        position=$((position + 1))
    done
done
rm -f "$out/lua.one.perf"
ls -ls "$mnt" > "$out/file-at-end.txt"
rm -f "$mnt"/buster-arena-* ./*.o
sudo -n umount "$mnt"; grep -c " $mnt " /proc/mounts > "$out/mounted-after.txt"
echo done > "$out/complete"
