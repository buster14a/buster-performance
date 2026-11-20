#!/bin/bash
# run-probes.sh COMPILER OUT: every one-statement program of the rows' pieces' probes through COMPILER (probes/probe.py,
# which asks too that no chunk's second run differ from its first): the first piece's eight files' cases (earlier.txt),
# an update's (cases9), updates that are not evaluated (cases10), an address constant's cast converted to bool
# (cases11), an update's value converted to bool (cases12), conditions (cases13) and tested values that might have a
# conversion of their own (cases14). A line a case.
compiler=$1; out=$2
mkdir -p "$out" || exit 1
probe=/home/user/keep/probes/probe.py
: > "$out/earlier.txt"
for k in 1 2 3 4 5 6 7 8; do python3 $probe "$compiler" /home/user/keep/probes/cases$k.py > "$out/cases$k.txt" && cat "$out/cases$k.txt" >> "$out/earlier.txt"; done
for k in 9 10 11 12 13 14; do python3 $probe "$compiler" /home/user/keep/probes/cases$k.py > "$out/cases$k.txt"; done
wc -l "$out"/earlier.txt "$out"/cases9.txt "$out"/cases1[0-4].txt
echo "lines that do not agree: $(cat "$out"/earlier.txt "$out"/cases9.txt "$out"/cases1[0-4].txt | grep -vc ' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 ')"
