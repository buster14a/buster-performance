#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# build.sh: one Release build of src (the default host, znver5 here) in one hold of the lock.
cd "$(dirname "$0")"
echo $$ > build.pid
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > build.holder.txt; cd src && ./build.sh" > build.log 2>&1
echo "build exit $?" >> build.log
sha256sum src/build/compiler >> build.log 2>&1
