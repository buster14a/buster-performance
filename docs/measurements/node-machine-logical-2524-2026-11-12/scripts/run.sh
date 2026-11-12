#!/bin/bash
# run.sh: main's compiler (the base, 0af27a30) and this change's (results/HEAD), built, compared on the corpora and timed.
set -u
cd "$(dirname "$0")"
head=$(git -C src rev-parse --short=8 HEAD)
test -d main || git -C src worktree add -q --detach ../main 0af27a3096f9bd96334f27943dfc50918f58bc17
./build.sh main main
./build.sh src "$head"
./corpora.sh "$head"
./corpora.sh main
./time.sh "$head"
./time.sh main
date -u +%FT%TZ > .done
