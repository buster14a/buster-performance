#!/bin/bash
# eval.sh UNIT OUT PRESPLIT [OPTIONS...]: the unit's parts as the Release build makes them (function sections), the
# join's unreferenced sections discarded, and the joined text against the whole unit's.
set -u
unit=$1; out=$2; presplit=$3; shift 3
T=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin
c=~/.cache/claude-2559
rm -rf "$out"; mkdir -p "$out/parts" "$out/fs"
"$presplit" "$c/bc/p/$unit.bc" 48 "$out/parts" "$@" 2> "$out/presplit.log" || { echo presplit failed; tail "$out/presplit.log"; exit 1; }
ls "$out"/parts/part*.bc | xargs -P 4 -I{} sh -c 'b=$(basename {} .bc); '"$T"'/clang -x ir -march=znver5 -ffunction-sections -fno-stack-protector -O3 -Wno-unused-command-line-argument -c {} -o '"$out"'/fs/$b.o'
objs=$(ls "$out"/fs/part*.o | sort -V)
BUSTER_UNREFERENCED_REPORT=1 /tmp/unreferenced "$out/dead.lines" $objs
{ echo "SECTIONS"; echo "{"; echo "    /DISCARD/ : {"; cat "$out/dead.lines"; echo "    }"; echo "}"; } > "$out/join.ld"
"$T"/ld.lld -r -O0 --threads=1 -T "$out/join.ld" $objs -o "$out/joined.o"
whole=$(size -A -d "$c/bc/p/$unit.whole/whole.o" | awk '$1 ~ /^\.text/ {s+=$2} END {print s}')
joined=$(size -A -d "$out/joined.o" | awk '$1 ~ /^\.text/ {s+=$2} END {print s}')
echo "$unit: whole $whole joined $joined excess $((joined - whole))"
