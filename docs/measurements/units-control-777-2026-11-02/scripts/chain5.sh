#!/bin/bash
while pgrep -f chain4.sh > /dev/null; do sleep 5; done
./two.sh tree-3ce71ec3
