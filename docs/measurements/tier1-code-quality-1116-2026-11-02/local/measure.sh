#!/bin/bash
# measure.sh COMPILER OUTDIR [extra flags...]: Lua 5.4.8's sources by --tier1 -c, and the issue's counts.
set -u
compiler=$1; out=$2; shift 2
src=/home/david/buster-lab/inputs/lua-5.4.8/src
mkdir -p "$out"
flags=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX)
: > "$out/report.txt"
for f in "$src"/*.c; do
    b=$(basename "$f" .c)
    "$compiler" --tier1 --tier1-report --tier1-refusals "$@" "${flags[@]}" -c "$f" -o "$out/$b.o" >> "$out/report.txt" 2>&1 || echo "FAIL $b" >> "$out/report.txt"
done
text=0
for o in "$out"/*.o; do t=$(size -A "$o" | awk '$1==".text"{print $2}'); text=$((text + ${t:-0})); done
objdump -d --no-show-raw-insn "$out"/*.o > "$out/all.s"
insns=$(grep -cE '^\s+[0-9a-f]+:\s' "$out/all.s")
self=$(grep -cE 'mov\s+%(e[a-z]{2}|r[0-9]+d),%\1$' "$out/all.s" | head -1)
self=$(grep -E '^\s+[0-9a-f]+:\s+mov\s+%' "$out/all.s" | awk '{split($3,a,","); if (a[1]==a[2] && a[1] ~ /^%(e..|r[0-9]+d)$/) n++} END{print n+0}')
# A reload of a slot followed at once by a store of the same register to the same slot.
pairs=$(awk '/^\s+[0-9a-f]+:\s/ { ins=$2; ops=$3; if (ins=="mov" && prev_ins=="mov") { split(prev_ops,p,","); split(ops,q,","); if (p[1] ~ /\(%rsp\)|\(%rbp\)/ && p[2]==q[1] && q[2]==p[1]) n++ } prev_ins=ins; prev_ops=ops } END{print n+0}' "$out/all.s")
echo "text=$text instructions=$insns self_moves32=$self reload_store_pairs=$pairs"
