#!/bin/bash
while pgrep -f "chain2.sh" > /dev/null; do sleep 5; done
./ab.sh candA 21 tree-3ce71ec3 tree-1ef2b35a
