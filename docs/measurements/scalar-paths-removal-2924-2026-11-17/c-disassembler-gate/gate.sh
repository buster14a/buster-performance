#!/bin/bash
# #2924 phase C, the disassembler's gate: benchmark-x86-disassembler's vector variants (avx512, batched, compact)
# against its scalar one, on the synthetic compiler stream, the synthetic vector stream and real .text bytes (the
# benchmarked compiler's own). Each run under the lock, pinned to CPU 2.
set -euo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: phase C disassembler gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
cp ../2924-b2-claude/compilers/head compiler
sha256sum compiler > logs/compiler.sha256
objcopy -O binary --only-section=.text compiler compiler.text
sha256sum compiler.text >> logs/compiler.sha256
status=0
$L timeout -k 5 900 taskset -c 2 ./compiler benchmark-x86-disassembler > logs/compiler-stream.log 2>&1 || status=$?
echo "compiler stream: $status" >> logs/status.txt
status=0
$L timeout -k 5 900 taskset -c 2 ./compiler benchmark-x86-disassembler --vector > logs/vector-stream.log 2>&1 || status=$?
echo "vector stream: $status" >> logs/status.txt
status=0
$L timeout -k 5 900 taskset -c 2 ./compiler benchmark-x86-disassembler --file compiler.text > logs/text-file.log 2>&1 || status=$?
echo "text file: $status" >> logs/status.txt
date -u +%FT%TZ > logs/.done
