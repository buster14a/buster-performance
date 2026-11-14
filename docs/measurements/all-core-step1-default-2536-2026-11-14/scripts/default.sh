#!/bin/bash
cd ~/buster-fast-bench/2536-step1-claude
git -C repo fetch -q origin claude/magical-dijkstra-6klwmr main
./build-tree.sh head4 0c536ff6b6bf73738be4654f4d1ade30ffcee942 || exit 1
./gauges.sh compiler-head4 'gauge-head4-default:' 'gauge-head4-w0:--emit-window=0'
