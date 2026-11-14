#!/usr/bin/env bash
# moves.sh DIR...: from luacount.sh's TSVs (gap.c's rows, GAP_INSTRUCTIONS=1) of each DIR, luaV_execute's instructions,
# its register moves and those through r11, and the instructions of the program's own code; then the r11 moves left by
# address in each DIR.
for d in "$@"; do
  cat $d/{calls,tables,strings,arithmetic,closures}.tsv | awk -F'\t' -v d=$(basename $d) '$1=="#ins" && $2=="luaV_execute" { all+=$6; if ($5=="move") { mv+=$6; if ($7 ~ /%r11/) r11+=$6 } } $1=="#total" {tot+=$2} END { printf "%s: luaV_execute %.1f M, moves %.1f M, through r11 %.1f M; own code %.1f M\n", d, all/1e6, mv/1e6, r11/1e6, tot/1e6 }'
done
for d in "$@"; do
  echo "== $(basename $d): luaV_execute's moves through r11 above 0.01 M, by address"
  cat $d/{calls,tables,strings,arithmetic,closures}.tsv | awk -F'\t' '$1=="#ins" && $2=="luaV_execute" && $5=="move" && $7 ~ /%r11/ { c[$3" "$7]+=$6 } END { for (k in c) if (c[k] > 10000) printf "%8.2f M  %s\n", c[k]/1e6, k }' | sort -rn
done
