#!/bin/bash
# job-fix3028b.sh REVISION: #3028's fix on the 9700X, on main REVISION: two Release builds, main's (main3030) and the
# fix's (fix3028b: fix-3028b.patch); the three corpora compiled with -c by both, a unit at a time, and the objects
# compared byte for byte; the twenty forms of a truth test on an lvalue at an absolute address (abs3.c) compiled by
# both and their code disassembled; and test-checker's eight parts in the fix's tree, with the toolchain's clang for
# the oracle's builds. Each run, or each corpus's series of compiles, its own hold of the lock.
cd "$(dirname "$0")"
bench=$PWD
revision=$1
./build-label.sh main3030 "$revision" || exit 1
./build-label.sh fix3028b "$revision" fix-3028b.patch || exit 1
base=$bench/results/main3030/compiler
head=$bench/results/fix3028b/compiler
out=$bench/results/fix3028b
. ./corpora.sh
work=/dev/shm/claude-fix3028b
rm -rf "$work"; mkdir -p "$work"
: > "$out/objects.txt"
compare() {
    # compare NAME OPTIONS... FILE: one unit by both compilers; a line of objects.txt.
    name=$1; shift
    "$base" -c "$@" -o "$work/base.o" > "$work/base.log" 2>&1; sb=$?
    "$head" -c "$@" -o "$work/head.o" > "$work/head.log" 2>&1; sh=$?
    if [ $sb = 0 ] && [ $sh = 0 ] && cmp -s "$work/base.o" "$work/head.o"; then verdict=same
    elif [ $sb != 0 ] && [ $sh != 0 ] && cmp -s "$work/base.log" "$work/head.log"; then verdict=both-refuse
    else verdict=DIFFERENT; cp "$work/base.o" "$out/different-$name-base.o" 2>/dev/null; cp "$work/head.o" "$out/different-$name-head.o" 2>/dev/null; fi
    echo "$verdict $sb $sh $name" >> "$out/objects.txt"
}
export -f compare
export base head work out
./lock.sh bash -c "compare sqlite3 $sqlite_arguments"
./lock.sh bash -c 'for f in '"$lua"'/*.c; do compare "lua-$(basename "$f")" "$f"; done'
musl_options="-std=c99 -nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $corpus/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $corpus/musl-generated/obj/include -I $musl/include"
printf '%s\n' "${files[@]}" > "$work/musl-files.txt"
split -n l/8 -d "$work/musl-files.txt" "$work/musl-part-"
for part in "$work"/musl-part-*; do
    ./lock.sh bash -c 'while read -r f; do compare "musl-$(basename "$f")" '"$musl_options"' "$f"; done < '"$part"
done
for which in base head; do
    case $which in base) compiler=$base ;; head) compiler=$head ;; esac
    "$compiler" -c "$bench/abs3.c" -o "$work/abs3-$which.o" > "$out/abs3-$which.log" 2>&1
    echo "abs3 compile status $?" >> "$out/abs3-$which.log"
    objdump -d --no-show-raw-insn "$work/abs3-$which.o" > "$out/abs3-$which.s" 2>&1
done
rm -rf "$work"
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
cd "$bench/trees/fix3028b" || exit 1
mkdir -p build
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
: > "$out/status.txt"
for p in 1 2 3 4 5 6 7 8; do
    start=$(date +%s)
    "$bench/lock.sh" bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $out/compiler test-checker --seed 133 --part $p/8 2> $out/part$p.err; echo status \$?" > "$out/part$p.out" 2>&1
    echo "part $p $(tail -1 "$out/part$p.out"); wall $(( $(date +%s) - start )) s; $(grep 'test-checker:.*checks' "$out/part$p.out" | tail -1)" >> "$out/status.txt"
done
echo job finished
