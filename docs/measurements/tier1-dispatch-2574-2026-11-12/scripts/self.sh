#!/usr/bin/env bash
# self.sh TSV...: non-frame leas by shape: "self" is lea disp(%rX),%rX (or its 32-bit destination), an add of a
# constant in place; "bi-self" is lea (%rX,%rY,1),%rX/%rY with no displacement; the rest by form.
gawk -F'\t' '$1=="#ins" && $5=="lea" {
  x=$7; sub(/ +#.*/, "", x); c=$6
  if (x ~ /\(%rip\)/) rip+=c
  else if (match(x, /^lea +(-?0x[0-9a-f]+)?\(%([a-z0-9]+)\),%([a-z0-9]+)$/, m)) {
    b=m[2]; d=m[3]; d32=d; sub(/d$/, "", d32); if (d32 ~ /^e/) { d32="r" substr(d32, 2) }
    if (b==d || b==d32) self+=c; else bd+=c
  }
  else if (x ~ /,[248]\),/) sc+=c
  else bi+=c
}
END { printf "self %.1f  base+disp %.1f  rip %.1f  scaled %.1f  base+index %.1f\n", self/1e6, bd/1e6, rip/1e6, sc/1e6, bi/1e6 }' "$@"
