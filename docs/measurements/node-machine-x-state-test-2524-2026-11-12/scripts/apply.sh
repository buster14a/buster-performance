#!/bin/bash
# apply.sh DIFF: src reset to main f006224e by its id (no local change left), then DIFF applied. Stops (exit 1) where
# either fails.
set -u
cd "$(dirname "$0")"
git -C src checkout -q -- . && git -C src clean -fdq && git -C src checkout -q --detach f006224ef99a3340ebdaa1c7b0d67af0c8b118bc || exit 1
git -C src apply "$PWD/$1" || exit 1
git -C src diff --stat
