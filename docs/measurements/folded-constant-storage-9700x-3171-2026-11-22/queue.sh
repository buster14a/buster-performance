#!/usr/bin/env bash
# queue.sh: setup, the two Release builds, identity, then the A/B; each build and run its own hold.
set -uo pipefail
. "$HOME/buster-fast-bench/3022-claude/env.sh"
cd "$W"
echo "queue start $(date -u -Iseconds)"
./setup.sh || { echo "setup failed"; exit 1; }
./build-one.sh base base || { echo "build base failed"; exit 1; }
./build-one.sh head head || { echo "build head failed"; exit 1; }
./identity.sh
./ab.sh 6 7
echo "queue end $(date -u -Iseconds)"
