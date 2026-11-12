#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# build.sh: one Release build of src (the host's default, native: znver5 here) in one hold of the lock.
cd "$(dirname "$0")/.."
mkdir -p results
./scripts/lock.sh bash -c "head -1 /var/lib/buster-9700x/owner; cd src && ./build.sh" > results/build.log 2>&1
echo "build exit $?" >> results/build.log
sha256sum src/build/compiler >> results/build.log 2>&1
