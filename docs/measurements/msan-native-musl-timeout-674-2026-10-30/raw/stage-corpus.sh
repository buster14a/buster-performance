#!/usr/bin/env bash
set -euo pipefail
task=/home/david/Documents/Codex/2026-10-30/tak/work/msan-native-corpus-timeout-20261030
mkdir -p "$task/setup-downloads/tmp"
export TMPDIR="$task/setup-downloads/tmp"
test ! -e "$task/corpus-stage.started"
date --iso-8601=seconds > "$task/corpus-stage.started"
sha256sum "$task/source-674/tools/ci/fetch-corpus.sh" > "$task/corpus-fetch-script.sha256"
status=0
timeout --kill-after=10s 300 bash "$task/source-674/tools/ci/fetch-corpus.sh" "$task/corpus-391e729af658" > "$task/corpus-stage.log" 2>&1 || status=$?
printf 'corpus_stage=%s\n' "$status" > "$task/corpus-stage.status"
test "$status" -eq 0
sha256sum "$task/corpus-391e729af658/MANIFESTS.sha256" "$task/corpus-391e729af658"/manifests/*.sha256 > "$task/corpus-manifests.sha256"
date --iso-8601=seconds > "$task/corpus-stage.finished"
