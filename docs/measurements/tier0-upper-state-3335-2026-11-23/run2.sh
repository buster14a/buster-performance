#!/bin/bash
# #3335's kernel on the 9700X, base against mine: saxpy (Tier 0, -march=znver5) alone ("clean"), after the issue's sum16
# ("dirty", which narrows its registers to xmm before returning), and after add16 ("wide", which returns with zmm0 and
# zmm1 wide). Default -ffp-contract and off (whose base saxpy has legacy mulss/addss).
D=/tmp/3335-claude
cd $D
export EXCLUSIVE_OWNER=claude-3335 EXCLUSIVE_TITLE="buster #3335 Tier 0 vzeroupper" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3335
snap() { echo "== $1 $(date -u +%FT%TZ) loadavg $(cat /proc/loadavg)"; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; }
export -f snap
for t in base mine; do
  for contract in on off; do
    ./$t/build/compiler -c -march=znver5 -ffp-contract=$contract -o results/k-$t-$contract.o kernel.c
    ./$t/build/compiler -S -march=znver5 -ffp-contract=$contract -o results/k-$t-$contract.s kernel.c
    clang -O2 -march=znver5 -o results/run-$t-$contract driver.c results/k-$t-$contract.o
  done
done
~/buster-fast-bench/exclusive.sh bash -c 'snap before; for i in 1 2 3; do for contract in on off; do for t in base mine; do for m in clean dirty wide; do echo -n "$t contract=$contract round $i: "; taskset -c 2 timeout -k 5 60 ./results/run-$t-$contract $m 1024; done; done; done; done; snap after' > results/kernel.log 2>&1
echo RUN2 DONE
