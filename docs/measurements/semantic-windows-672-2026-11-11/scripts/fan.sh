#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# fan.sh COPIES LOOPS CPU...: one worker.sh per listed CPU, each pinned to it, all at
# once; fails when any worker failed.
set -u
copies=$1 loops=$2; shift 2
pids=()
for cpu in "$@"; do
    taskset -c "$cpu" ./worker.sh "$copies" "$loops" "c$cpu" & pids+=($!)
done
status=0
for pid in "${pids[@]}"; do wait "$pid" || status=1; done
exit $status
