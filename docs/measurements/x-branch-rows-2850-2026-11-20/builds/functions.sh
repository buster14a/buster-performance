#!/bin/bash
# functions.sh LABEL...: on the 9700X, the sizes in bytes of the rows' lists' and loops' functions in each label's
# Release executable (results/LABEL/compiler): a line "LABEL FUNCTION BYTES" each.
cd ~/buster-fast-bench/2850-tests-claude || exit 1
for label in "$@"; do
    nm -S results/$label/compiler | awk -v l=$label '$4 ~ /^node_rows_window_(updates|branches|write|shapes|reads|part)$/ { printf "%s %s %d\n", l, $4, strtonum("0x" $2) }'
done
