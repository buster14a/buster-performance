#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -euo pipefail
copy_source=/home/david/Documents/Codex/2026-10-30/tak/work/pr883-propagated-qualification
copy_packet=/home/david/Documents/Codex/2026-10-30/tak/work/performance883-propagated/docs/measurements/nested-fragments-883-2026-10-30/propagated-cecd
test ! -e "$copy_packet"
mkdir -p "$copy_packet/raw"
printf 'sha256\tpacket_path\toriginal_path\tcmp_exit\n' > "$copy_packet/raw-copy-verification.tsv"
while IFS= read -r copy_line; do
    copy_hash=${copy_line:0:64}
    copy_relative=${copy_line:66}
    copy_relative=${copy_relative#./}
    [[ "$copy_relative" != /* && "$copy_relative" != *..* ]]
    mkdir -p "$copy_packet/raw/$(dirname "$copy_relative")"
    cp -- "$copy_source/$copy_relative" "$copy_packet/raw/$copy_relative"
    cmp -- "$copy_source/$copy_relative" "$copy_packet/raw/$copy_relative"
    printf '%s\traw/%s\t%s/%s\t0\n' "$copy_hash" "$copy_relative" "$copy_source" "$copy_relative" >> "$copy_packet/raw-copy-verification.tsv"
done < "$copy_source/receipts.sha256"
for copy_extra in receipts.sha256 ../pr883-integration-remote-before.txt; do
    copy_name=$(basename "$copy_extra")
    cp -- "$copy_source/$copy_extra" "$copy_packet/raw/$copy_name"
    cmp -- "$copy_source/$copy_extra" "$copy_packet/raw/$copy_name"
    copy_hash=$(sha256sum "$copy_source/$copy_extra")
    printf '%s\traw/%s\t%s/%s\t0\n' "${copy_hash:0:64}" "$copy_name" "$copy_source" "$copy_extra" >> "$copy_packet/raw-copy-verification.tsv"
done
(
    cd "$copy_packet/raw"
    sha256sum -c receipts.sha256
) > "$copy_packet/raw-copy-check.log"
for copy_role in ordinary-native ordinary-baseline address-native address-baseline thread-native; do
    mkdir -p "$copy_packet/inspection/$copy_role"
    sed -E 's/,[[:space:]]*$//' "$copy_packet/raw/$copy_role/compile_commands.json" | jq -s . > "$copy_packet/inspection/$copy_role/compile_commands.normalized.json"
    for copy_argv in "$copy_packet/raw/$copy_role/"*.nul; do
        tr '\0' '\n' < "$copy_argv" > "$copy_packet/inspection/$copy_role/$(basename "$copy_argv" .nul).argv.txt"
    done
done
