#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# From this evidence directory on the 9700X, with clean, built parent/head trees.
set -euo pipefail
if [ "$#" -ne 3 ]; then
    echo "usage: $0 PARENT_COMPILER CANDIDATE_COMPILER SQLITE_SOURCE" >&2
    exit 2
fi
parent=$(realpath "$1")
candidate=$(realpath "$2")
sqlite=$(realpath "$3")
export EXCLUSIVE_OWNER=codex-503
export EXCLUSIVE_TITLE='Issue 503 default-driver comparison'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/513
lock="$HOME/buster-fast-bench/exclusive.sh"
"$lock" clang -O2 -Wall -Wextra -Werror measure.c -lm -o measure
"$lock" clang -O2 -Wall -Wextra -Werror measure-matrix.c -lm -o measure-matrix
./measure --generate tiny.c 1
./measure --generate hints-1024.c 1024
"$lock" taskset -c 2 ./measure-matrix "$parent" "$candidate" "$PWD/tiny.c" "$PWD/hints-1024.c" "$sqlite" final
