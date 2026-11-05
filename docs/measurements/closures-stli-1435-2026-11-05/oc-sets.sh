#!/usr/bin/env bash
# oc-sets TSV EXE: the op cache misses of IBS fetch samples (fetch-rec's tsv) of EXE by fetch address: each sampled
# address with misses (count), its 64-byte line's bits 11:6 (an index within 4 KiB), and the misses by those bits.
set -u
T=$1; X=$2
nm $X | awk '{ print $3, $1 }' > /tmp/oc-sets-nm.$$
awk 'FNR == NR { a[$1] = $2; next }
$5 == 1 && $7 ~ /^lua-/ { s = $1; off = 0; if (match(s, /\+0x[0-9a-f]+$/)) { off = strtonum(substr(s, RSTART + 1)); s = substr(s, 1, RSTART - 1) }
  if (s in a) { addr = strtonum("0x" a[s]) + off; m[addr]++; set[int(addr / 64) % 64]++; nm[addr] = $1 } }
END {
  for (x in m) if (m[x] >= 15) printf "  %6x %-34s misses %4d line %6x bits11:6 %2d\n", x, nm[x], m[x], int(x / 64) * 64, int(x / 64) % 64 | "sort -k5,5nr | head -30"
  close("sort -k5,5nr | head -30")
  printf "misses by bits 11:6:"; for (i = 0; i < 64; i++) printf " %d:%d", i, set[i]; printf "\n"
}' /tmp/oc-sets-nm.$$ $T
rm -f /tmp/oc-sets-nm.$$
