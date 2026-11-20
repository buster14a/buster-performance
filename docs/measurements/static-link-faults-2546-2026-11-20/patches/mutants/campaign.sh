#!/bin/sh
# campaign.sh: each mutant of the switch build (M2546=k) against its owning test; a line per mutant: killed or survived.
S=/tmp/claude-0/-home-user/95f322c7-a439-5fec-9eac-68c48a1474ca/scratchpad/s2546
C=$S/mutant-compiler
cd /home/user/wt-2546
for k in 0 $(seq 1 49); do
    if [ $k -le 10 ]; then t="test-lanes"; elif [ $k -le 43 ]; then t="test-link"; else t="test-bind"; fi
    if [ $k -eq 0 ]; then t="test-lanes test-link test-bind"; fi
    status=0
    for one in $t; do
        M2546=$k timeout 600 $C $one > $S/m-$k-$one.out 2>&1
        e=$?
        [ $e -ne 0 ] && status=$e
    done
    if [ $status -ne 0 ]; then verdict=killed; else verdict=survived; fi
    echo "mutant $k ($t): $verdict (exit $status) $(grep -h -E '^  ' $S/m-$k-*.out 2>/dev/null | grep -v -E 'exit helper|starved|unwinder|dynamic symbols|GOT slots|imports,' | head -1 | cut -c1-150)"
done > $S/campaign.log 2>&1
echo campaign-done >> $S/campaign.log
