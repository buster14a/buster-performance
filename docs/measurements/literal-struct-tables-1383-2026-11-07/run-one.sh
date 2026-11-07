#!/bin/bash
set -euo pipefail
input=$1
revision=$2
round=$3
key=$4
date -u +%s%N > "runs/$key.start"
./measure_struct_tables run "./bin/$revision" "$input" "$revision" "$round" > "runs/$key.tsv"
