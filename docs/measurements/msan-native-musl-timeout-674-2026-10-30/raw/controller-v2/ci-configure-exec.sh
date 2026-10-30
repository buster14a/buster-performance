#!/usr/bin/env bash
# Exact source-674 CI configure/source-env glue only; C owns all orchestration.
set -euo pipefail
export GITHUB_ENV=/home/david/Documents/Codex/2026-10-30/tak/work/msan-native-corpus-timeout-20261030/controller-v2/run/sanitizer.env
bash tools/ci/sanitizers.sh configure /home/david/Documents/Codex/2026-10-30/tak/work/msan-native-corpus-timeout-20261030/controller-v2/run/reports
set -a
source "$GITHUB_ENV"
set +a
exec "$@"
