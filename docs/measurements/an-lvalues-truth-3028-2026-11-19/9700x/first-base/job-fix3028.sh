#!/bin/bash
# job-fix3028.sh REVISION: #3028's fix on the 9700X (fix-3028.patch on main REVISION): its Release build; twenty forms
# of a truth test on an lvalue at an absolute address compiled with -c and their code disassembled (abs3.c); and
# test-checker's eight parts in the fix's tree, with the toolchain's clang for the oracle's builds. Each run its own
# hold of the lock.
cd "$(dirname "$0")"
bench=$PWD
revision=$1
./build-label.sh fix3028 "$revision" fix-3028.patch || exit 1
out=$bench/results/fix3028
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
"$out/compiler" -c "$bench/abs3.c" -o /dev/shm/fix3028-abs3.o > "$out/abs3.log" 2>&1
echo "abs3 compile status $?" >> "$out/abs3.log"
objdump -d --no-show-raw-insn /dev/shm/fix3028-abs3.o > "$out/abs3.s" 2>&1
rm -f /dev/shm/fix3028-abs3.o
cd "$bench/trees/fix3028" || exit 1
mkdir -p build
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
: > "$out/status.txt"
for p in 1 2 3 4 5 6 7 8; do
    start=$(date +%s)
    "$bench/lock.sh" bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $out/compiler test-checker --seed 133 --part $p/8 2> $out/part$p.err; echo status \$?" > "$out/part$p.out" 2>&1
    echo "part $p $(tail -1 "$out/part$p.out"); wall $(( $(date +%s) - start )) s; $(grep 'test-checker:.*checks' "$out/part$p.out" | tail -1)" >> "$out/status.txt"
done
echo job finished
