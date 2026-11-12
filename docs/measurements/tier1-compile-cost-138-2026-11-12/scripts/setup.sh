#!/bin/bash
# setup.sh: a clean clone of buster at the measured commit (no lock: no build, no run).
set -eu
cd "$(dirname "$0")"
commit=c5f0efb20199618a542f0d8de61951916c15d76c
if [ ! -d src ]; then
    git clone -q https://github.com/buster14a/buster.git src
fi
git -C src fetch -q origin "$commit"
git -C src checkout -q --detach "$commit"
git -C src rev-parse HEAD > COMMIT
git -C src status --porcelain | wc -l >> COMMIT
cat COMMIT
