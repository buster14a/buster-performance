#!/bin/bash
# build-then-prototype6.sh: the inst6 build (one hold), then the prototype6 queue (one hold a line).
cd "$(dirname "$0")"
./build.sh inst6
./queue.sh q-prototype6.txt
