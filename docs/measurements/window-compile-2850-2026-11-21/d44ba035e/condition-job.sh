#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/2850-codex-step2
bash condition-pmu.sh conditiond44 bd35904be2f29a631661aa8abc5974c6db0002c7 assign39c prioron
bash condition-warning.sh conditiond44 assign39c prioron
bash condition-wall.sh conditiond44 assign39c prioron
echo COMPLETE
