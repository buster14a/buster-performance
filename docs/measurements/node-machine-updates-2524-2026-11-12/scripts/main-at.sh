#!/bin/bash
# main-at.sh SHA LABEL: the main worktree checked out at SHA by its id (no local change left), built as LABEL, then the
# comparison (corpora.sh) and the timing (time.sh), each run in a hold of the lock of its own.
set -u
cd "$(dirname "$0")"
git -C main fetch -q origin main
git -C main checkout -q -- . && git -C main clean -fdq && git -C main checkout -q --detach "$1" || exit 1
mkdir -p "results/$2"
{ git -C main log -1 --format='%H %s'; git -C main status --short; echo "status printed above, if any"; } > "results/$2/checkout.txt"
./build-tree.sh main "$2" || exit 1
./corpora.sh "$2"
./time.sh "$2"
date -u +%FT%TZ > "results/$2/.all"
