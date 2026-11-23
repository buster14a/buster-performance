#!/bin/bash
# kcount.sh COMPILER LABEL [OPTIONS...]: the kernels by COMPILER --tier1 OPTIONS, linked with clang's driver; prints
# LABEL kernel instructions per kernel function (callgrind's inclusive counts are unneeded: kernels call nothing).
set -u
compiler=$1
label=$2
shift 2
k=/tmp/claude-0/-home-user/98d46d8d-c801-5eaa-b4aa-aa7221f6e075/scratchpad/kern
clang=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
out=$k/out-$label
mkdir -p $out
"$compiler" --tier1 -fno-asynchronous-unwind-tables "$@" -c -o $out/kernels.o $k/kernels.c || exit 1
"$compiler" --tier1 -fno-asynchronous-unwind-tables "$@" -c -o $out/extra.o $k/extra.c || exit 1
$clang -o $out/drive $k/drive.o $out/kernels.o $out/extra.o || exit 1
$out/drive > $out/digest.txt
valgrind --tool=callgrind --callgrind-out-file=$out/cg $out/drive > /dev/null 2>&1
callgrind_annotate --threshold=100 $out/cg 2>/dev/null | grep -E ":[kx]_[a-z0-9_]+ " | sed -E "s/^ *([0-9,]+) .*:([kx]_[a-z0-9_]+) .*/\2 \1/" | tr -d "," | sort | sed "s/^/$label /"
echo "$label digest $(cat $out/digest.txt)"
