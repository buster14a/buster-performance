#!/usr/bin/env bash
set -euo pipefail
task_root="$HOME/buster-fast-bench/issue608-20261027"
cd "$task_root/source-final"
BUSTER_DEBUG_INFO=0 ./build.sh
clang -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror "$task_root/moves_benchmark.c" -pthread -o "$task_root/moves-benchmark"
clang -D_GNU_SOURCE -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror "$task_root/moves_check.c" -pthread -o "$task_root/moves-sanitize"
