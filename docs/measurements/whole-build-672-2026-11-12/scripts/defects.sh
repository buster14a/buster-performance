#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# defects.sh: the smallest inputs that show what stopped the builds of this record (inputs/defects), each by this
# compiler and by the system's tools beside it, inside one hold of the lock (lock.sh ./defects.sh). Each command's
# output and status go to results/defects/NAME.txt.
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/defects
d=$here/inputs/defects
w=$t/defects
rm -rf $w
mkdir -p "$out" $w
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
try()
{
    local name=$1; shift
    "$@" > "$out/$name.txt" 2>&1
    echo "status $?" >> "$out/$name.txt"
}
cd $w || exit 1
# 1. -static with -lm: the direct path refuses the archive that the same command links as a file.
try static-lm-buster "$c" -static $d/static_lm.c -lm -o static-lm
try static-lm-file-buster "$c" -static $d/static_lm.c /usr/lib/libm.a -o static-lm-file
try static-lm-file-run ./static-lm-file
try static-lm-dynamic-buster "$c" $d/static_lm.c -lm -o static-lm-dynamic
try static-lm-clang clang -static $d/static_lm.c -lm -o static-lm-clang
# 2. The assembler: a parenthesized displacement.
try displacement-buster "$c" -c $d/displacement.s -o displacement.o
try displacement-as as $d/displacement.s -o displacement-as.o
try displacement-as-bytes objdump -d displacement-as.o
# 3. File-scope assembly, piece by piece.
for piece in type weak_hidden weak hidden call all; do
    try file-asm-$piece-buster "$c" -c $d/file_asm_$piece.c -o file-asm-$piece.o
    try file-asm-$piece-clang clang -c $d/file_asm_$piece.c -o file-asm-$piece-clang.o
done
# 4. link-foreign and a program's own __tls_get_addr: defined and called, and defined alone, with and without -g.
for g in "" -g; do
    "$c" -c $g $d/tls_define.c -o tls-define$g.o
    "$c" -c $g $d/tls_call.c -o tls-call$g.o
    "$c" -c $g $d/tls_only.c -o tls-only$g.o
    try tls-call$g-link-foreign "$c" link-foreign --lanes 1 -static -e entry -o tls-call$g tls-call$g.o tls-define$g.o
    try tls-only$g-link-foreign "$c" link-foreign --lanes 1 -static -e entry -o tls-only$g tls-only$g.o tls-define$g.o
    try tls-call$g-lld ld.lld -static -e entry -o tls-call$g-lld tls-call$g.o tls-define$g.o
    try tls-call$g-bfd ld.bfd -static -e entry -o tls-call$g-bfd tls-call$g.o tls-define$g.o
done
# 5. --time-stages on a link of objects: where the link's time is reported.
try time-stages-objects "$c" --time-stages $t/x/shell.o $t/x/sq.o -lm -o time-stages-objects
date -u +%FT%TZ > "$out/.done"
