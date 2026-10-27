#!/usr/bin/env bash
set -eu
root="$HOME/buster-fast-bench/codex-602-20261027"
printf 'source-commit=3683a159e19b0f260b5af36a0fd739695233f121\n'
cd "$root/head-final"
export BUSTER_DEBUG_INFO=0
./build.sh
clang -std=c17 -O2 -Wall -Wextra -Werror "$root/evidence/generate.c" -o "$root/generate"
clang -std=c17 -O2 -Wall -Wextra -Werror "$root/evidence/measure.c" -o "$root/measure"
mv "$root/head" "$root/head-3dc19511"
mv "$root/head-final" "$root/head"
