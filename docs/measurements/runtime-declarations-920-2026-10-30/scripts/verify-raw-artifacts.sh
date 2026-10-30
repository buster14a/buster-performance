#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
packet=$(realpath "${1:?packet directory}")
while IFS= read -r line; do
  expected=${line%% *}
  relative=${line#*  }
  actual=$(gzip -dc "$packet/$relative.gz" | sha256sum | cut -d ' ' -f 1)
  test "$expected" = "$actual"
done < "$packet/manifests/raw-artifacts.sha256"
printf 'All generated raw artifacts decompress to their original recorded SHA256 bytes.\n'
