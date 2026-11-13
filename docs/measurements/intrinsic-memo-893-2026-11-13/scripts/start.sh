#!/bin/bash
# start.sh HEAD_TREE QUEUE: waits for HEAD_TREE's build, then runs QUEUE (queue.sh), detached by its caller.
set -u
cd "$(dirname "$0")"
until grep -q '^exit ' "$1/build.log"; do sleep 5; done
if grep -q '^exit 0' "$1/build.log"; then HEAD_TREE=$1 ./queue.sh "$2"; else echo "== build failed" >> "$2.log"; fi
