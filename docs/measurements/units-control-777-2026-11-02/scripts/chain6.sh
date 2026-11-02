#!/bin/bash
while pgrep -f "final.sh tree-3ce71ec3" > /dev/null; do sleep 5; done
./lanes.sh tree-3ce71ec3 tree-7fd7aab1
