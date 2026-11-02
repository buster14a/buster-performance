#!/bin/bash
while pgrep -f chain3.sh > /dev/null; do sleep 5; done
./ab.sh abc 21 tree-3ce71ec3 tree-1ef2b35a tree-a4fdd67a tree-08ede275
