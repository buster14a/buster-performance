#!/bin/bash
while kill -0 1115649 2>/dev/null; do sleep 5; done
./probe.sh tree-3ce71ec3 11
