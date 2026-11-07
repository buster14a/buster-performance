#!/bin/bash
# survey.sh: shape.sh on every C file of the frozen musl's src (1,524), c-testsuite's 220 single-exec programs, the 38
# synthetic units and the frozen sqlite3.c, eight at a time, in one lock hold; tables/survey.tsv, sorted by unit.
D=~/buster-fast-bench/447-claude
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export EXCLUSIVE_OWNER=claude-447 EXCLUSIVE_TITLE="#447 residual gap: which units the driver reads apart" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/447
mkdir -p "$D/gap"
{
    (cd "$C/libc/musl/src" && find . -name '*.c' | sed 's|^\./|musl/|')
    (cd "$D/c-testsuite/tests/single-exec" && ls *.c | sed 's|^|cts/|')
    (cd "$D/synthetic" && ls *.c | grep -v '^gen2\.c$' | sed 's|^|syn/|')
    echo sqlite
} | LC_ALL=C sort > "$D/gap/units.txt"
begin=$(date -Is)
~/buster-fast-bench/exclusive.sh sh -c "xargs -P8 -n1 '$D/scripts/shape.sh' < '$D/gap/units.txt' > '$D/gap/survey.raw'"
echo "$begin $(date -Is) status=$? units=$(wc -l < "$D/gap/units.txt")" >> "$D/gap/survey.queue"
LC_ALL=C sort "$D/gap/survey.raw" > "$D/gap/survey.tsv"
