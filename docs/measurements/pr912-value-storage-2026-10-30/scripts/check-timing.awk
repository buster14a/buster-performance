# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# Gate one time.sh log: complete unique measured grid, successful statuses,
# finite positive wall times, and no internal timing-tool failure.
/^run / {
    rows++;
    valid = $1 == "run" && $3 == "list" && ($5 == "base" || $5 == "candidate") && $6 == "placement" && $8 == "copy";
    copy=$9; sub(/:$/, "", copy);
    valid = valid && $2 ~ /^[0-9]+$/ && $4 ~ /^[0-9]+$/ && $7 ~ /^[0-9]+$/ && copy ~ /^[0-9]+$/;
    valid = valid && $2 >= 1 && $2 <= 11 && $4 >= 1 && $4 <= 2 && $7 >= 1 && $7 <= 3 && copy >= 1 && copy <= 2;
    valid = valid && $10 ~ /^[0-9]+\.[0-9]+$/ && $10 > 0 && $10 <= 600000 && $(NF-1) == "status" && $NF == "0";
    key=$2 SUBSEP $4 SUBSEP $5 SUBSEP $7 SUBSEP copy;
    if (!valid || key in seen) { bad++; }
    seen[key]=1;
}
/^time-runs: done, 0 failed processes$/ { complete++; }
END {
    if (rows != 264 || bad != 0 || complete != 1) {
        printf "FAIL measured_rows=%d bad_rows=%d complete_lines=%d\n", rows, bad, complete;
        exit 1;
    }
    print "PASS 264 unique successful measured slots, complete 11x2x2x3x2 grid";
}
