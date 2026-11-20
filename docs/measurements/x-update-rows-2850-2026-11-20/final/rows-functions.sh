#!/bin/bash
# rows-functions.sh COMPILER: the instructions of the rows' functions (node_rows_*) in COMPILER, without their
# addresses and their targets' (a call's, a jump's and a RIP-relative operand's symbol), to compare two builds' code:
#   diff <(grep -v '^$' A.s | sed -E 's/-?0x[0-9a-f]+\(%rip\)/X(%rip)/g') <(grep -v '^$' B.s | sed -E 's/-?0x[0-9a-f]+\(%rip\)/X(%rip)/g')
objdump -d --no-show-raw-insn "$1" | awk '/^[0-9a-f]+ <node_rows_[^>]*>:$/ {p=1} /^$/ {p=0} p' | sed -E 's/^[0-9a-f]+ <[^>]*>:$/:/; s/^ *[0-9a-f]+:\t//; s/[0-9a-f]+ <[^>]*>//g'
