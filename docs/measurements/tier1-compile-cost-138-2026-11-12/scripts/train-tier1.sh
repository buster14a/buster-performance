#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# train-tier1.sh: BUSTER_PGO_TRAIN's script for pgo.sh's build: the instrumented compiler ($BUSTER_PGO_COMPILER)
# compiles the three corpora (corpora.sh) by --tier1 -c and by the default -c, on one lane, a profile a process
# ($LLVM_PROFILE_FILE, the build's). The build runs it in its pgo/ directory.
set -eu
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$here/corpora.sh"
for name in sqlite lua musl; do
    options_name="${name}_options[@]"; files_name="${name}_files[@]"
    options=("${!options_name}"); files=("${!files_name}")
    for mode in tier1 default; do
        mkdir -p "train/$name-$mode"
        flag=()
        if [ "$mode" = tier1 ]; then flag=(--tier1); fi
        (cd "train/$name-$mode" && "$BUSTER_PGO_COMPILER" "${flag[@]}" "${options[@]}" --lanes 1 -c "${files[@]}")
    done
done
