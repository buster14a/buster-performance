#!/bin/bash
# The swept-size head (buster#3373): build, then profiles and stage tables of -c sqlite3.c without and with --node-bodies.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./setup.sh 3ef31299279732e3c927c3e5d54006afbd74a1e1 || exit 1
[[ -x trees/3ef312992/build/compiler ]] || { echo "no compiler"; exit 1; }
sleep 30
./prof2.sh 3ef312992-plain 3ef312992
./prof2.sh 3ef312992-bodies 3ef312992 --node-bodies
echo job-complete
