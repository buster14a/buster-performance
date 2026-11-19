#!/bin/bash
# #2924 C12c's gate, step 3: the areas a plain -c doesn't run. With -c --tier1: the checker's Tier 1 (26), emission's
# foreign twins (28) and the program's emission (18); with -flazy-system-headers -c: the lazy planner (24). Objects of
# each against no bit's first, then ab's three rounds around time-runs (three runs each), under the lock on CPU 2.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the checker's area gate, C12c" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
P=$D/../c3pr
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
musl=$corpus/libc/musl
lua=$P/inputs/lua-5.4.8/src
export LC_ALL=C
files=()
declare -A seen
for f in "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c; do
    b=${f##*/}
    if [[ -z ${seen[$b]:-} ]]; then seen[$b]=1; files+=("$f"); fi
done
S=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c")
M=(-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include")
objects=/dev/shm/claude-2924-c12c-objects2
out=/dev/shm/claude-2924-c12c
for mode in tier1 lazy; do
    case $mode in
        tier1) bits="0 18 26 28"; lists="sqlite lua musl"; opt=(--tier1);;
        lazy) bits="0 24"; lists="sqlite lua"; opt=(-flazy-system-headers);;
    esac
    rm -rf "$objects"
    for b in $bits; do
        mask=$(( b == 0 ? 0 : 1 << b ))
        exe="$D/compilers/compiler-areas$mask"
        for list in $lists; do
            cur=$objects/$b/$list; mkdir -p "$cur"
            case $list in
                sqlite) (cd "$cur" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${S[@]}" -o sqlite3.o > /dev/null 2>> "$D/logs/stderr2-$mode-$b.txt");;
                lua) (cd "$cur" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "$lua"/*.c > /dev/null 2>> "$D/logs/stderr2-$mode-$b.txt");;
                musl) (cd "$cur" && $L timeout -k 5 1500 taskset -c 2 "$exe" -c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}" > /dev/null 2>> "$D/logs/stderr2-$mode-$b.txt");;
            esac
            echo "objects $mode bit$b $list: $?" >> logs/gate2-status.txt
        done
    done
    for b in $bits; do
        [ $b = 0 ] && continue
        n=0; d=0
        while read -r f; do
            n=$((n+1)); cmp -s "$objects/0/$f" "$objects/$b/$f" || { d=$((d+1)); echo "differs $mode bit$b: $f" >> logs/objects2-compare.txt; }
        done < <(cd "$objects/0" && find . -name '*.o' | sort)
        echo "objects $mode bit$b: $n compared, $d differ" >> logs/gate2-status.txt
    done
    rm -rf "$objects"
    BUILDS=(--build none "$D/compilers/compiler-areas0" --build none-again "$D/compilers/again/compiler-areas0")
    for b in $bits; do [ $b = 0 ] || BUILDS+=(--build bit$b "$D/compilers/compiler-areas$((1 << b))"); done
    for list in $lists; do
        rm -rf "$out"; mkdir -p "$out"
        case $list in
            sqlite) args=(-c --lanes 1 "${opt[@]}" "${S[@]}" -o "$out/sqlite3.o");;
            lua) args=(-c --lanes 1 "${opt[@]}" "$lua"/*.c);;
            musl) args=(-c --lanes 1 "${opt[@]}" "${M[@]}" "${files[@]}");;
        esac
        (cd "$out" && "$D/compilers/main" ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh "$D/compilers/main" \
            -- time-runs --runs 3 --directory "$out" "${BUILDS[@]}" --list "${args[@]}" > "$D/logs/time2-$mode-$list.log" 2>&1)
        echo "time $mode $list: $?" >> logs/gate2-status.txt
    done
done
rm -rf "$out"
echo done >> logs/gate2-status.txt
