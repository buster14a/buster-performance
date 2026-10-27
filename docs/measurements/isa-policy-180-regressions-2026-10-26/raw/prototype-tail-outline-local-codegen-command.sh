#!/bin/bash
set -e
cd '/home/david/.cache/buster421-tail-outline'
CORES_TITLE='PR421 outlined-tail local codegen diagnostic' CORES_LINK=https://github.com/buster14a/buster/pull/421 cores -n 1 -- clang -xc src/buster/compiler/x86_64_encoder_benchmark.c -c -march=znver5 -I src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -O3 -o /home/david/.cache/buster421-c051/prototype-outline-local-standalone.o
