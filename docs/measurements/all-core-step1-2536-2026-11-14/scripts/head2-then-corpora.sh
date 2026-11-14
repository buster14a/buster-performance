#!/bin/bash
cd ~/buster-fast-bench/2536-step1-claude
./build-tree.sh head2 53ccda2e49378430aad63edb877901e09e3b9f94 || exit 1
[ -x compiler-head2 ] && ./corpora.sh compiler-head2 corpora-head2
