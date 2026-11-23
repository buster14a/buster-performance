#!/bin/bash
# pool-hold.sh OUT: a single fresh compile of sqlite3.c whose arenas' memory is a tmpfs file a previous compile left
# (trees/pool1, BUSTER_EXPERIMENT_POOL_FILE; not for merge), in one hold: settings a = anonymous memory as main has it,
# b = the file in base pages (made with shmem_enabled as found, never), c = the file in huge pages (made with
# shmem_enabled=advise, which this script sets for its hold and puts back). Each file is made by one compile, then
# rounds of a b c c b a, a counted run a position. Objects and diagnostics hashed by setting.
set -uo pipefail
dir="$HOME/buster-fast-bench/2850-claude-01Egbx"
out=$1
cc="$dir/trees/pool1/build/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export LC_ALL=C BUSTER_EXPERIMENT_FRESH_LIST="$dir/zero35.list"
mkdir -p "$out/scratch"; cd "$out/scratch"
args=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
fb=/dev/shm/buster-pool-01egbx-base
fc=/dev/shm/buster-pool-01egbx-huge
rm -f "$fb" "$fc"
setting=/sys/kernel/mm/transparent_hugepage/shmem_enabled
cat "$setting" > "$out/shmem-before.txt"
one()
{
    local key=$1 s=$2 file=
    case $s in b) file=$fb;; c) file=$fc;; esac
    rm -f ./*.o
    if [[ -n $file ]]; then
        BUSTER_EXPERIMENT_POOL_FILE=$file BUSTER_EXPERIMENT_KEEP_PAGES=2 taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,duration_time -o "$out/$key.$s.perf" -- "$cc" "${args[@]}" > /dev/null 2> "$out/$key.$s.err"
    else
        taskset -c 2 perf stat -x, -e cycles:u,cycles:k,instructions:u,page-faults,duration_time -o "$out/$key.$s.perf" -- "$cc" "${args[@]}" > /dev/null 2> "$out/$key.$s.err"
    fi
    echo "$? $(sha256sum < sqlite3.o | cut -c1-16) $(sha256sum < "$out/$key.$s.err" | cut -c1-16)" > "$out/$key.$s.sha"
}
taskset -c 2 "$cc" "${args[@]}" > /dev/null 2>&1
one make b
grep -E "ShmemHugePages|Shmem:" /proc/meminfo > "$out/meminfo-after-base.txt"
sudo -n sh -c "echo advise > $setting" && cat "$setting" > "$out/shmem-during.txt"
one make c
grep -E "ShmemHugePages|Shmem:" /proc/meminfo > "$out/meminfo-after-huge.txt"
du -k "$fb" "$fc" > "$out/files.txt" 2>&1
for round in 1 2 3 4 5 6 7; do
    position=0
    for s in a b c c b a; do
        one "r$round.p$position" "$s"
        position=$((position + 1))
    done
done
for s in a b c; do
    case $s in a) e=();; b) e=(BUSTER_EXPERIMENT_POOL_FILE=$fb BUSTER_EXPERIMENT_KEEP_PAGES=2);; c) e=(BUSTER_EXPERIMENT_POOL_FILE=$fc BUSTER_EXPERIMENT_KEEP_PAGES=2);; esac
    env "${e[@]}" taskset -c 2 "$cc" "${args[@]}" --time-stages > /dev/null 2> "$out/stages-$s.txt"
    env "${e[@]}" taskset -c 2 perf record -q -e cycles -c 100003 -o "$out/perf-$s.data" -- "$cc" "${args[@]}" > /dev/null 2>&1
    perf report -i "$out/perf-$s.data" --stdio --no-children --sort symbol -F overhead,period,symbol 2>/dev/null | grep -v '^#' | grep -v '^$' | head -40 > "$out/report-$s.txt"
    rm -f "$out/perf-$s.data"
done
sudo -n sh -c "echo never > $setting"; cat "$setting" > "$out/shmem-after.txt"
rm -f "$fb" "$fc" ./*.o
echo done > "$out/complete"
