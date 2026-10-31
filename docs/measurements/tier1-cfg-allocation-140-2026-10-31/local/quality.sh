#!/usr/bin/env bash
# quality.sh TREE OUT: frame traffic of the frozen sqlite3.c's code, for #140's spill comparison. Tier 0's (TREE's -c
# object, with the 9700X job's options for the file) and clang's at -O0 and -O2 (the same options but the pinned
# predefines, which are clang's own): each object's instructions with a memory operand based on rsp or rbp (not lea,
# which computes an address), and clang's -S spill and reload annotations. Deterministic: no timing.
set -u
tree=$1
out=$2
corpus=${BUSTER_CORPUS:-$HOME/.cache/claude-174/corpus}
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
mkdir -p "$out"
options=(--target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
source="$corpus/sqlite/sqlite3.c"
frame()
{
    objdump -d --no-show-raw-insn "$1" | awk -F'\t' 'NF == 2 && $1 ~ /:$/ && $2 ~ /\((%rsp|%rbp)/ && $2 !~ /^lea/ { n += 1 } NF == 2 && $1 ~ /:$/ && $2 !~ /^[[:space:]]*$/ { all += 1 } END { printf "instructions=%d frame_memory=%d\n", all, n }'
}
"$tree/build/compiler" --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" "${options[@]}" -c -o "$out/sqlite3-tier0.o" "$source"
echo "tier0: $(frame "$out/sqlite3-tier0.o")"
# The frozen headers have no bits/stdio.h, which glibc includes for its extern inlines when optimizing: -D__NO_INLINE__
# keeps -O2's headers -O0's.
for level in O0 O2; do
    clang --no-default-config -"$level" -D__NO_INLINE__ "${options[@]}" -S -o "$out/sqlite3-$level.s" "$source"
    clang --no-default-config -"$level" -D__NO_INLINE__ "${options[@]}" -c -o "$out/sqlite3-$level.o" "$source"
    spills=$(grep -cE 'byte Spill$' "$out/sqlite3-$level.s")
    folded_spills=$(grep -cE 'byte Folded Spill$' "$out/sqlite3-$level.s")
    reloads=$(grep -cE 'byte Reload$' "$out/sqlite3-$level.s")
    folded_reloads=$(grep -cE 'byte Folded Reload$' "$out/sqlite3-$level.s")
    echo "clang-$level: $(frame "$out/sqlite3-$level.o") spills=$spills folded_spills=$folded_spills reloads=$reloads folded_reloads=$folded_reloads"
done
clang --version | head -1
