#!/bin/bash
# job-gat2.sh: the sweep piece on the 9700X, in turn, each run its own hold of the lock:
#   1. its build (gat2: contexts-gat2.patch, the piece on PR #3030's sources, on the revision br2 was built on), and
#      test-checker's eight parts in its tree, with the toolchain's clang for the oracle's builds;
#   2. the build against the build before (br2), as job-gat.sh runs them: seven readings on sqlite3.c, Lua and musl of
#      the tests on the window and of C on the window;
#   3. one executable with the experiment's switch (gat2x: contexts-gat2x.patch), the loads on and the gathers off, as
#      job-gat-knob.sh runs it.
cd "$(dirname "$0")"
bench=$PWD
./job-gat.sh gat2 contexts-gat2.patch br2 || echo "job 2 FAILED"
out=$bench/results/gat2
clang_bin=$(dirname "$(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)")
export PATH=$clang_bin:$PATH
(
    cd "$bench/trees/gat2" || exit 1
    mkdir -p build
    clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
    : > "$out/status.txt"
    for p in 1 2 3 4 5 6 7 8; do
        start=$(date +%s)
        "$bench/lock.sh" bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $out/compiler test-checker --seed 133 --part $p/8 2> $out/part$p.err; echo status \$?" > "$out/part$p.out" 2>&1
        echo "part $p $(tail -1 "$out/part$p.out"); wall $(( $(date +%s) - start )) s; $(grep 'test-checker:.*checks' "$out/part$p.out" | tail -1)" >> "$out/status.txt"
    done
) || echo "job 1 FAILED"
./job-gat-knob.sh gat2x contexts-gat2x.patch br2 || echo "job 3 FAILED"
echo all jobs finished
