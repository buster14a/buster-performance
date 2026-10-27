#!/bin/bash
cd ~/buster-fast-bench/tree-186-544-claude/head3 && BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1 && tail -1 build.log
cd ~/buster-fast-bench/tree-186-544-claude && ./measure.sh main head3 ab4 > ab4.txt 2>&1
