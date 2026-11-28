#!/bin/bash
# symbols-vs-full.sh COMPILER LIST: each "tag|file" of LIST compiled by default and with --no-direct, with its corpus
# flags (run.sh's); their named symbols (name, type, binding, visibility, defined or not) compared. Prints the units
# whose tables differ.
bin=$1; list=$2
C=/tmp/claude-0/corpus; M=$C/libc/musl
mflags=(-nostdinc -ffreestanding -D_XOPEN_SOURCE=700 -I "$M/arch/x86_64" -I "$M/arch/generic" -I "$C/musl-generated/obj/src/internal" -I "$M/src/include" -I "$M/src/internal" -I "$C/musl-generated/obj/include" -I "$M/include")
syms() { readelf -sW "$1" | awk 'NR>3 && $8 != "" && $5 != "LOCAL" && $8 !~ /^\.L/ {print $8, $5, $6, ($7=="UND" ? "UND" : "DEF " $4)}' | sort; }
bad=0; n=0
while IFS='|' read -r tag f; do
    case $tag in musl) fl=(-std=c99 "${mflags[@]}");; musl-gnu99) fl=(-std=gnu99 "${mflags[@]}");; *) fl=();; esac
    "$bin" "${fl[@]}" -c "$f" -o /tmp/claude-0/eqtmp/d.o 2> /dev/null
    "$bin" --no-direct "${fl[@]}" -c "$f" -o /tmp/claude-0/eqtmp/n.o 2> /dev/null
    readelf -p .comment /tmp/claude-0/eqtmp/d.o | grep -q 'buster direct' || echo "NOT DIRECT: $tag $f"
    if ! diff <(syms /tmp/claude-0/eqtmp/d.o) <(syms /tmp/claude-0/eqtmp/n.o) > /tmp/claude-0/eqtmp/sym.diff; then bad=$((bad + 1)); echo "DIFFERENT: $tag $f"; head -6 /tmp/claude-0/eqtmp/sym.diff; fi
    n=$((n + 1))
done < "$list"
echo "units $n, symbol tables different $bad"
