#!/bin/bash
# Starts phase C once phase B is done and fix3 is built.
cd ~/buster-fast-bench/442-claude-rebase
until grep -q phaseB-done logs/progress.log 2>/dev/null && grep -q build-fix3-done build-fix3.log 2>/dev/null; do sleep 30; done
./phaseC.sh 6 4
