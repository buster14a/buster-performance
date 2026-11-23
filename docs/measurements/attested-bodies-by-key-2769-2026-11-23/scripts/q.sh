#!/bin/bash
# q.sh STEP TREE [ARGS]: one step.sh call under the 9700X's lock.
here=$(cd "$(dirname "$0")" && pwd)
EXCLUSIVE_OWNER=claude-2769-66vg9 EXCLUSIVE_TITLE="GitHub issue #2769" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2769 \
    timeout 3600 "$HOME/buster-fast-bench/exclusive.sh" "$here/step.sh" "$@"
