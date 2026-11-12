#!/usr/bin/env bash
# Per build: gap count's #ins rows, then dynamic counts of rip-relative leas by symbol (from objdump's <symbol> comment),
# every rip-relative operand, non-frame leas, frame leas, and the whole program's counted instructions.
set -eu
cd "$(dirname "$0")"
for t in main head; do
    GAP_INSTRUCTIONS=1 ./gap count st-$t.dis cg-$t.out '???' 0x108000 > st-$t.tsv
    awk -F'\t' -v t=$t '
        /^#total/ { total = $2 }
        /^#check\tunmatched/ { unmatched = $3 }
        /^#ins/ {
            text = $7; count = $6
            if (text ~ /^lea/ && text ~ /\(%rip\)/) {
                sym = text; sub(/.*</, "", sym); sub(/[+>].*/, "", sym)
                bysym[sym] += count; riplea += count
            }
            if (text ~ /\(%rip\)/) { rip += count }
            if (text ~ /^lea/ && text !~ /\(%rip\)/ && text !~ /\(%rsp|\(%rbp/) { nonframe += count }
            if (text ~ /^lea/ && (text ~ /\(%rsp/ || text ~ /\(%rbp/)) { frame += count }
        }
        END {
            printf "%s total=%.1fM unmatched=%d rip_operands=%.2fM rip_leas=%.2fM other_nonframe_leas=%.2fM frame_leas=%.2fM\n", t, total/1e6, unmatched, rip/1e6, riplea/1e6, nonframe/1e6, frame/1e6
            for (s in bysym) printf "%s\t%s\t%d\n", t, s, bysym[s] > "leas-" t ".tsv"
        }' st-$t.tsv
done
for s in mem5 sqlite3Config sqlite3Stat g mem0; do
    printf '%s\t%s\t%s\n' $s "$(awk -F'\t' -v s=$s '$2 == s {print $3}' leas-main.tsv)" "$(awk -F'\t' -v s=$s '$2 == s {print $3}' leas-head.tsv)"
done
