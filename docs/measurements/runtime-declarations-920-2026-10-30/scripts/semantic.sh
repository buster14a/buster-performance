#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
# One semantic preflight under the shared lock. No timing inference.
set -euo pipefail
. "$(dirname "$0")/env.sh"
cd "$Q"
sha256sum --check --status manifests/executables.sha256
test "$(cat logs/proof-controls-local.status)" = 0
test ! -e semantic
mkdir semantic
trap 'status=$?; printf "%s\n" "$status" > "$Q/logs/semantic.status"' EXIT
cat /var/lib/buster-9700x/owner > semantic/lock-owner
{ date -u +%FT%TZ; uname -a; lscpu; grep '^microcode' /proc/cpuinfo | sort -u; } > semantic/host.txt
printf '%s  %s\n' \
  391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd "$CORPUS/MANIFESTS.sha256" \
  e307b836448ef20e603a617a4b5023831c72ff5f307f614c50f4f8833088717c "$CORPUS/manifests/headers-bundle.sha256" \
  9179b7ad7db7366d12a214b562e478ac703e7ec0376f38f4516756bcf7ee0047 "$CORPUS/manifests/sqlite.sha256" \
  a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33 "$CORPUS/provenance/gnu17-pinned-predefines.txt" | sha256sum --check
(cd "$CORPUS/headers" && sha256sum --check --status "$CORPUS/manifests/headers-bundle.sha256")
(cd "$CORPUS/sqlite" && sha256sum --check --status "$CORPUS/manifests/sqlite.sha256")
sha256sum "$CORPUS/sqlite/sqlite3.c" > semantic/input.sha256
(cd corpora/lua && sha256sum --check --status "$Q/manifests/lua.sha256")
for corpus in sqlite lua; do
  declare -n input=$corpus
  for kind in base candidate; do
    (cd "$kind" && sha256sum --check --status "$Q/manifests/$kind-source.sha256")
    for shift in 0 16 64 256 1024 2048; do
      stem="semantic/$corpus-$kind-$shift"
      taskset -c 2 "$Q/placements-$kind-v4/$shift/compiler" "${input[@]}" --lanes 1 --time-stages -o "$Q/$stem.o" > "$stem.stdout" 2> "$stem.stages"
      cmp "semantic/$corpus-base-0.o" "$stem.o"
      sha256sum "$stem.o"
    done
  done
  for kind in base candidate; do
    stem="semantic/$corpus-$kind-scalar"
    taskset -c 2 "$Q/$kind/build/compiler" "${input[@]}" --lanes 1 --scalar --time-stages -o "$stem.o" > "$stem.stdout" 2> "$stem.stages"
    cmp "semantic/$corpus-base-0.o" "$stem.o"
    sha256sum "$stem.o"
  done
  unset -n input
done
printf 'all uninstrumented objects are byte identical\n'
