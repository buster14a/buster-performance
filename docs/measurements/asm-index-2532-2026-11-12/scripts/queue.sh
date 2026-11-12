#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# queue.sh SCRIPT...: runs each script in turn, each in a hold of the lock of its own (lock.sh), logging each hold's
# start and end to results/queue.log.
cd "$(dirname "$0")"
mkdir -p results
for s in "$@"; do
    echo "$(date -u +%FT%TZ) start $s" >> results/queue.log
    ./lock.sh bash -c "./$s"
    echo "$(date -u +%FT%TZ) end $s status $?" >> results/queue.log
done
