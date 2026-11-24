#!/bin/bash
# run.sh: #3451's target-forms gate: main 9da8765c5's x86_target_forms (old) against the branch's (new), one
# executable, CPU 2, three rounds, one locked run.
set -u
cd "$(dirname "$0")"
sha256sum gate-tf
for round in 1 2 3; do echo "== round $round"; taskset -c 2 ./gate-tf; echo "exit $?"; done
