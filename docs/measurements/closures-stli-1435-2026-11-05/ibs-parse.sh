#!/usr/bin/env bash
# ibs-parse DATA OUT: one line per IBS op sample of DATA (perf record -e ibs_op//u -R -d): symbol+offset, kind (L load,
# S store, O other), tag-to-completion cycles (TagToRetCtr - CompToRetCtr), DcMiss, width, data address, dso.
# perf report -D's decoded IBS fields joined to perf script's symbols by sample order; each sample's ip must agree.
set -u
D=$1; O=$2
perf report -i $D -D 2>/dev/null | awk '
/^ibs_op_data:/ { comp = 0; tag = 0; for (i = 1; i <= NF; i++) { if ($i == "CompToRetCtr") comp = $(i+1); if ($i == "TagToRetCtr") tag = $(i+1) } }
/^ibs_op_data3:/ { ld = 0; st = 0; miss = 0; width = 0; for (i = 1; i <= NF; i++) { if ($i == "LdOp") ld = $(i+1); if ($i == "StOp") st = $(i+1); if ($i == "DcMiss") miss = $(i+1); if ($i == "OpMemWidth") width = $(i+1) } lin = "0" }
/^IbsDCLinAd:/ { lin = $2 }
/PERF_RECORD_SAMPLE/ { for (i = 1; i <= NF; i++) if ($i ~ /^0x/ && $(i+1) == "period:") ip = $i; have = 1 }
/^ \.\.\.\.\.\. dso:/ && have { kind = ld == 1 ? "L" : (st == 1 ? "S" : "O"); print ip, kind, tag - comp, miss, width, lin; have = 0 }
' > $O.ibs
perf script -i $D -F ip,sym,symoff,dso 2>/dev/null | awk '{ ip = "0x" $1; s = $2; d = $NF; gsub(/[()]/, "", d); n = split(d, p, "/"); print ip, s, p[n] }' > $O.sym
paste -d' ' $O.ibs $O.sym | awk '{ if ($1 != $7) { bad++ } else print $8, $2, $3, $4, $5, $6, $9 } END { if (bad) print "MISMATCH", bad > "/dev/stderr" }' > $O.tsv
wc -l $O.ibs $O.sym $O.tsv
rm -f $O.ibs $O.sym
