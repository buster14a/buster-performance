#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See Buster's LICENSE and LICENSING.md.
# Run after the final source and binary have been frozen.
# SOURCE must be the root from which FLAGS_NUL's relative arguments were captured.
# Each compiler process takes the shared host lock separately.
set -euo pipefail
if [[ $# != 5 ]]; then
    echo 'usage: lowering-runs.sh SOURCE COMPILER FLAGS_NUL SOURCE_MANIFEST OUT' >&2
    exit 2
fi
source_root=$(realpath "$1")
compiler=$(realpath "$2")
flags_file=$(realpath "$3")
manifest=$(realpath "$4")
mkdir -p "$5"
output=$(realpath "$5")
lock=${BUSTER_LOCK:-/home/david/buster-fast-bench/exclusive.sh}
rounds=${ROUNDS:-11}
passes=${PASSES:-21}
[[ $rounds =~ ^[0-9]+$ && $rounds -ge 7 && $rounds -le 101 && $((rounds % 2)) == 1 ]]
[[ $passes =~ ^[0-9]+$ && $passes -ge 1 && $passes -le 101 && $((passes % 2)) == 1 ]]
[[ -x $compiler && -x $lock && -s $flags_file && -s $manifest ]]
[[ -z ${BUSTER_9700X_HELD:-} ]] || { echo 'Run the campaign outside an existing host lock.' >&2; exit 2; }
[[ -z ${BUSTER_LOWER_SURVEY:-} ]] || { echo 'A survey build is not acceptance evidence.' >&2; exit 2; }
export EXCLUSIVE_OWNER=${EXCLUSIVE_OWNER:-codex-rescue-126}
export EXCLUSIVE_TITLE=${EXCLUSIVE_TITLE:-Finish original Claude cloud issue 126}
export EXCLUSIVE_LINK=${EXCLUSIVE_LINK:-https://github.com/buster14a/buster/issues/129}
export SOURCE_DATE_EPOCH=1792454400
export LC_ALL=C
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
mapfile -d '' -t flags < "$flags_file"
[[ ${#flags[@]} -gt 0 ]]
cd "$source_root"
sha256sum --check --status "$manifest"
sha256sum "$compiler" > "$output/compiler.before.sha256"
cp "$flags_file" "$output/compile-flags.argv0"
printf '%q ' "$compiler" benchmark-lowering-source --passes "$passes" "${flags[@]}" src/buster/compiler/main.c > "$output/command.shell"
printf '\n' >> "$output/command.shell"
printf 'round\tpasses\tstatus\n' > "$output/status.tsv"
for ((round=1; round<=rounds; round+=1)); do
    log=$(printf '%s/process-%02d.log' "$output" "$round")
    [[ ! -e $log ]] || { echo "Refusing to overwrite $log" >&2; exit 2; }
    status=0
    "$lock" taskset -c 2 "$compiler" benchmark-lowering-source --passes "$passes" "${flags[@]}" src/buster/compiler/main.c > "$log" 2>&1 || status=$?
    printf '%s\t%s\t%s\n' "$round" "$passes" "$status" >> "$output/status.tsv"
    [[ $status == 0 ]] || { echo "Round $round failed: $log" >&2; exit "$status"; }
done
sha256sum --check --status "$manifest"
sha256sum "$compiler" > "$output/compiler.after.sha256"
cmp "$output/compiler.before.sha256" "$output/compiler.after.sha256"
echo 'Raw paired process medians saved. Analyze with summarize.c, then audit the actual object/CI gates separately.'
