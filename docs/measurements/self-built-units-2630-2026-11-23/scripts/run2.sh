#!/bin/bash
# The trimmed campaign, detached: the inventory's blocks first, then the builds, the executables' copies and the run
# times.
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh; H=$d/scripts/held.sh
"$d/scripts/inventory2.sh"
"$d/scripts/builds2.sh"
"$L" "$H" "$d/results/copies.log" "$d/scripts/copies.sh"
"$d/scripts/runtime.sh"
echo campaign-done
