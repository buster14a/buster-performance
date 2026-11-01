#!/bin/bash
# shifts.sh TREE NAME: build TREE at six placements of the checker's unit into shifts/NAME, with head-wip's build.sh, one lock hold.
set -euo pipefail
. ~/buster-fast-bench/droid-zen5/scripts/env.sh
tool=$(realpath "$3")
out=$HOME/buster-fast-bench/droid-zen5/shifts/$2
mkdir -p "$out"
cd "$1"
BUSTER_DEBUG_INFO=0 $lock "$tool" shifts "$out" main_unit_checker.c $shifts
echo "shifts $2 done"
