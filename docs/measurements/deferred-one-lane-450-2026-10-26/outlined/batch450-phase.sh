#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
case "$1" in
    paired-1-3) for round in 1 2 3; do bash group450-phase.sh paired "$round"; done ;;
    paired-4-5) for round in 4 5; do bash group450-phase.sh paired "$round"; done ;;
    sweep-0) bash group450-phase.sh sweep 0 ;;
    sweep-1) bash group450-phase.sh sweep 1 ;;
    sweep-2) bash group450-phase.sh sweep 2 ;;
    *) exit 2 ;;
esac
