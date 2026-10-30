#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
variant=$1 mode=$2 round=$3
case "$variant:$mode" in base:preprocess|base:syntax|base:compile|candidate:preprocess|candidate:syntax|candidate:compile) ;; *) exit 2 ;; esac
args=(-E)
if [ "$mode" = syntax ]; then args=(-fsyntax-only); fi
if [ "$mode" = compile ]; then args=(-c -o /dev/null); fi
taskset -c 2 perf stat --no-big-num -x, \
  -e '{instructions:u,cycles:u,ex_ret_ucode_ops:u,ex_ret_ucode_instr:u}' \
  -o "$Q/evidence/counters-$round-$variant-$mode.csv" \
  -- "$Q/$variant/build/compiler" "${args[@]}" "${sqlite[@]}" > /dev/null
