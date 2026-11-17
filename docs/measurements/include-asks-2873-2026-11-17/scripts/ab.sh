#!/bin/bash
# ab.sh OUT KIND ROUNDS A=COMPILER B=COMPILER: KIND's compiles by A and B, each from a fresh copy of its executable made
# here (cp, a reflink on btrfs: no page of it is in the page cache until it runs), ROUNDS rounds in ABBA order after
# warm-up runs of each, every compile on CPU 2 under waitall (which waits for the exit helper too), counted on CPU 2 as a
# whole (perf stat -C 2 on CPU 4: kernel and user cycles, user instructions, page faults, instruction TLB misses; the
# exit's teardown and the helper included, as #2873's census counted). KIND:
#   sqlite    -c sqlite3.c (the census's options), a compile a count; 3 warm-ups each
#   musl      musl's 1,336 units (scripts/musl-common.sh), a process each, a pass a count; a pass of warm-up each
#   command   the same units as one command on one lane; a warm-up each
#   syntax, preprocess, tiny, hello
#             100 runs a count of an empty file's -fsyntax-only or -E -P, tiny.c's -c or hello.c's -c; 100 warm-ups each
# OUT/NAME-ROUND.csv are the counts; OUT/objects.txt compares A's and B's objects each round (sqlite and command);
# OUT/pagecache.txt says how much of each copy the page cache holds in huge pages after the warm-ups and at the end
# (tools/collapse check). One hold of the lock. BUSTER_* variables in the environment reach the compiles; A_ENV and
# B_ENV (NAME=VALUE) are set for A's and B's counted compiles alone, after warm-ups without them. With SAME set, B runs
# A's copy: both then find the page cache in one state, whatever a look or khugepaged collapsed of it meanwhile, where
# two copies of one executable drift apart by a range or two (a settings' A/B: give A the setting's other value, so
# that both have environments of one size, and stacks that start at one address).
set -u
cd "$(dirname "$0")"
here=$PWD
source ../scripts/musl-common.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
if [ "$1" = --work ]; then
    # --work KIND COMPILER NAME: one count's work by COMPILER, on CPU 2.
    kind=$2
    c=$3
    name=$4
    case $kind in
        sqlite)
            taskset -c 2 ../tools/waitall "$c" -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" \
                -o "/dev/shm/2873-ab-$name.o" ;;
        musl)
            for f in "${files[@]}"; do taskset -c 2 ../tools/waitall "$c" "${options[@]}" -c "$f" -o /dev/shm/2873-ab-unit.o; done ;;
        command)
            rm -rf "/dev/shm/2873-ab-$name" && mkdir -p "/dev/shm/2873-ab-$name" && cd "/dev/shm/2873-ab-$name" || exit 1
            taskset -c 2 "$here/../tools/waitall" "$c" "${options[@]}" --lanes 1 -c "${files[@]}" ;;
        syntax)
            for ((i = 0; i < 100; i += 1)); do taskset -c 2 ../tools/waitall "$c" -fsyntax-only inputs/empty.c; done ;;
        preprocess)
            for ((i = 0; i < 100; i += 1)); do taskset -c 2 ../tools/waitall "$c" -E -P inputs/empty.c; done ;;
        tiny)
            for ((i = 0; i < 100; i += 1)); do taskset -c 2 ../tools/waitall "$c" -c inputs/tiny.c -o /dev/shm/2873-ab-unit.o; done ;;
        hello)
            for ((i = 0; i < 100; i += 1)); do taskset -c 2 ../tools/waitall "$c" -c inputs/hello.c -o /dev/shm/2873-ab-unit.o; done ;;
    esac
    exit 0
fi
out=$1
kind=$2
rounds=$3
mkdir -p "$out"
names=()
declare -A copy
for spec in "$4" "$5"; do
    name=${spec%%=*}
    if [ -n "${SAME:-}" ] && [ ${#names[@]} = 1 ]; then
        copy[$name]=${copy[${names[0]}]}
    else
        cp "${spec#*=}" "$out/$name.compiler" || exit 1
        copy[$name]=$here/$out/$name.compiler
    fi
    names+=("$name")
done
a=${names[0]}
b=${names[1]}
events=cycles:k,cycles:u,instructions:u,page-faults,iTLB-load-misses
: > "$out/objects.txt"
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; sha256sum "$out"/*.compiler; env | grep '^BUSTER_' ; } > "$out/host.txt"
work() { bash "$here/ab.sh" --work "$kind" "${copy[$1]}" "$1"; }
# A's and B's counted compiles take A_ENV's and B_ENV's settings (NAME=VALUE) where they are given; warm-ups don't.
count()
{
    local setting=()
    [ "$1" = "$a" ] && [ -n "${A_ENV:-}" ] && setting=(env "$A_ENV")
    [ "$1" = "$b" ] && [ -n "${B_ENV:-}" ] && setting=(env "$B_ENV")
    taskset -c 4 perf stat -C 2 -x, -e "$events" -o "$out/$1-$2.csv" -- "${setting[@]}" bash "$here/ab.sh" --work "$kind" "${copy[$1]}" "$1" > /dev/null 2> "$out/$1-$2.err"
}
pagecache() { for name in "$a" "$b"; do echo "$1 $name $(tools/collapse "${copy[$name]}" check 0 0x3000000 | sed 's/.*: //')"; done >> "$out/pagecache.txt"; }
: > "$out/pagecache.txt"
warm=1
[ "$kind" = sqlite ] && warm=3
for ((w = 0; w < warm; w += 1)); do work "$a" > /dev/null 2>&1; work "$b" > /dev/null 2>&1; done
sleep 1
pagecache warm
for ((r = 0; r < rounds; r += 1)); do
    if ((r % 2 == 0)); then count "$a" $r; count "$b" $r; else count "$b" $r; count "$a" $r; fi
    case $kind in
        sqlite) echo "$r $(cmp -s "/dev/shm/2873-ab-$a.o" "/dev/shm/2873-ab-$b.o" && echo same || echo DIFFERENT)" >> "$out/objects.txt" ;;
        command) echo "$r $(diff -rq "/dev/shm/2873-ab-$a" "/dev/shm/2873-ab-$b" > /dev/null && echo same || echo DIFFERENT) $(ls "/dev/shm/2873-ab-$a" | wc -l)" >> "$out/objects.txt" ;;
    esac
done
pagecache end
{ date -u; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; } >> "$out/host.txt"
rm -rf /dev/shm/2873-ab-* "$out"/*.compiler
