#!/bin/bash
# both.sh MICRO_ROUNDS AB_ROUNDS NAME...: micro.sh then ab.sh over the same variants, in one hold.
set -uo pipefail
d=$(dirname "$0"); mr=$1; ar=$2; shift 2
"$d/micro.sh" "$mr" "$@"
"$d/ab.sh" "$ar" "$@"
