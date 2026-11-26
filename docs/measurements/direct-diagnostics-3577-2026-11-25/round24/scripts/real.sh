#!/bin/bash
# real.sh COMPILER TAG: the direct path's rate on real code (c-testsuite, musl without -ffreestanding), with the
# differential and the bail census.
S=/tmp/claude-0/-home-user/cf3643bc-6e1c-51b2-99ca-175eb97147e4/scratchpad
P=$1; T=$2
C=/home/user/corpus; musl=$C/libc/musl
export LLVM_PROFILE_FILE=/dev/null
rm -f $S/real-$T-bails.txt
export BUSTER_TEST_DIRECT_BAILS=$S/real-$T-bails.txt
ls /home/user/c-testsuite/tests/single-exec/*.c | EXTRA="" xargs -P 4 -n 1 $S/diff/onex.sh "$P" > $S/real-$T-cts.tsv
ls "$musl"/src/*/*.c "$musl"/src/*/x86_64/*.c | EXTRA="-std=gnu99 -nostdinc -D_XOPEN_SOURCE=700 -I $musl/arch/x86_64 -I $musl/arch/generic -I $C/musl-generated/obj/src/internal -I $musl/src/include -I $musl/src/internal -I $C/musl-generated/obj/include -I $musl/include" xargs -P 4 -n 1 $S/diff/onex.sh "$P" > $S/real-$T-musl.tsv
for set in cts musl; do awk -F'\t' -v s=$set '{c[$1]++; if ($4=="differs"||$4=="direct-only") d++; n++} END {printf "%s: %d files, %d SAME %d DIFF, %d direct-taken\n", s, n, c["SAME"], c["DIFF"], d}' $S/real-$T-$set.tsv; done
