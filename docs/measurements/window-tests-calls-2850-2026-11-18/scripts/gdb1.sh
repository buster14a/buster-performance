#!/bin/bash
# gdb1.sh LABEL...: where the front's struct is when node_front_chunk_window first runs on sqlite3.c, and the four
# switch tables' addresses, in each build.
cd "$(dirname "$0")"
. ./corpora.sh
for label in "$@"; do
    out=$PWD/results/$label
    echo "== $label"
    ./lock.sh bash -c "gdb -q -batch -ex 'break node_front_chunk_window' -ex 'run measure-node-machine --shadow --passes 0 --front-window $sqlite_arguments > /dev/null 2>&1' -ex 'printf \"front %#lx mod4096 %#lx\\n\", \$rdi, \$rdi & 0xfff' -ex 'printf \"rsp %#lx\\n\", \$rsp' -ex 'continue' -ex 'printf \"front again %#lx\\n\", \$rdi' $out/compiler 2>&1 | grep -a 'front\|rsp' | head -4"
    objdump -d --no-show-raw-insn --start-address=0x14fcec0 --stop-address=0x14fef07 $out/compiler | grep "(%rip)" | grep -o "# [0-9a-f]*" | tr '\n' ' '; echo
done
