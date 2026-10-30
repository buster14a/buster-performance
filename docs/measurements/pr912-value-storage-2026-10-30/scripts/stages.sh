#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
variant=$1
case "$variant" in base|candidate) ;; *) exit 2 ;; esac
taskset -c 2 "$Q/$variant/build/compiler" measure-compile --runs 11 --warmups 2 --keep --directory "$Q/evidence" -- -c "${sqlite[@]}"
