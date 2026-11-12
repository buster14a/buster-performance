#!/usr/bin/env bash
# acc.sh TSV...: the #1217 acceptance counts from gap's #ins rows: non-frame lea (gap's type "lea"), frame lea
# ("lea_stack"), imul by an immediate power of two, and the lea split by form (rip-relative, scaled index,
# base+disp), summed over the TSVs.
gawk -F'\t' '$1=="#ins" {
  t=$5; c=$6; x=$7
  if (t=="lea") { lea+=c; if (x ~ /\(%rip\)/) rip+=c; else if (x ~ /,[1248]\)/) sc+=c; else if (x ~ /\(%r[a-z0-9]+,%r/) bi+=c; else bd+=c }
  if (t=="lea_stack") fl+=c
  if (x ~ /^imul/ && match(x, /\$0x[0-9a-f]+,/)) { v=strtonum(substr(x, RSTART+1, RLENGTH-2)); if (v>0 && and(v, v-1)==0) ip2+=c }
}
END { printf "lea_nonframe %.1f M (rip %.1f, scaled %.1f, base+index %.1f, base+disp %.1f); lea_frame %.1f M; imul_pow2 %.1f M\n", lea/1e6, rip/1e6, sc/1e6, bi/1e6, bd/1e6, fl/1e6, ip2/1e6 }' "$@"
