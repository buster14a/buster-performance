#!/bin/bash
# job-p41.sh: the fourth piece (p41: its patch on buster#2973's head cc9c84a54) against that head (m5), in turn.
cd "$(dirname "$0")"
./build-label.sh m5 cc9c84a54c47183515badf07aafb65e5974a82d3 || exit 1
./job-pair.sh p41 tests-p41-on-cc9c84a5.patch m5
