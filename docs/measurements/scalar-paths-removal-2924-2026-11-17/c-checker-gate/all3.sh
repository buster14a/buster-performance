#!/bin/bash
# #2924 C12c, the third executable (knob3: flag values cross area boundaries raw, each receiver gates its own
# parameter): the checks, the closure, leave-one-out, then the gate, each step only if the one before passed.
set -uo pipefail
cd "$(dirname "$0")"
./checks.sh || { echo "checks failed" >> logs/all3-status.txt; exit 1; }
if grep -E 'objects .*: [0-9]+ compared, [1-9][0-9]* differ|objects .* (sqlite|lua|musl|buster): [1-9]' logs/status.txt; then echo "objects differ" >> logs/all3-status.txt; exit 1; fi
./closure5.sh
A=$(( (1<<29) - (1<<10) )); masks="$A"; for b in 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28; do masks="$masks $(( A & ~(1<<b) ))"; done
for l in sqlite lua musl; do ./bisect.sh $l loo $masks; done
./gate.sh
./gate2.sh
echo done >> logs/all3-status.txt
