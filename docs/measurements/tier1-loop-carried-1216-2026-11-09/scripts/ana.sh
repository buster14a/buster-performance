#!/usr/bin/env bash
# ana.sh OUT FUNC [N]: per-instruction counts of FUNC (Lua scripts summed, or st), top T/U/e by text and the hottest addresses.
S=~/.cache/droid-1216/S; O=$S/b/$1; F=$2; N=${3:-40}
cd $O
for r in st calls tables strings arithmetic closures; do if [ $r = st ]; then p=$O/st-t1; dis=st.dis; k=st.kinds; else p=$O/lua-t1; dis=lua.dis; k=lua.kinds; fi; [ -s cg/$r.ins ] || GAP_INSTRUCTIONS=1 $S/tools/gap count $dis cg/$r.cg $p 0x0 $k | grep '^#ins' > cg/$r.ins; done
if [ $F = sqlite3VdbeExec ]; then files="cg/st.ins"; else files="cg/calls.ins cg/tables.ins cg/strings.ins cg/arithmetic.ins cg/closures.ins"; fi
cat $files | awk -F'\t' -v f=$F '$2==f { s[$3]+=$6; k[$3]=$4; t[$3]=$7 } END { for (a in s) print a"\t"k[a]"\t"s[a]"\t"t[a] }' | sort > $O/$F.agg
echo "== by text"; awk -F'\t' '($2=="T"||$2=="U"||$2=="e") { t=$4; gsub(/ +/," ",t); s[$2" "t]+=$3; tot[$2]+=$3 } END { for (k in s) print s[k]"\t"k; for (k in tot) print tot[k]"\tTOTAL "k }' $O/$F.agg | sort -rn | head -$N
