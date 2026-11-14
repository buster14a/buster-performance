#!/bin/bash
# #2531's leftovers, the final rounds: mainF (main c513832, the branch's base) against fixF (be7b62ba7: the field test,
# -g skipping, the viewed unit's discards). Each line a hold of the lock.
cd ~/buster-fast-bench/2531-step3c-claude
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
if [ ! -x mainF/build/compiler ]; then
    rm -rf mainF && git clone -q --reference ../1840-fma/repo https://github.com/buster14a/buster mainF && git -C mainF checkout -q c513832cf
    x ./build.sh mainF
fi
if [ ! -x fixF/build/compiler ]; then
    rm -rf fixF && git clone -q --reference ../1840-fma/repo https://github.com/buster14a/buster fixF && git -C fixF fetch -q origin claude/vigilant-turing-p4qu3j && git -C fixF fetch -q ../fix.bundle thp-2531:thp-2531 && git -C fixF checkout -q thp-2531 && git -C fixF log --oneline -1
    x ./build.sh fixF
fi
for c in "musl 1" "glibc 1" "musl 8"; do x ./run14.sh compare $c fixF; done
OPTS=-g x ./run14.sh compare musl 1 fixF
OPTS=-g x ./run14.sh compare glibc 1 fixF
for r in 1 2 3 4 5; do
    x ./run14.sh time musl 1 $r mainF fixF fixF:off
    x ./run14.sh time glibc 1 $r mainF fixF fixF:off
done
for r in 1 2 3 4 5; do
    OPTS=-g LABEL=-g x ./run14.sh time musl 1 $r mainF fixF
    OPTS=-g LABEL=-g x ./run14.sh time glibc 1 $r mainF fixF
done
for r in 1 2 3; do x ./run14.sh time musl 8 $r mainF fixF; x ./run14.sh time glibc 8 $r mainF fixF; done
x ./run4.sh warm fixF
x ./run4.sh ppucompare fixF
for r in 1 2 3; do x ./run4.sh ppu $r fixF none memo; x ./run4.sh sqlite $r fixF none memo; done
echo "queue22 done"
