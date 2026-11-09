#!/usr/bin/env bash
# show.sh OUT FUNC FROM TO: disassembly of [FROM, TO) with each instruction's count and kind from FUNC.agg.
S=~/.cache/droid-1216/S; O=$S/b/$1; F=$2; A=$3; Z=$4
dis=$O/lua.dis; [ $F = sqlite3VdbeExec ] && dis=$O/st.dis
awk -F'\t' -v a=$((16#$A)) -v z=$((16#$Z)) '
  FNR==NR { c[$1]=$3; k[$1]=$2; next }
  /^ *[0-9a-f]+:/ { split($0, p, ":"); addr=p[1]; gsub(/ /,"",addr); n=strtonum("0x" addr); if (n>=a && n<z) { t=$0; sub(/^ *[0-9a-f]+:[ \t]*/,"",t); printf "%6s %-2s %10s  %s\n", addr, k[addr], c[addr], t } }
' $O/$F.agg $dis
