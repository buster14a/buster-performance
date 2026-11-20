#!/bin/bash
# #2924 C12c-2: the warnings' twins (bit 12) with warnings on. -c --lanes 1 -Wall -Wextra of sqlite3.c, Lua's units and
# musl's units:
# 1. the census executable (census.sh's) by default and with --scalar: which helpers' arms the warnings reach;
# 2. the gate's knob executables, no bit and bit 12 (compiler-areas4096): objects and stderr compared, stderr's lines
#    counted (so that two empty files can't read as agreement);
# 3. ab, three rounds, around time-runs (three runs) of no bit, bit 12 and no bit again; every run under the lock, CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
G=$D/../c12c
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the warnings with warnings on, C12c-2" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs-w
: > logs-w/status.txt
rm -f logs-w/*.census
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$D/../c3pr/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
W=(-Wall -Wextra)
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
run() { # run EXE OUTDIR LIST STDERR [OPTIONS...]
    local exe=$1 cur=$2 list=$3 err=$4; shift 4
    mkdir -p "$cur"
    case $list in
        sqlite) (cd "$cur" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "$@" "${W[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2> "$err");;
        lua) (cd "$cur" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "$@" "${W[@]}" "$lua"/*.c > /dev/null 2> "$err");;
        musl) (cd "$cur" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "$@" "${W[@]}" "${M[@]}" "${files[@]}" > /dev/null 2> "$err");;
    esac
}
out=/dev/shm/claude-2924-c12w-gate
rm -rf "$out"
for mode in default scalar; do
    opt=(); [ $mode = scalar ] && opt=(--scalar)
    for list in sqlite lua musl; do
        BUSTER_EXIT_HELPER=0 BUSTER_WCENSUS="$D/logs-w/$mode-$list.census" run "$D/compiler" "$out/census/$mode/$list" $list "$D/logs-w/census-$mode-$list.err" "${opt[@]}"
        echo "census $mode $list: $?" >> logs-w/status.txt
    done
done
rm -rf "$out"
for b in 0 12; do
    mask=$(( b == 0 ? 0 : 1 << b ))
    for list in sqlite lua musl; do
        run "$G/compilers/compiler-areas$mask" "$out/objects/$b/$list" $list "$D/logs-w/stderr-bit$b-$list.txt"
        echo "objects bit$b $list: $?" >> logs-w/status.txt
    done
done
n=0; d=0
while read -r f; do
    n=$((n+1)); cmp -s "$out/objects/0/$f" "$out/objects/12/$f" || { d=$((d+1)); echo "differs: $f" >> logs-w/objects-compare.txt; }
done < <(cd "$out/objects/0" && find . -name '*.o' | sort)
echo "objects bit12 against none: $n compared, $d differ" >> logs-w/status.txt
for list in sqlite lua musl; do
    a=logs-w/stderr-bit0-$list.txt; b=logs-w/stderr-bit12-$list.txt
    cmp -s "$a" "$b" && same=same || same=DIFFER
    echo "stderr $list: none $(wc -l < $a) lines, bit12 $(wc -l < $b) lines, $same" >> logs-w/status.txt
done
rm -rf "$out"
BUILDS=(--build none "$G/compilers/compiler-areas0" --build bit12 "$G/compilers/compiler-areas4096" --build none-again "$G/compilers/again/compiler-areas0")
for list in sqlite lua musl; do
    rm -rf "$out"; mkdir -p "$out"
    case $list in
        sqlite) args=(-c --lanes 1 "${W[@]}" "${S[@]}" -o "$out/sqlite3.o");;
        lua) args=(-c --lanes 1 "${W[@]}" "$lua"/*.c);;
        musl) args=(-c --lanes 1 "${W[@]}" "${M[@]}" "${files[@]}");;
    esac
    (cd "$out" && "$G/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$G/compilers/main" \
        -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs-w/time-$list.log" 2>&1)
    echo "time $list: $?" >> logs-w/status.txt
done
rm -rf "$out"
echo done >> logs-w/status.txt
