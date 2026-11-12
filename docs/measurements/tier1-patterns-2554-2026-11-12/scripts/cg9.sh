#!/bin/bash
# cg9.sh DIR: DIR's speedtest1-0 and lua-0 (the 9700X's placement-0 builds) under callgrind through the 9700X's own loader
# and C library, speedtest1 without --verify as it is timed, each Lua script's output kept. DIR/*.cg, DIR/runs.txt.
set -u
dir=$(readlink -f "$1")
glibc=$HOME/.cache/claude-2554/glibc
scripts=/home/user/buster-performance/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
options="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
one()
{
    local program=$1
    local cg=(valgrind --tool=callgrind --dump-instr=yes "--callgrind-out-file=$dir/$program.cg")
    local loader=("$glibc/ld-linux-x86-64.so.2" --library-path "$glibc")
    if [ "$program" = speedtest1 ]; then
        local d; d=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p "$d/tmp"
        (cd "$d" && SQLITE_TMPDIR=$d/tmp "${loader[@]}" "$dir/speedtest1-0" $options --verify speedtest1.db 2>&1 | grep 'Verification Hash' > "$dir/speedtest1.verify")
        rm -rf "$d"/speedtest1.db* "$d/tmp"; mkdir -p "$d/tmp"
        (cd "$d" && SQLITE_TMPDIR=$d/tmp "${cg[@]}" "${loader[@]}" "$dir/speedtest1-0" $options speedtest1.db > "$dir/$program.out" 2> "$dir/$program.err")
        echo "$program status $? $(grep -m1 '^summary' "$dir/$program.cg") $(cat "$dir/speedtest1.verify")"; rm -rf "$d"
    else
        (cd "$scripts" && "${cg[@]}" "${loader[@]}" "$dir/lua-0" "$program.lua" > "$dir/$program.out" 2> "$dir/$program.err")
        echo "$program status $? $(grep -m1 '^summary' "$dir/$program.cg") $(md5sum < "$dir/$program.out" | cut -c1-12)"
    fi
}
export -f one; export dir glibc scripts options
printf '%s\n' speedtest1 calls tables strings arithmetic closures | xargs -P 4 -I{} bash -c 'one {}' | sort > "$dir/runs.txt"
cat "$dir/runs.txt"
