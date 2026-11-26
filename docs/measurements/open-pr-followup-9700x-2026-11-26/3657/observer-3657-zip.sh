#!/usr/bin/env bash
set -euo pipefail
if [[ "$#" -lt 3 || "$1" != -q ]]; then
    printf '%s\n' 'Benchpress fixture ZIP wrapper expects zip -q archive member...' >&2
    exit 2
fi
shift
archive=$1
shift
exec /usr/bin/bsdtar --format zip -cf "$archive" -- "$@"
