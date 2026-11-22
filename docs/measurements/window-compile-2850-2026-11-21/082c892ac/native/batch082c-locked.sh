#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
test -x results/batch082c/compiler
for g in sqlite main; do ./lock.sh bash batch082c-locked-one.sh "$g"; done
echo COMPLETE
