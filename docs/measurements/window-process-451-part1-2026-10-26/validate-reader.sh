#!/bin/bash
# Negative checks for the evidence reader. Run outside measurements, through the local limited-job permit.
# Usage: validate-reader.sh READER RAW_DIRECTORY OUTPUT_DIRECTORY
set -euo pipefail
reader=$(realpath "$1")
raw=$(realpath "$2")
output=$3
mkdir -p "$output/incomplete" "$output/nonzero-process" "$output/nonzero-exit" "$output/no-release"
source="$raw/process-1-sqlite-e.log"
sed '$d' "$source" > "$output/incomplete/process-1-sqlite-e.log"
"$reader" "$output/incomplete" "$output/incomplete-result" 0 | grep '0 completed rows'
sed '0,/status 0/s/status 0/status 1/' "$source" > "$output/nonzero-process/process-1-sqlite-e.log"
if "$reader" "$output/nonzero-process" "$output/nonzero-process-result" 0; then exit 1; fi
printf 'nonzero timed process: rejected\n'
sed 's/^exit=0 end:/exit=1 end:/' "$source" > "$output/nonzero-exit/process-1-sqlite-e.log"
if "$reader" "$output/nonzero-exit" "$output/nonzero-exit-result" 0; then exit 1; fi
printf 'nonzero command exit: rejected\n'
if "$reader" "$raw" "$output/missing-rounds-result" 8; then exit 1; fi
printf 'missing required rounds: rejected\n'
sed '/then the release/d' "$raw/phase-1-main-whole.log" > "$output/no-release/phase-1-main-whole.log"
if "$reader" "$output/no-release" "$output/no-release-result" 0; then exit 1; fi
printf 'missing release timing: rejected\n'
"$reader" "$raw" "$output/snapshot-result" 0
