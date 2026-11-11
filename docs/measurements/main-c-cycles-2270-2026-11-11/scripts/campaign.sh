#!/usr/bin/env bash
# #2270's campaign: the lock per batch of a few rounds (each hold well under a minute), never around the series.
set -u
. "$HOME/buster-fast-bench/2270-claude/env.sh"
cd $W
B=base=$W/base/build/compiler; H=head=$W/head/build/compiler
rm -f c1-pstat.tsv shift1.tsv; rm -rf c1-stages c1-record
for rs in "1 2 3" "4 5 6" "7 8 9"; do $L bash -c "for r in $rs; do ./pstat.sh c1-pstat.tsv \$r $B $H; done"; done; echo pstat done
for rs in "1 2" "3 4" "5 6"; do $L bash -c "for r in $rs; do ./shiftrun.sh shift1.tsv \$r 0 1 2 3 4 5 6 7; done"; done; echo shift done
for rs in "1 2 3 4 5 6" "7 8 9 10 11 12"; do $L bash -c "for r in $rs; do ./stages.sh c1-stages \$r $B $H; done"; done; echo stages done
$L bash -c "for r in 1 2 3; do ./record.sh c1-record \$r $B $H; done"
for f in c1-record/*.data; do perf report -i $f --no-children --sort sym -q --percent-limit 0 -F overhead,period,sym 2>/dev/null > ${f%.data}.txt; done; echo record done
until grep -q ^done build-o.out; do sleep 30; done
blds=(); for t in base head; do for n in 0 16 32 48 1040 2080 3120 4032; do blds+=(--build $t $W/offsets/$t/compiler-$n); done; done
src=$W/head/src
./head/build/compiler ab --rounds 3 --cpu 2 --lock "$L" ./head/build/compiler -- time-runs --runs 2 --copies 2 "${blds[@]}" --list -c -march=native -I"$src" -fwrapv -funsigned-char "$src/buster/compiler/main.c" -o /dev/null > ab-offsets.log 2>&1 || echo "ab failed"
echo campaign done
