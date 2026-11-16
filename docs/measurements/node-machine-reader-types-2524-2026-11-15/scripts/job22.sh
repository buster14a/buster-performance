#!/bin/bash
# job22.sh: job21's facts rounds 4 to 6 (m14 = main be6515fba, u3 = it with #2867's branch merged), for six runs a
# setting as the record's section 5 has.
set -u
cd "$(dirname "$0")"
log=results/job22.log
for n in 4 5 6; do
    for label in m14 u3; do
        RUN=$n ./facts.sh $label "" 1 --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-lean" 1 --facts-lean --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loads" 1 --facts-loads --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed" 1 --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-leanpacked" 1 --facts-lean --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-loadspacked" 1 --facts-loads --facts-packed --passes 5 --list 20 > /dev/null
        RUN=$n ./facts.sh $label "-packed4096" 1 --facts-packed --facts-window 4096 --passes 5 --list 20 > /dev/null
    done
    echo "facts round $n done $(date -u +%T)" >> $log
done
python3 facts-tables2.py results m14 u3 > results/facts-m14-u3-six.txt 2>&1
echo "job22 done $(date -u +%FT%TZ)" >> $log
