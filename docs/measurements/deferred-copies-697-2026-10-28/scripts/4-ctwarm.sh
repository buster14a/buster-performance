#!/bin/bash
# CT4's check of its small programs' two readings of the same work: six of the programs under 100 tokens whose readings
# on one lane and by the rule (one lane too) differed most by final4, by final4 and main3 on --lanes 8, cold (as CT4
# ran them) and --warm (the state kept from one reading to the next), two rounds, one lock hold (4-logCTwarm.txt).
D=~/buster-fast-bench/697-cloud
L="$D/4-logCTwarm.txt"
for round in 1 2; do
    for program in 00012 00062 00155 00028 00102 00101; do
        file="$D/c-testsuite/tests/single-exec/$program.c"
        if [ $((round % 2)) = 1 ]; then
            "$D/3-runs.sh" "$L" "$round" "$program" "$file" 24 final4:8 final4:8:warm main3:8 main3:8:warm
        else
            "$D/3-runs.sh" "$L" "$round" "$program" "$file" 24 main3:8:warm main3:8 final4:8:warm final4:8
        fi
    done
done
echo done >> "$L"
