#!/bin/bash
# after.sh HEAD_TREE PREVIOUS NEXT [TREE]: waits for PREVIOUS's queue to finish and TREE's build, then runs NEXT.
set -u
cd "$(dirname "$0")"
until grep -q '^== done' "$2.log" 2>/dev/null; do sleep 10; done
if [[ -n ${4:-} ]]; then until grep -q '^exit ' "$4/build.log"; do sleep 5; done; fi
HEAD_TREE=$1 ./queue.sh "$3"
