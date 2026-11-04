#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# ab1236f.sh: is head's extra user cycles (time-runs' copies, ab1236d.sh and ab1236e.sh, with or without huge pages) its
# data layout or its code's? swch is head with scripts/switch.patch: main's bound where BUSTER_1236_OLD_BOUND is set,
# so one executable lays out either. Each round runs time-runs of base, head, swch and base again, with copies (tmpfs)
# and without, each with the switch unset and set (only swch reads it). One lock hold per time-runs process.
cd ~/buster-fast-bench/1236-claude
echo $$ > abf.pid
export LC_ALL=C EXCLUSIVE_OWNER=claude-1236 EXCLUSIVE_TITLE="#1236 object_prepare part boundaries: one executable, both bounds" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1236
L=~/buster-fast-bench/exclusive.sh
(cd swch && $L env BUSTER_HOST_ARCH=znver5 ./build.sh 2>&1 | grep -v -E "^exclusive.sh: waiting|^  (title|link|pull request):" | tail -1; exit ${PIPESTATUS[0]})
echo "== build swch status=$? from $(cat swch/COMMIT)"
cd in
sha256sum ../base/build/compiler ../head/build/compiler ../swch/build/compiler ../base-again-compiler tiny.c
echo "== switch through the lock: $(BUSTER_1236_OLD_BOUND=1 $L sh -c 'echo ${BUSTER_1236_OLD_BOUND:-unset}' 2>&1 | grep -v -E '^exclusive.sh|^  (title|link|pull request):')"
$L sh -c '
    ../base/build/compiler -c tiny.c -o tiny-base.o
    ../swch/build/compiler -c tiny.c -o tiny-swch-new.o; echo "== drive swch new status=$?"
    BUSTER_1236_OLD_BOUND=1 ../swch/build/compiler -c tiny.c -o tiny-swch-old.o; echo "== drive swch old status=$?"
    cmp tiny-base.o tiny-swch-new.o && cmp tiny-base.o tiny-swch-old.o && echo "== objects identical"
    echo "== smaps swch new"; gdb -q -batch -x ../scripts/smaps.gdb --args ../swch/build/compiler -c tiny.c -o tiny-smaps.o 2>&1 | grep -E "^anon|huge [1-9]"
    echo "== smaps swch old"; BUSTER_1236_OLD_BOUND=1 gdb -q -batch -x ../scripts/smaps.gdb --args ../swch/build/compiler -c tiny.c -o tiny-smaps.o 2>&1 | grep -E "^anon|huge [1-9]"'
mkdir -p /tmp/claude-1236-copies
B="--build base ../base/build/compiler --build head ../head/build/compiler --build swch ../swch/build/compiler --build base-again ../base/build/compiler"
N="--build base ../base/build/compiler --build head ../head/build/compiler --build swch ../swch/build/compiler --build base-again ../base-again-compiler"
copies() { ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler -- time-runs --runs 31 --copies 3 --directory /tmp/claude-1236-copies $B --list -c tiny.c -o tiny.o; }
plain() { ../head/build/compiler ab --rounds 1 --cpu 2 --lock $L ../head/build/compiler -- time-runs --runs 31 $N --list -c tiny.c -o tiny.o; }
for round in 1 2 3; do
    echo "== case round $round copies switch-unset"; copies; echo "== ab status=$?"
    echo "== case round $round copies switch-set"; BUSTER_1236_OLD_BOUND=1 copies; echo "== ab status=$?"
    echo "== case round $round plain switch-unset"; plain; echo "== ab status=$?"
    echo "== case round $round plain switch-set"; BUSTER_1236_OLD_BOUND=1 plain; echo "== ab status=$?"
done
echo done
