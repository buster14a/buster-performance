#!/usr/bin/env bash
set -euo pipefail
root=/home/david/buster-fast-bench/codex-pr915-20261030
mkdir -p "$root/frozen-ir"
temporary=$(mktemp)
trap 'rm -f "$temporary"' EXIT
for kind in loop nested noloop sqlite-normalize; do
    logs=("$root"/results-source/*-"$kind".log)
    test "${#logs[@]}" -eq 24
    first=1
    for log in "${logs[@]}"; do
        awk '/^function / { keep=1 } keep { print } keep && /^}$/ { keep=0; count++ } END { if (count != 2 || keep) exit 1 }' "$log" > "$temporary"
        if (( first )); then cp "$temporary" "$root/frozen-ir/$kind.ir"; first=0; fi
        cmp "$temporary" "$root/frozen-ir/$kind.ir"
    done
    sha256sum "$root/frozen-ir/$kind.ir"
    printf 'fixture=%s identical-promoted-input-and-optimized-output=24\n' "$kind"
done
