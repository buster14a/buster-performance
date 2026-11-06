#!/bin/bash
# diag-none-main.sh: main's default-flag diagnostics on the corpus (diag/Nmain-s), compared with 9fa45bbb's (diag/Ngate-s).
set -u
D=/home/david/.cache/droid-1340
cd "$D" || exit 2
log=$D/diag-none-main.log
: > "$log"
rm -rf diag/Nmain-s
awk '$2=="diag/Ngate-s"' diag/jobs-none | sed 's|^bin/compiler-gate diag/Ngate-s|bin/compiler-main diag/Nmain-s|' > diag/jobs-none-main
wc -l diag/jobs-none-main >> "$log"
xargs -P "${CORES:-4}" -L1 ./diag-none.sh < diag/jobs-none-main
echo "runs done $?" >> "$log"
n=$(find diag/Nmain-s -type f | wc -l)
if diff -r diag/Nmain-s diag/Ngate-s > diag/diff-Nmain-s-Ngate-s.txt; then r=identical; else r=DIFFERENT; fi
echo "Nmain-s vs Ngate-s: $n files, $r" >> "$log"
echo all-done >> "$log"
