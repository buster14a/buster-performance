#!/bin/bash
# build-then-prototype7.sh: once the pgo queue has finished, the inst7 build (one hold), then the prototype7 queue (one
# hold a line). It replaces prototype6b.sh's control, whose design prototype7.sh's includes.
cd "$(dirname "$0")"
while ! grep -q "^queue done" q-pgo.txt.log 2>/dev/null; do sleep 5; done
./build.sh inst7
./queue.sh q-prototype7.txt
