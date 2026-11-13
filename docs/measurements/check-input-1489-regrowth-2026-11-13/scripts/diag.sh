#!/bin/bash
# diag.sh NAME VARIANT...: each variant's diagnostics, vector and --scalar paths, with -Wall -Wextra (the unused
# declarations' warnings on): sqlite3.c (-fsyntax-only, the microarch workloads' options) and self-main.i
# (-fsyntax-only, SELF_OPTIONS). One lock grant per run, each with a 120 s timeout. Prints the hashes by input and mode.
set -u
name=$1; shift
W=~/buster-fast-bench/1489-claude
out=$W/diag/$name; mkdir -p $out
LOCK=(env EXCLUSIVE_OWNER=claude-1489 "EXCLUSIVE_TITLE=Solve 1489 (check-input growth)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 ~/buster-fast-bench/exclusive.sh)
cd $W/root || exit 2
SCRATCH=../scratch
source ./workloads.sh
ln -sfn ~/buster-fast-bench/1340-droid/root/self-main.i self-main.i
ln -sfn ~/buster-fast-bench/1340-droid/root/predefines-znver5.h predefines-znver5.h
for v in "$@"; do
    for mode in vector scalar; do
        extra=(); [ $mode = scalar ] && extra=(--scalar)
        bin=bin/compiler-$v
        cmd1="taskset -c 2 timeout -k 5 120 $bin $(printf '%q ' "${COMMON[@]}" "${SQLITE[@]}") -fsyntax-only -Wall -Wextra ${extra[*]} > /dev/null 2> $out/sq-$v-$mode.txt; echo \"sq $v $mode status=\$?\" >> $out/status.txt"
        cmd2="taskset -c 2 timeout -k 5 120 $bin $(printf '%q ' "${SELF_OPTIONS[@]}") -fsyntax-only -Wall -Wextra ${extra[*]} self-main.i > /dev/null 2> $out/self-$v-$mode.txt; echo \"self $v $mode status=\$?\" >> $out/status.txt"
        "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $out/holds.txt; $cmd1" 2>> $out/lock.log
        "${LOCK[@]}" bash -c "head -1 /var/lib/buster-9700x/owner >> $out/holds.txt; $cmd2" 2>> $out/lock.log
    done
done
cd $out && for f in sq-*.txt self-*.txt; do printf '%s\t%s\t%s\n' "$(sha256sum < $f | cut -c1-16)" "$(wc -l < $f)" "$f"; done | sort -k3 > hashes.tsv
echo done > done
