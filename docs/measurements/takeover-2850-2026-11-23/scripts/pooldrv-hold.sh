#!/bin/bash
# pooldrv-hold.sh OUT: a single fresh compile of sqlite3.c whose reader's and run's arenas are a file's huge pages that a
# previous compile left (trees/pooldrv, BUSTER_EXPERIMENT_POOL_FILE on a tmpfs mounted huge=always for this hold alone;
# not for merge). Settings: a = main; t = the two arenas read as used before, their memory fresh (the clearing's price
# alone); p = their memory the file's. The file is made by one compile, then rounds of a t p p t a, a counted run a
# position. Objects and diagnostics hashed by setting. Also Lua's lvm.c and shell.c on sqlite3.c's leftovers, once.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1
cc="$dir/trees/pooldrv/build/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
lua=$dir/inputs/lua-5.4.8/src
export LC_ALL=C
mkdir -p "$out/scratch" "$dir/hugetmp"; cd "$out/scratch"
mnt="$dir/hugetmp"
sudo -n mount -t tmpfs -o huge=always,size=2G,mode=0700,uid=$(id -u) tmpfs "$mnt" && grep " $mnt " /proc/mounts > "$out/mount.txt"
file="$mnt/pool"
args=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
one()
{
    local key=$1 s=$2
    local -a e=()
    case $s in t) e=(BUSTER_EXPERIMENT_TOUCHED=1);; p) e=(BUSTER_EXPERIMENT_POOL_FILE=$file);; esac
    rm -f ./*.o
    env "${e[@]}" taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,duration_time -o "$out/$key.$s.perf" -- "$cc" "${args[@]}" > /dev/null 2> "$out/$key.$s.err"
    echo "$? $(sha256sum < sqlite3.o | cut -c1-16) $(sha256sum < "$out/$key.$s.err" | cut -c1-16)" > "$out/$key.$s.sha"
}
taskset -c 2 "$cc" "${args[@]}" > /dev/null 2>&1
one make p
grep -E "ShmemHugePages|ShmemPmdMapped" /proc/meminfo > "$out/meminfo-after-make.txt"
du -k "$file" > "$out/file-after-make.txt"
for round in 1 2 3 4 5 6 7; do
    position=0
    for s in a t p p t a; do
        one "r$round.p$position" "$s"
        position=$((position + 1))
    done
done
for s in a p; do
    e=(); [[ $s == p ]] && e=(BUSTER_EXPERIMENT_POOL_FILE=$file)
    env "${e[@]}" taskset -c 2 "$cc" "${args[@]}" --time-stages > /dev/null 2> "$out/stages-$s.txt"
    env "${e[@]}" taskset -c 2 perf record -q -e cycles -c 100003 -o "$out/perf-$s.data" -- "$cc" "${args[@]}" > /dev/null 2>&1
    perf report -i "$out/perf-$s.data" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' | head -30 > "$out/report-$s.txt"
    rm -f "$out/perf-$s.data"
done
# Other compiles on sqlite3.c's leftovers: the same objects as without the file?
for f in "$lua/lvm.c" "$sqlite/shell.c"; do
    n=$(basename "$f" .c)
    taskset -c 2 "$cc" --lanes 1 -c "-I$sqlite" "$f" -o plain.o > /dev/null 2>&1; a=$(sha256sum < plain.o | cut -c1-16)
    BUSTER_EXPERIMENT_POOL_FILE=$file taskset -c 2 "$cc" --lanes 1 -c "-I$sqlite" "$f" -o pooled.o > /dev/null 2>&1; b=$(sha256sum < pooled.o | cut -c1-16)
    echo "$n $a $b" >> "$out/leftovers.txt"
done
one after p
du -k "$file" > "$out/file-at-end.txt"
rm -f "$file" ./*.o
sudo -n umount "$mnt"; grep -c " $mnt " /proc/mounts > "$out/mounted-after.txt"
echo done > "$out/complete"
