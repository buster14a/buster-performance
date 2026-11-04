#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# The self-compile IBS profile (the _Generic issue): one -fsyntax-only of
# self-main.i under ibs_op, inside a one-core cores grant, from the run root:
#   cores -n 1 -- harness/self-ibs.sh
# then harness/inline-split.sh on the data, by function and by line.
cd "$(dirname "$0")/.."; export LC_ALL=C; unset CPATH
CPU=${CORES_CPUS%%,*}
mkdir -p results/zen4-7940hs/profiles/znver4-self
perf record -q -o scratch/zen4-7940hs/profile-znver4-self-ibs.data -e ibs_op/cnt_ctl=1,swfilt=1/u -c 400000 -- taskset -c $CPU bin/compiler-znver4 --predefines predefines-znver5.h -march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing -fsyntax-only self-main.i > /dev/null 2>&1
echo "status $?"
perf script -i scratch/zen4-7940hs/profile-znver4-self-ibs.data -F ip,sym 2>/dev/null > scratch/zen4-7940hs/self-ibs-ips.txt
wc -l < scratch/zen4-7940hs/self-ibs-ips.txt
