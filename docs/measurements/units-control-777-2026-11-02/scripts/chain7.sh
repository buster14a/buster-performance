#!/bin/bash
while pgrep -f "lanes.sh tree-3ce71ec3" > /dev/null; do sleep 5; done
./final2.sh tree-3ce71ec3 tree-1177419c
