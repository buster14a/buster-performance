#!/bin/bash
# build-then-prototype8.sh: once the prototype7 queue has finished, the inst8 build (one hold), then the prototype8
# queue (one hold a line).
cd "$(dirname "$0")"
while ! grep -q "^queue done" q-prototype7.txt.log 2>/dev/null; do sleep 5; done
./build.sh inst8
./queue.sh q-prototype8.txt
