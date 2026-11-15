#!/bin/bash
# The takeover's diagnosis of #2790's test-checker-driver failures, on a cloud x86-64 container with AVX-512.
# BASE and HEAD are compilers built by ./build.sh (Develop) at 45cd9aec and 2011ce042; CLANG4 is CI's staged clang 23.1.4,
# CLANG6 Ubuntu's 23.1.6, SSP the wrapper that adds -fstack-protector-strong to CLANG6. Run from this directory.
set -u
BASE=${BASE:?}; HEAD=${HEAD:?}; CLANG4=${CLANG4:?}; CLANG6=${CLANG6:?}; SSP=$PWD/clang-stack-protector.sh
echo "## 1. The PR's fixture: the report's counters, by HEAD, both host paths"
for f in fixture-before fixture-after; do
    for p in "" "--tier1-passes=-vectors" "--tier1-passes=+gvn"; do
        for s in "" "--scalar"; do
            printf '%s %s %s: ' $f "${p:-default}" "${s:-vector}"
            $HEAD --tier1 --tier1-report --tier1-refusals --verify $p $s -o $f.out $f.c 2>&1 | tr '\t' '\n' | grep -E '^(licm_moved|gvn_removed)=' | tr '\n' ' '
            echo "output $(./$f.out)"
        done
    done
done
echo "## 2. +gvn removes the same count with one a + a as with two"
for f in fixture-before fixture-single-add; do printf '%s +gvn: ' $f; $HEAD --tier1 --tier1-report --verify --tier1-passes=+gvn -o x.out $f.c 2>&1 | tr '\t' '\n' | grep -E '^gvn_removed='; done
echo "## 3. #1373's program: clang's output and the compilers'"
for o in "" "-fno-builtin-labs"; do
    for cl in $CLANG4 $CLANG6 $SSP; do $cl -std=gnu17 -w computed-1373.c -o c.out -lm $o && echo "clang $($cl --version | head -1 | grep -o '23\.[0-9.]*' | head -1)$( [ $cl = $SSP ] && echo ' -fstack-protector-strong') ${o:-}: $(./c.out | cut -c1-12)"; done
    for c in BASE HEAD; do for s in "" --scalar; do ${!c} -std=gnu17 -w computed-1373.c -o b.out -lm $o $s && echo "$c ${s:-vector} ${o:-}: $(./b.out | cut -c1-12)"; done; done
done
echo "## 4. clang -O0's memcpy calls in it, without and with the stack protector"
for cl in $CLANG6 $SSP; do $cl -std=gnu17 -w -O0 -S computed-1373.c -o m.s; echo "$cl: $(grep -c 'call.*memcpy' m.s) memcpy calls"; done
rm -f *.out m.s
