#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
variant=$1
case "$variant" in base|candidate) ;; *) exit 2 ;; esac
command=("$Q/$variant/build/compiler" -c "${sqlite[@]}" -o /dev/null)
taskset -c 2 perf record -q -e 'ibs_op/cnt_ctl=1,period=100003/' -d -W \
  -o "$Q/evidence/ibs-$variant.data" -- bash -c \
  'for ((round=0;round<30;round++)); do "$@" > /dev/null || exit $?; done' repeat "${command[@]}"
