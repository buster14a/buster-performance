#!/bin/bash
cd ~/buster-fast-bench/2536-step1-claude
./build-tree.sh head3 88270a604e487cfadce6291f29d05e2613422938 || exit 1
./gauges.sh compiler-head3 'gauge-head3-w0:--emit-window=0' 'gauge-head3-w512:--emit-window=512' 'gauge-head3-w1024:--emit-window=1024' 'gauge-head3-w2048:--emit-window=2048' 'gauge-head3-w4096:--emit-window=4096' 'gauge-head3-w8192:--emit-window=8192'
