#!/bin/bash
# Median over rounds of each item's ns, cycles and instructions per type, per tree, from DIR/<tree>.<round>.txt.
DIR=$1
for t in base merge head; do
  cat $DIR/$t.*.txt 2>/dev/null | awk -v t=$t '
    /^classify-all, |^batches, / { ctx=$0; sub(/:.*/,"",ctx); w=ctx; gsub(/[^0-9]/,"",w) }
    /^  [a-z]/ && /ns\/(type|argument|call)/ { key=$1"/"$2; if ($1=="classify-all") key=key"/"w; ns[key]=ns[key]" "$3; cy[key]=cy[key]" "$5; ins[key]=ins[key]" "$7; seen[key]=1 }
    END { for (k in seen) print t, k, ns[k], "|", cy[k], "|", ins[k] }'
done | sort -k2,2 -k1,1 | awk '
  function med(s,   a,n,i,j,x){ n=split(s,a," "); for(i=1;i<=n;i++)for(j=i+1;j<=n;j++)if(a[j]+0<a[i]+0){x=a[i];a[i]=a[j];a[j]=x} return n? a[int((n+1)/2)] : 0 }
  { split($0,p,"|"); split(p[1],h," "); t=h[1]; k=h[2]; s=""; for(i=3;i<=length(h);i++) s=s" "h[i]; printf "%-34s %-6s ns %8.2f  cycles %8.2f  instr %8.2f\n", k, t, med(s), med(p[2]), med(p[3]) }'
