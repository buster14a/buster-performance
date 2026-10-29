#!/bin/bash
# Reports of ibs.sh's recordings: each run's samples by symbol, and by source line in the two functions whose samples
# grew most (check_input_resolve_range and check_input_specifiers), for ibs-lines.py.
R=/home/david/.cache/claude-147/ibs840
for t in base head; do
    for r in 1 2 3 4; do
        perf report -i $R/ibs-$t-$r.data --no-children --stdio -q --sort symbol -F sample,symbol > $R/report-symbols-$t-$r.txt 2> /dev/null
        perf report -i $R/ibs-$t-$r.data --no-children --stdio -q --sort srcline -F sample,srcline \
            --symbols check_input_resolve_range,check_input_specifiers > $R/report-lines-$t-$r.txt 2> /dev/null
    done
done
