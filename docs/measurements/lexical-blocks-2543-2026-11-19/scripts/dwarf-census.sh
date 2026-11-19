#!/bin/bash
# Compiles the frozen sqlite3.c with -c -g by the compiler $1 into $2 and prints the object's DWARF census.
set -u
compiler=$1; object=$2
corpus=/tmp/claude-0/-home-user/87d3bdec-e45c-5b9b-a70c-89accd56561f/scratchpad/corpus
flags=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
"$compiler" -w -c -g "${flags[@]}" "$corpus/sqlite/sqlite3.c" -o "$object" || { echo "compile failed"; exit 1; }
dump=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/llvm-dwarfdump
printf 'object bytes: %s\n' "$(stat -c %s "$object")"
printf 'lexical blocks: %s\n' "$($dump --debug-info "$object" | grep -c DW_TAG_lexical_block)"
printf 'variables: %s, formal parameters: %s, inlined: %s\n' "$($dump --debug-info "$object" | grep -c DW_TAG_variable)" "$($dump --debug-info "$object" | grep -c DW_TAG_formal_parameter)" "$($dump --debug-info "$object" | grep -c DW_TAG_inlined_subroutine)"
python3 -I -c 'import sys,subprocess; out=subprocess.run(["readelf","-SW",sys.argv[1]],capture_output=True,text=True).stdout
for l in out.splitlines():
    p=l.replace("[ ","[").split()
    if len(p)>6 and p[1] in (".debug_rnglists",".debug_info",".debug_loclists",".rela.debug_info"): print(p[1]+": "+str(int(p[5],16))+" bytes")' "$object"
printf 'relocations of .debug_info: %s\n' "$(readelf -rW "$object" | awk '/Relocation section .\.rela\.debug_info/ {print $(NF-1)}')"
printf 'verify: %s\n' "$($dump --verify "$object" 2>&1 | tail -1)"
printf 'no-children warnings: %s\n' "$($dump --verify "$object" 2>&1 | grep -c 'DW_CHILDREN_yes but DIE has no children')"
