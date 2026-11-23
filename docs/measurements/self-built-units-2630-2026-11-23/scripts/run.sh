#!/bin/bash
# The whole campaign, detached: builds, then the executables' copies, the run times and the inventory.
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh; H=$d/scripts/held.sh
"$d/scripts/builds.sh"
"$L" "$H" "$d/results/copies.log" "$d/scripts/copies.sh"
"$d/scripts/runtime.sh"
"$d/scripts/inventory.sh"
echo campaign-done
