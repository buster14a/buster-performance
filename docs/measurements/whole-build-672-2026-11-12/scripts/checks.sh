#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# checks.sh: the record's untimed steps in one hold of the lock (lock.sh ./checks.sh): what the -g objects hold
# (dwarfcensus.sh), the smallest inputs of what stopped the builds (defects.sh) and the outputs' sizes (sizes.sh).
cd "$(dirname "$0")"
./dwarfcensus.sh
census=$?
./defects.sh
defects=$?
./sizes.sh
echo "dwarfcensus $census defects $defects sizes $?"
