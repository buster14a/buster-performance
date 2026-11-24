#!/bin/bash
# run.sh: #3451's branch sizing gate, the growth scan 16 at a time alone (gate-scan) against main 9da8765c5, CPU 2.
set -u
cd "$(dirname "$0")"
sha256sum gate-scan
taskset -c 2 ./gate-scan; echo "exit $?"
