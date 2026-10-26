#!/bin/bash
# From st-build.sh's binaries in m/ (or the directory given): every object's and executable's sections (size -A,
# sections.txt), each one's .text, .rodata, .eh_frame and .eh_frame_hdr summed, and the dispatch of the two largest
# switches in the cc-linked builds, sqlite3VdbeExec's and yy_reduce's: their instructions, indirect jumps and compares
# of a register with an immediate (dispatch.txt).
set -u
cd ${1:-$HOME/buster-fast-bench/speedtest1-136-claude/m} || exit 1
out=$(dirname "$0")
[ "${out#/}" = "$out" ] && out=$OLDPWD/$out
binaries="ours-sqlite3.o clang-sqlite3.o tcc-sqlite3.o ours-speedtest1.o clang-speedtest1.o tcc-speedtest1.o st-ours st-direct st-clang st-tcc"
{
    for f in $binaries; do
        size -A $f | awk -v f=$f '$1 ~ /^\.text/ {t += $2} $1 ~ /^\.rodata/ || $1 == ".data.ro" {r += $2} $1 == ".eh_frame" {e += $2} $1 == ".eh_frame_hdr" {h += $2} END {printf "%-18s .text %8d  .rodata %6d  .eh_frame %7d  .eh_frame_hdr %6d\n", f, t, r, e, h}'
    done
    echo
    for f in $binaries; do
        size -A $f
    done
} > $out/sections.txt
{
    for c in ours clang; do
        for function in sqlite3VdbeExec yy_reduce; do
            objdump -d --no-show-raw-insn --disassemble=$function st-$c | awk -v c=$c -v f=$function '
                /^ +[0-9a-f]+:\t/ { n++ }
                /\tjmp +\*/ { indirect++ }
                /\tcmp +\$0x[0-9a-f]+,%[a-z0-9]+$/ { compares++ }
                END { printf "%-6s %-16s %6d instructions, %d indirect jumps, %d compares of a register with an immediate\n", c, f, n, indirect, compares }'
        done
    done
    echo
    echo "ours' sqlite3VdbeExec: its switch on the opcode, loaded into r14d, is a run of compares and branches:"
    objdump -d --no-show-raw-insn --disassemble=sqlite3VdbeExec st-ours | awk '
        /\tcmp +\$0x[0-9a-f]+,%r14d$/ { n++; if (n == 1) first = $1; last = $1 }
        END { printf "%d compares of r14d with an immediate, from %s to %s\n", n, first, last }'
    objdump -d --no-show-raw-insn --disassemble=sqlite3VdbeExec st-ours | grep -m1 -B3 -A7 'cmp *\$0x[0-9a-f]*,%r14d$'
    echo
    echo "clang -O0's sqlite3VdbeExec, the same switch: the opcode, a bounds check and a jump table:"
    objdump -d --no-show-raw-insn --disassemble=sqlite3VdbeExec st-clang | grep -m1 -B9 'jmp *\*'
} > $out/dispatch.txt
