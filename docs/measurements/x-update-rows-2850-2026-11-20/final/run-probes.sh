#!/bin/bash
# run-probes.sh COMPILER OUT: every one-statement program of the two pieces' probes through COMPILER (probe.py): the
# first piece's eight files' cases (earlier.txt), an update's (cases9), updates that are not evaluated (cases10), an
# address constant's cast converted to bool (cases11) and an update's value converted to bool (cases12). A line a case.
compiler=$1; out=$2
mkdir -p "$out" || exit 1
probe=/home/user/keep/xrows/probes/probe.py
: > "$out/earlier.txt"
for k in 1 2 3 4 5 6 7 8; do python3 $probe "$compiler" /home/user/keep/xrows/probes/cases$k.py > "$out/cases$k.txt" && cat "$out/cases$k.txt" >> "$out/earlier.txt"; done
python3 $probe "$compiler" /home/user/keep/xrows/probes/cases9.py > "$out/cases9.txt"
python3 $probe "$compiler" /home/user/keep/xupd/unevaluated/cases10.py > "$out/cases10.txt"
python3 $probe "$compiler" /home/user/keep/xupd/eight/cases11.py > "$out/cases11.txt"
python3 $probe "$compiler" /home/user/keep/xupd/eight/cases12.py > "$out/cases12.txt"
wc -l "$out"/earlier.txt "$out"/cases9.txt "$out"/cases10.txt "$out"/cases11.txt "$out"/cases12.txt
grep -L "xxxxxx" "$out"/*.txt > /dev/null
echo "lines that do not agree: $(cat "$out"/earlier.txt "$out"/cases9.txt "$out"/cases10.txt "$out"/cases11.txt "$out"/cases12.txt | grep -vc ' status 0 .*refused [0-9]* diff 0 .*entries [0-9]* diff 0 ')"
