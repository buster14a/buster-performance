#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
label=$1
prior=$2
base=$3
control=$4
bash real-compile-fair.sh "$label" "$base" "$prior" "$control"
bash real-warnings-fair.sh "$label" "$prior" "$control"
bash real-wall-fair.sh "$label" "$prior" "$control"
echo COMPLETE
