#!/usr/bin/env bash
set -euo pipefail
root=${1:?usage: link_setup_adapters.sh ABSOLUTE_WORK_DIRECTORY}
for label in base fixed; do
    objects=()
    for index in $(seq 0 40); do
        if [ "$index" -eq 8 ]; then
            objects+=("$root/pr914-evidence/setup-objects-$label/8.o")
        else
            objects+=("$root/pr914-evidence/objects-$label/$index.o")
        fi
    done
    clang -no-pie -fuse-ld=wild "${objects[@]}" -lm -ldl -o "$root/pr914-evidence/setup-$label"
done
