#!/bin/bash
# callgrind.sh BUILDS OUT GLIBC SCRIPTS BUILD...: each BUILD's (tier1, clang2, ...) speedtest1 and five Lua scripts
# under callgrind (--dump-instr=yes: a count per instruction address), as #1189's record ran them, off the 9700X: the
# counts are exact and don't depend on the host. BUILDS holds the executables the 9700X built and timed
# (speedtest1-BUILD, lua-BUILD); GLIBC the 9700X's own loader and C library, which every run goes through, so that the
# programs meet the library they met there; SCRIPTS the five scripts. Each run's output is checked: speedtest1's
# verification hash and each script's output against BUILDS' (the 9700X's). OUT/NAME-BUILD.cg, OUT/runs.txt.
set -u
builds=$(readlink -f "$1"); out=$(readlink -f "$2"); glibc=$(readlink -f "$3"); scripts=$(readlink -f "$4"); shift 4
options="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
loader=("$glibc/ld-linux-x86-64.so.2" --library-path "$glibc")
mkdir -p "$out"
one()
{
    local program=$1 build=$2 status
    local cg=(valgrind --tool=callgrind --dump-instr=yes "--callgrind-out-file=$out/$program-$build.cg")
    if [ "$program" = speedtest1 ]; then
        local d; d=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p "$d/tmp"
        # The timed runs have no --verify: the hash comes from a run of its own, outside callgrind.
        (cd "$d" && SQLITE_TMPDIR=$d/tmp "${loader[@]}" "$builds/speedtest1-$build" $options --verify speedtest1.db > "$out/$program-$build.verify" 2>&1)
        rm -rf "$d"/speedtest1.db* "$d/tmp"; mkdir -p "$d/tmp"
        (cd "$d" && SQLITE_TMPDIR=$d/tmp "${cg[@]}" "${loader[@]}" "$builds/speedtest1-$build" $options speedtest1.db > "$out/$program-$build.out" 2> "$out/$program-$build.err")
        status=$?; rm -rf "$d"
        local hash; hash=$(grep 'Verification Hash' "$out/$program-$build.verify")
        local same=differs; [ "$hash" = "$(grep 'Verification Hash' "$builds/verify-$build.txt")" ] && same=same
        echo "$program $build status $status output $same instructions $(grep -m1 '^summary' "$out/$program-$build.cg" | cut -d' ' -f2) $hash"
    else
        (cd "$scripts" && "${cg[@]}" "${loader[@]}" "$builds/lua-$build" "$program.lua" > "$out/$program-$build.out" 2> "$out/$program-$build.err")
        status=$?
        local same=differs; cmp -s "$out/$program-$build.out" "$builds/$program-$build.out" && same=same
        echo "$program $build status $status output $same instructions $(grep -m1 '^summary' "$out/$program-$build.cg" | cut -d' ' -f2)"
    fi
}
export -f one; export builds out glibc scripts options; export loader_0=${loader[0]}
for build in "$@"; do
    for program in ${PROGRAMS:-speedtest1 calls tables strings arithmetic closures}; do
        echo "$program $build"
    done
done | xargs -P "${JOBS:-3}" -L 1 bash -c 'loader=("$glibc/ld-linux-x86-64.so.2" --library-path "$glibc"); one $0 $1' >> "$out/runs.txt"
sort -o "$out/runs.txt" "$out/runs.txt"
