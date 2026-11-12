#!/bin/bash
# apply.sh DIFF: src reset to main 0af27a30 by its id (no local change left) and DIFF applied; exits 1 where either fails.
set -u
cd "$(dirname "$0")/src" || exit 1
git checkout -q -- . && git clean -fdq && git checkout -q --detach 0af27a3096f9bd96334f27943dfc50918f58bc17 && git apply "../$1"
