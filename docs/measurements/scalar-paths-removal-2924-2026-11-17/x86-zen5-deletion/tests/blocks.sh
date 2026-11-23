#!/bin/sh
# blocks.sh TESTSFILE PATTERN... : print the correctness.tests blocks whose heading matches any regex, or whose body names one
f=$1; shift
awk -v pats="$*" 'BEGIN{n=split(pats,p," ")} 
/^== /{ if (keep) printf "%s", blk; blk=$0"\n"; keep=0; next }
{ if (blk!="") { blk=blk $0 "\n"; for(i=1;i<=n;i++) if ($0 ~ p[i]) keep=1 } }
END{ if (keep) printf "%s", blk }' "$f"
