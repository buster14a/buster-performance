#!/bin/bash
while pgrep -f "chain1.sh" > /dev/null; do sleep 5; done
./trace.sh tree-c190a293
