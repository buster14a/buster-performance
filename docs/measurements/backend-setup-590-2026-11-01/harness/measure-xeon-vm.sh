#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# The Xeon VM's measurements: base 91cfe9e0 and head 8da9e479, both linked by wild 0.10.0 (BUSTER_LINKER), THP madvise.
set -u
S=/tmp/claude-0/-home-user-buster/ed7d29a3-21c9-57db-96e0-ab46d57093ad/scratchpad
out=$S/record/xeon-vm
cd $S
{
    date -u; uname -a
    echo "THP enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled), defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
    grep -m1 "model name" /proc/cpuinfo; nproc
    sha256sum /usr/bin/tcc compiler.base.wild compiler.wild3 hello.c; tcc -v; clang --version | head -1
    size compiler.base.wild compiler.wild3
} > $out/host.txt 2>&1
for round in 1 2; do
    if [ $round = 1 ]; then order="compiler.base.wild compiler.wild3"; else order="compiler.wild3 compiler.base.wild"; fi
    for cond in madvise disabled; do
        wrap=""; [ $cond = disabled ] && wrap=$S/nothp
        for b in $order; do
            $wrap $S/$b measure-compile --runs 31 --reference /usr/bin/tcc -- -c hello.c > $out/hello-$cond-$b-$round.txt 2>&1
        done
    done
done
cd /home/user/buster
sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt > $out/subset.list
$S/tm $S/objs/tm.o 3 $S/compiler.base.wild $S/compiler.wild3 /usr/bin/tcc < $out/subset.list > $out/c-testsuite-madvise.txt 2>&1
$S/nothp $S/tm $S/objs/tm.o 3 $S/compiler.base.wild $S/compiler.wild3 /usr/bin/tcc < $out/subset.list > $out/c-testsuite-disabled.txt 2>&1
echo done > $out/DONE
