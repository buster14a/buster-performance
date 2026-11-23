#!/usr/bin/env bash
# zen5.sh: the head's unmeasured Zen 5 rows (vzeroupper's and the VEX twins'), measure-x86-zen5 --missing --table, CPU 2,
# one lock hold.
set -u
source "$(dirname "$0")/common.sh"
cd $W || exit 1
mkdir -p out/zen5
$LOCK bash -c "$(declare -f state); state zen5 >&2; taskset -c 2 $HEAD measure-x86-zen5 --missing --table; echo exit \$? >&2; state zen5-end >&2" > out/zen5/table.txt 2> out/zen5/run.log
