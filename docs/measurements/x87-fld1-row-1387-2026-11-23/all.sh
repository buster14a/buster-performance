#!/bin/sh
D=/tmp/c1341/w; cd $D
export EXCLUSIVE_OWNER=claude-1341-1379-1387 EXCLUSIVE_TITLE="9700X acceptance: #1341 #1379 #1387" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngFHzyrnWayfMuSLbk
L=~/buster-fast-bench/exclusive.sh
sh build2.sh fld1:4704727a179ef530eb9a7b61a4276c8b06508166 main:4704727a179ef530eb9a7b61a4276c8b06508166
echo "== fld1 measure $(date -u +%T)"
$L sh -c 'cat /proc/loadavg; taskset -c 2 ./bin/fld1 measure-x86-zen5 --missing --table > zen5-missing-table.txt 2> zen5-missing.err; echo status $?; taskset -c 2 ./bin/fld1 measure-x86-zen5 --only FLD1/REGISTER; taskset -c 2 ./bin/fld1 measure-x86-zen5 --only FLDZ/REGISTER; cat /proc/loadavg' > zen5.out 2>&1
grep -n "FLD1\|FLDZ" zen5-missing-table.txt >> zen5.out
sh build2.sh b2669:437ccbbc3b578d724d86139cc3ffa09e61fef390 m2669:ad415ef919840739808291139dce8c4418dbd299
echo "== 1341 $(date -u +%T)"
$L sh s1341/prepare.sh > s1341/prepare.out 2>&1
for r in 0 1 2 3 4 5; do $L sh s1341/time.sh $r > s1341/round-$r.out 2>&1; done
sh build2.sh b2665:8023523211d8dafa780e9aefd74f719ffd222a5a m2665:27ff32f2702eba5015f55de93b3734c3199ceca3
echo "== 1379 $(date -u +%T)"
for b in b2665 m2665 main; do $L sh s1379/profile.sh $b > s1379/profile-$b.out 2>&1; done
sh s1379/report.sh
sh build2.sh b3134:ebafc8040f14adab80476c618737b1208cc57f72 b3140:db0dd7e75180c249b58a420370f4bf9e2b009ab0 m3140:a95b52c72a65e37773807526bd1bc1841f710e62
echo "== 1387 $(date -u +%T)"
$L sh x87/build.sh > x87/build.out 2>&1
for r in 0 1 2 3 4 5 6 7 8 9; do $L sh x87/time.sh $r > x87/round-$r.out 2>&1; done
echo "ALL DONE $(date -u +%T)"
