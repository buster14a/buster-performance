#!/bin/bash
# run-probes-values.sh COMPILER OUT: the values' one-statement programs (probes/cases15 to cases20: a constant's, an
# address's, a member's and a stride's; a store's and an update's; a call's row; a branch's label; a temporary's number)
# through COMPILER, three files side by side; then the earlier pieces' (run-probes.sh), whose tapes are compared with
# their values too. A line a case; the lines that do not agree are counted.
compiler=$1; out=$2
mkdir -p "$out" || exit 1
probe=/home/user/keep/probes/probe.py
for k in 15 16 17 18 19 20; do
    python3 $probe "$compiler" /home/user/keep/probes/cases$k.py > "$out/cases$k.txt" &
    while [ "$(jobs -r | wc -l)" -ge 3 ]; do wait -n; done
done
wait
wc -l "$out"/cases1[5-9].txt "$out"/cases20.txt
agree=' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 .*values alone 0 listed [0-9]* numbered [0-9]*$'
echo "values' lines that do not agree: $(cat "$out"/cases1[5-9].txt "$out"/cases20.txt | grep -vc "$agree")"
echo "values' cases with a tape made: $(cat "$out"/cases1[5-9].txt "$out"/cases20.txt | grep -c 'taken [1-9]'); with an expression numbered: $(cat "$out"/cases1[5-9].txt "$out"/cases20.txt | grep -c 'numbered [1-9]'); with one listed: $(cat "$out"/cases1[5-9].txt "$out"/cases20.txt | grep -vc 'listed upd 0 br 0 conv 0 float 0')"
