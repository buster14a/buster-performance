#!/bin/bash
# periods.sh DATA...: each perf data file's user cycles by symbol (the period, in thousands per process of 1,000), the
# foreign-strings and hashing symbols only (#3261).
for d in "$@"; do
    echo "=== $(basename $d .data)"
    perf report -i $d --no-children --sort sym -F period,sym --stdio 2> /dev/null | grep -v '^#' | grep -i 'foreign_strings\|link_hash\|memset\|memmove\|memcmp' | awk '{printf "%10.1f k  %s\n", $1 / 1000 / 1000, $NF}' | head -16
done
