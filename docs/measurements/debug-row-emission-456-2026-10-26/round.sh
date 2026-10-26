#!/usr/bin/env bash
root="$1"; round="$2"; shift 2
for spec in "$@"; do
    tree="${spec%%:*}"; variant="${spec#*:}"
    [ "$variant" = "$spec" ] && variant=""
    echo "== round $round case $spec $(date +%T)"
    (cd "$root/$tree" && env ${variant:+BUSTER_456_VARIANT=$variant} taskset -c 2 ./build/compiler benchmark-check-debug --only emit --runs 101 2>&1)
    echo "== status $?"
done
