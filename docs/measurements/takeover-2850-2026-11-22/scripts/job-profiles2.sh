#!/bin/bash
# Profiles of sqlite3.c: every body masked (the reader passes that stay), the eligible bodies supplied (what the host
# does then), and the ordinary compile at the same main.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-5a14"
./profile-env.sh masked-0b150b71b mask-branch "BUSTER_EXPERIMENT_MASK_BODIES=1"
./profile-env.sh supplied-bbe80f1a9 bbe80f1a9 "BUSTER_BOUNDARY_SUPPLY=$PWD/results/boundary-bbe80f1a9/recording"
./profile-env.sh whole-bbe80f1a9 bbe80f1a9 ""
echo job-complete
