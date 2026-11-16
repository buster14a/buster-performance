#!/bin/bash
# job24.sh: is the loads' kernel's spread on sqlite3.c with the windows packed (u3: 11.1 to 13.2 cycles over six runs,
# m14: 10.9 to 11.1) a matter of where a run's memory falls? m14 and u3 in turn, twelve runs each as before
# (address-space randomization on) and twelve with it off (setarch -R), the facts.sh settings.
set -u
cd "$(dirname "$0")"
log=results/job24.log
for n in $(seq 1 12); do
    for label in m14 u3; do
        ./facts-one.sh $label aslr $n $n env --facts-loads --facts-packed --passes 5 --list 20
        ./facts-one.sh $label fixed $n $n "setarch x86_64 -R" --facts-loads --facts-packed --passes 5 --list 20
    done
done
for l in m14 u3; do for t in aslr fixed; do printf "%-4s %-6s " $l $t; for n in $(seq 1 12); do grep -o "the kernel a taken leaf or lookup: cycles=[0-9.]*" results/$l/one-$t-$n.txt | grep -o "[0-9.]*$" | tr "\n" " "; done; echo; done; done > results/facts-one-m14-u3.txt
echo "job24 done $(date -u +%FT%TZ)" >> $log
