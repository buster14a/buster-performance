#!/bin/sh
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. Original per-run identity collection.
set -eu

record_root=${1:?owned target record directory required}
cd "$record_root"
mkdir -p receipts

{
    date -u '+%Y-%m-%dT%H:%M:%SZ'
    uname -a
    lscpu
    toolchain/official/bin/clang --version
    toolchain/official/bin/llvm-config --version
    gcc --version
    ld --version
    cat /var/lib/buster-9700x/owner
    printf '\nFrozen source: baseline abc6bf2455c6d1d78f16bc2d494276380c546a79; candidate4 732b79132a52264683abdd0b757053c3901e622b\n'
    printf 'Published integration74430099 is not a timing binary.\n'
} > receipts/identity.log

find baseline/src candidate4/src -type f -print0 | sort -z | xargs -0 sha256sum > receipts/source.sha256
sha256sum baseline/build/compiler candidate4/build/compiler harness/foreign-cost.c harness/foreign-cost-base harness/foreign-cost-candidate > receipts/binaries.sha256
find cost-foreign-base-1 cost-foreign-candidate-1 cost-foreign-base-2 cost-foreign-candidate-2 cost-foreign-base-3 cost-foreign-candidate-3 \
     cost-link-base-1 cost-link-candidate-1 cost-link-base-2 cost-link-candidate-2 \
     cache-link-base-1 cache-link-candidate-1 cache-link-base-2 cache-link-candidate-2 -type f -print0 | sort -z | xargs -0 sha256sum > receipts/inputs-and-outputs.sha256
wc -l receipts/source.sha256 receipts/binaries.sha256 receipts/inputs-and-outputs.sha256
sha256sum receipts/identity.log receipts/source.sha256 receipts/binaries.sha256 receipts/inputs-and-outputs.sha256
