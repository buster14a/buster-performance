#!/usr/bin/env bash
# From a checkout of buster14a/buster at 8b6f52351b34e85896203d626542486b7bdc4889, with these harness files copied to work/.
set -euo pipefail
# main-smoke.c is main.c with its section pragmas removed and BUSTER_ELSEWHERE made static; index-smoke.c owns TLS.
clang -O0 -fsanitize=address,undefined -fno-omit-frame-pointer -ffunction-sections -fdata-sections -Wl,--gc-sections -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Wno-unused-function work/index-smoke.c -lm -ldl -o work/overload-smoke-sanitize
ASAN_OPTIONS=detect_leaks=0 work/overload-smoke-sanitize
