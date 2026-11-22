#!/usr/bin/env bash
# extra.sh: the PR body's other checks, under one hold of the lock, with the Release builds (bin/): the strict fixture
# (tests/ir-source/private-values.c with its inlined vector body) compiled by main, by the PR without and with the
# define, under default, all-pass and debug flags, its objects' SHA-256 and the opt-in executables run; the opt-in
# build's 64 generated programs against Clang (the Zen 4 record's seed); and the Zen 4 record's frontier stress
# programs of 64 and 2,200 joins, compiled strictly by the opt-in build and run.
set -uo pipefail
. "$HOME/buster-fast-bench/3067-claude/env.sh"
cd "$W"
export PATH="$CLANG_BIN:$TOOLS_BIN:$PATH"
"$LOCK" timeout -k 10 540 taskset -c 0-7 bash -c '
    set -u
    rm -rf extra; mkdir -p extra
    fixture=pr/tests/ir-source/private-values.c
    for exe in main-release main-on-release off-release on-release; do
        for cfg in default all debug; do
            case $cfg in default) flags=() ;; all) flags=(--tier1-passes=+all) ;; debug) flags=(-g) ;; esac
            bin/$exe --tier1 --tier1-strict --verify -DBUSTER_TEST_INLINE_VECTOR=1 "${flags[@]}" $fixture -c -o extra/$exe-$cfg.o
            echo "compile $exe $cfg exit $?"
        done
    done
    (cd extra && sha256sum *.o)
    for exe in main-release on-release; do
        for cfg in default all debug; do
            case $cfg in default) flags=() ;; all) flags=(--tier1-passes=+all) ;; debug) flags=(-g) ;; esac
            bin/$exe --tier1 --tier1-strict --verify -DBUSTER_TEST_INLINE_VECTOR=1 "${flags[@]}" $fixture -o extra/$exe-$cfg-vector
            echo "link $exe $cfg exit $?"
            timeout 10 ./extra/$exe-$cfg-vector; echo "run $exe $cfg exit $?"
        done
    done
    bin/on-release test-ssa-source --typed --tier1 --lifetimes --clang clang $fixture 2>&1 | tail -2
    echo "fixture ssa-source exit ${PIPESTATUS[0]}"
    (cd pr && ../bin/on-release test-ssa-source --tier1 --typed --lifetimes --generate 64 --seed 48915 --clang clang 2>&1 | tail -3; echo "generate 64 exit ${PIPESTATUS[0]}")
    for n in 64 2200; do
        python3 -I make-frontier-stress.py $n > extra/joins-$n.c
        timeout 120 bin/on-release --lanes 1 --tier1 --tier1-strict --verify extra/joins-$n.c -o extra/stress-$n
        echo "stress $n compile exit $?"
        timeout 10 ./extra/stress-$n; echo "stress $n run exit $?"
    done
' > logs/extra.log 2>&1
echo "extra exit $?" >> logs/extra.log
touch extra.done
