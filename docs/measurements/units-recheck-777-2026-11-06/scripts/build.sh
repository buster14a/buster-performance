#!/bin/bash
# Builds each named tree (BUSTER_DEBUG_INFO=0, as the 9700X job builds), each build holding the lock for itself.
. $(dirname $0)/common.sh
for t in "$@"; do build $t; done
echo build-finished
