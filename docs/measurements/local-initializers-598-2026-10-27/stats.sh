#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
for variant in base head; do
    for input in cases/*.c; do
        stem=${input##*/}
        stem=${stem%.c}
        if ../"$variant"/build/compiler benchmark-backend-source --only encode "$input" > "logs/$variant-$stem.backend" 2>&1; then
            echo 'status=0' >> "logs/$variant-$stem.backend"
        else
            echo "status=$?" >> "logs/$variant-$stem.backend"
        fi
    done
done
