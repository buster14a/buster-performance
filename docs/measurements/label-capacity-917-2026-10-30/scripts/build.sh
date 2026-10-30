#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# One source/build per shared lock hold. No timed execution.
set -euo pipefail
. "$(dirname "$0")/env.sh"
kind=${1:?base or candidate}
case "$kind" in base|candidate) ;; *) exit 2;; esac
cd "$Q/$kind"
test ! -e build
mkdir build
log="$Q/logs/build-$kind"
trap 'status=$?; printf "%s\n" "$status" > "$log.status"' EXIT
sha256sum --check --status "$Q/manifests/$kind-source.sha256"
./build.sh print-compile-flags > build/flags.nul
./build.sh print-sources > build/sources.nul
mapfile -d '' -t flags < build/flags.nul
mapfile -d '' -t sources < build/sources.nul
printf '%s\n' "$kind" > "$log.identity"
clang --version >> "$log.identity"
uname -a >> "$log.identity"
lscpu >> "$log.identity"
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor >> "$log.identity"
cat /sys/devices/system/cpu/cpu10/online >> "$log.identity"
printf '%s\0' "${flags[@]}" > "$log.flags.nul"
printf '%s\0' "${sources[@]}" > "$log.sources.nul"
objects=()
# Compile in bounded groups; link in the production source order.
running=0
for i in "${!sources[@]}"; do
  objects+=("$Q/$kind/build/$i.o")
  clang -c "${sources[$i]}" -o "build/$i.o" "${flags[@]}" > "build/$i.log" 2>&1 &
  running=$((running + 1))
  if [ "$running" -eq 8 ]; then wait; running=0; fi
done
wait
for object in "${objects[@]}"; do test -s "$object"; done
clang -no-pie --ld-path=/usr/bin/wild "${objects[@]}" -lm -ldl -o build/compiler
clang -S src/buster/compiler/main_unit_checker.c -o build/checker.s "${flags[@]}"
sha256sum build/compiler "${objects[@]}" > "$log.binaries.sha256"
sha256sum --check --status "$Q/manifests/$kind-source.sha256"
