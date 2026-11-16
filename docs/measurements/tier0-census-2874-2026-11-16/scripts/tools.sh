#!/bin/bash
# tools.sh: builds the record's two reducers (tools/brips.c, tools/parts.c) with the host's clang, and lists the
# compiler's transparent functions for brips: libc's memory and string functions, whose samples go to their callers.
# usage: tools.sh LABEL
cd "$(dirname "$0")"
label=$1
mkdir -p build
clang -O2 -Wall -Wextra -o build/brips tools/brips.c || exit 1
clang -O2 -Wall -Wextra -o build/parts tools/parts.c || exit 1
# START END NAME. An ifunc's stub has no size in the symbol table: its 16 bytes. The names are libc's memory and string
# primitives and their variants (__memset_avx512_unaligned_erms, memcmp_ifunc), not every name that starts as they do
# (the compiler's own stream_write, string_space; strtod, strdup, which do work of their own).
nm -S -n "results/$label/compiler" | awk '
    BEGIN { names = "^(__)?(mem(set|cpy|move|pcpy|cmp|cmpeq|chr|rchr|mem)|wmem(set|cpy|move|pcpy|chr|cmp)|rawmemchr|bzero|bcopy|bcmp|str(len|nlen|cmp|ncmp|chr|rchr|chrnul|cpy|ncpy|cat|ncat|str|spn|cspn|pbrk|casecmp|ncasecmp)|stp(cpy|ncpy))(_[a-z0-9_]+)?$" }
    NF == 4 && $4 ~ names { printf "%s %x %s\n", $1, strtonum("0x" $1) + strtonum("0x" $2), $4 }
    NF == 3 && $3 ~ names { printf "%s %x %s\n", $1, strtonum("0x" $1) + 16, $3 }
' > "results/$label/transparent.txt"
wc -l < "results/$label/transparent.txt"
