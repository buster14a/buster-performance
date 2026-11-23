#!/bin/bash
# rest.sh: survey2.sh's remaining runs (survey rounds 3 to 5, dom's 5 rounds, the probe) and e2e-wait.sh's, merged into
# as few lock holds as keep each under a minute, since a hold lasts seconds and the lock's queue minutes: rounds 1 to 5
# each one hold of dom's round and, in rounds 1 to 3, survey's rounds 3 to 5; then the probe's units in one hold; then
# e2e.sh's three rounds, all 21 units a hold.
cd ~/buster-fast-bench/1667-claude
D=~/buster-fast-bench/1667-claude
export EXCLUSIVE_OWNER=claude-1667 EXCLUSIVE_TITLE="buster #1667/#1668: the deferred reader's lane rule" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1667
gap='musl/regex/regexec.c musl/stdio/vfprintf.c cts/00204.c musl/thread/pthread_create.c musl/malloc/mallocng/malloc.c musl/math/fmal.c musl/math/lgamma_r.c musl/math/j0.c musl/math/exp2l.c musl/crypt/crypt_des.c lua/lvm.c lua/lparser.c lua/lcode.c lua/lstrlib.c lua/lapi.c'
dom='syn/d16x19f384s288.c syn/d16x19f384s192.c syn/l16x38f384.c syn/h16x38.c sqlite lua/onelua.c syn/d32x10f768s96.c syn/d4x19f768s384.c syn/d24x19f768s48.c syn/d8x38f512s288.c syn/d32x5f384s192.c syn/d12x38f192s192.c syn/d32x10f384s96.c syn/d16x19f256s96.c syn/d32x10f192s48.c syn/d12x38f256s48.c syn/d24x19f384s192.c syn/d16x38f384s96.c syn/d32x19f256s48.c syn/d32x10f96s48.c syn/d24x38f768s288.c'
read -r -a gap_units <<< "$gap"
read -r -a dom_units <<< "$dom"
for round in 1 2 3 4 5; do
    if [ "$round" -le 3 ]; then
        ~/buster-fast-bench/exclusive.sh bash -c "\"$D/scripts/batch.sh\" \"$D/logs/dom.log\" $round rule:8 ${dom_units[*]}; \"$D/scripts/batch.sh\" \"$D/logs/survey.log\" $((round + 2)) every:2,rule:8 ${gap_units[*]}"
    else
        ~/buster-fast-bench/exclusive.sh "$D/scripts/batch.sh" "$D/logs/dom.log" "$round" rule:8 "${dom_units[@]}"
    fi
    echo "$(date -Is) status=$? round=$round" >> logs/rest.queue
done
echo "done $(date -Is)" >> logs/dom.queue
units=()
while read -r u; do units+=("$u"); done < musl-units.txt
for f in c-testsuite/tests/single-exec/*.c; do units+=("cts/$(basename "$f")"); done
for f in lua-5.4.7/src/*.c; do units+=("lua/$(basename "$f")"); done
units+=(sqlite)
~/buster-fast-bench/exclusive.sh "$D/scripts/batch.sh" "$D/logs/probe.log" 1 probe+probe:1 "${units[@]}"
echo "$(date -Is) status=$? probe" >> logs/rest.queue
echo "done $(date -Is)" >> logs/probe.queue
all="syn/d16x19f384s288.c syn/d16x19f384s192.c syn/l16x38f384.c syn/h16x38.c sqlite lua/onelua.c syn/d32x10f768s96.c syn/d4x19f768s384.c syn/d24x19f768s48.c syn/d8x38f512s288.c syn/d32x5f384s192.c syn/d12x38f192s192.c syn/d32x10f384s96.c syn/d16x19f256s96.c syn/d32x10f192s48.c syn/d12x38f256s48.c syn/d24x19f384s192.c syn/d16x38f384s96.c syn/d32x19f256s48.c syn/d32x10f96s48.c syn/d24x38f768s288.c"
scripts/e2e.sh 3 "$all"
