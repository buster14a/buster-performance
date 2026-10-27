#!/usr/bin/env bash
# After queue.sh (PID $1): main.c's three functions this PR lowers, extracted as they are (main_three.c), compiled by
# head's -c --verify by both paths and with -g, and by clang -O0 -c: the objects, symbols, the naked functions' bytes,
# FDEs and rows. Under the lock, once.
cd ~/buster-fast-bench/asm-147b-claude || exit 1
while kill -0 "$1" 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-asm-147 EXCLUSIVE_TITLE="Inline assembly: naked functions and symbols (#147)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/147
L=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
$L bash -c '
set -x
head/build/compiler --verify -c -o three-vector.o main_three.c && head/build/compiler --scalar --verify -c -o three-scalar.o main_three.c && cmp three-vector.o three-scalar.o && echo "both paths: the same object"
clang -O0 -c -o three-clang.o main_three.c
head/build/compiler -g -c -o three-g.o main_three.c && clang -O0 -g -c -o three-clang-g.o main_three.c
nm three-vector.o | sort -k3; echo; nm three-clang.o | sort -k3
objcopy -O binary -j .text three-vector.o three-vector.text && objcopy -O binary -j .text three-clang.o three-clang.text
cmp <(head -c 203 three-vector.text) <(head -c 203 three-clang.text) && echo "interpreter_native_bridge: 203 bytes, the same"
cmp <(tail -c +209 three-vector.text | head -c 437) <(tail -c +209 three-clang.text | head -c 437) && echo "x86_semantics_test_enter: 437 bytes, the same"
readelf -wf three-vector.o | sed -n "/pc=0000000000000000/,/^$/p;/pc=00000000000000d0/,/^$/p"
readelf -wf three-clang.o | sed -n "/pc=0000000000000000/,/^$/p;/pc=00000000000000d0/,/^$/p"
llvm-dwarfdump --debug-line three-g.o | grep -E "^0x00000000000000(00|d0) "; llvm-dwarfdump --debug-line three-clang-g.o | grep -E "^0x00000000000000(00|d0) "
llvm-dwarfdump --verify three-g.o | tail -1
' > step-three.log 2>&1
echo "three $?" >> step-three.log
