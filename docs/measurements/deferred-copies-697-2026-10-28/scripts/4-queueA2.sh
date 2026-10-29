#!/bin/bash
# Campaign A4's queue from round 1's twelfth job: 4-queueA.sh ran the first eleven in one lock hold of five and a half
# minutes, more than the lock asks for (exclusive.sh: a run, not a series, so that a CI job gets the machine within
# minutes), and was stopped while it waited for the next; from here 4 jobs a hold, about 2 minutes, 30 s apart.
D=/home/david/buster-fast-bench/697-cloud
cd "$D" || exit 1
"$D/3-queue.sh" 4-jobsA.txt 4-logA.txt 1 11 3 4 30
echo "4-master done $(date -Is)" >> "$D/chain.out"
