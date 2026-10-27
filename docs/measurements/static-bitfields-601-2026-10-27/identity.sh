#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
{
  date -u -Is
  uname -a
  lscpu
  clang --version
  ld.wild --version 2>/dev/null || wild --version
  perf --version
  objdump --version | head -1
  printf 'build: BUSTER_DEBUG_INFO=0 ./build.sh\n'
  printf 'flags: -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror, -no-pie\n'
  printf 'baseline: '; cat evidence/base-source.txt
  printf 'candidate: '; cat evidence/head-source.txt
  sha256sum base/build/compiler head/build/compiler
  sha256sum evidence/inputs/*.c
  cat evidence/corpus-files.sha256
} > evidence/identity.log
