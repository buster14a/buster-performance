#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
(cd base && sha256sum --check ../source-base.sha256) > logs/source-base-check.txt
(cd head-final && sha256sum --check ../source-head.sha256) > logs/source-head-check.txt
sha256sum base/build/compiler head-final/build/compiler matrix probe-base/probe probe-head/probe > logs/binaries-final.sha256
sha256sum inputs/*.c > logs/inputs-final.sha256
printf 'TRAFFIC_COLUMNS mode size count cleared copied scanned byte_peak scratch_peak byte_live scratch_live valid\n'
./matrix --verify
printf 'SOURCE_AND_MATRIX_OK\n'
