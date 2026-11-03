#!/bin/bash
# classify.sh DIR: the 32-bit self-moves of DIR/all.s by position, and the report's totals.
awk '
/^\s+[0-9a-f]+:\s/ { n++; ins[n]=$2; ops[n]=$3 }
END {
  for (i=1;i<=n;i++) {
    if (ins[i]!="mov") continue; split(ops[i],a,","); if (a[1]!=a[2] || a[1] !~ /^%(e..|r[0-9]+d)$/) continue;
    j=i+1; while (j<=n && (ins[j]=="mov" || ins[j]=="xor") ) { split(ops[j],b,","); if (ins[j]=="xor" && b[1]=="%eax") {j++; continue} if (ins[j]=="mov" && b[1]==b[2]) {j++; continue} break }
    if (ins[j] ~ /^call/) { c["before_call"]++; continue }
    if (ins[i-1] ~ /^call/ && a[1]=="%eax") { c["after_call_eax"]++; continue }
    c["other"]++
  }
  for (k in c) print "  " k, c[k]
}' "$1/all.s"
grep "^tier1\s" "$1/report.txt" | awk -F'\t' '{for(i=1;i<=NF;i++){split($i,kv,"="); if(kv[1] ~ /^(compiled|unsupported|call_stores|call_loads|records|spill_stores|spill_loads|edge_moves|frame_bytes)$/ || kv[1] ~ /^selection\./) s[kv[1]]+=kv[2]}} END{for(k in s) printf "  %s=%d\n", k, s[k]}' | sort
grep -c "^FAIL" "$1/report.txt"
