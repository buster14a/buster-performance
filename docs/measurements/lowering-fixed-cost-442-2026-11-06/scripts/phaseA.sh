#!/bin/bash
# #442 phase A on the 9700X: build fix1 and fix2 (current main with the patches), then one short hold: a quick pass of
# every tree over seven c-testsuite files, and perf's profiles of current main and fix2 on a 9-token unit.
cd ~/buster-fast-bench/442-claude-rebase
export EXCLUSIVE_OWNER=claude-442 EXCLUSIVE_TITLE="Solve 442" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/442
export LOCK=$HOME/buster-fast-bench/exclusive.sh
main=ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b
scripts/build-trees.sh buster.git trees fix1=$main:now:$PWD/patches/fix1.patch fix2=$main:now:$PWD/patches/fix2.patch
cat > phaseA-run.sh <<'INNER'
#!/bin/bash
cd ~/buster-fast-bench/442-claude-rebase
S=cts/tests/single-exec
F="$S/00001.c $S/00010.c $S/00050.c $S/00100.c $S/00150.c $S/00200.c $S/00210.c"
mkdir -p phaseA
for t in main418 pr418 now fix1 fix2; do
    taskset -c 2 trees/$t/build/compiler benchmark-emit-ab --passes 101 $F > phaseA/$t.txt 2>&1
done
many=$(for i in $(seq 100); do echo -n "$S/00001.c "; done)
for t in now fix2; do
    taskset -c 2 perf record -q -F 25000 -g -o phaseA/$t-00001.data trees/$t/build/compiler benchmark-emit-ab --passes 101 $many > phaseA/$t-perf.txt 2>&1
done
INNER
chmod +x phaseA-run.sh
$LOCK ./phaseA-run.sh
for t in now fix2; do
    perf report -i phaseA/$t-00001.data --no-children --stdio --sort symbol 2>/dev/null | grep "%" | grep -v "^#" | head -60 > phaseA/$t-00001.report
    perf report -i phaseA/$t-00001.data --children --stdio --sort symbol -g none 2>/dev/null | grep "%" | grep -v "^#" | head -80 > phaseA/$t-00001.children
done
echo phaseA-done > phaseA/done
