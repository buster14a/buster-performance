#!/bin/bash
cd ~/buster-fast-bench/2719-claude
while [ ! -f all.done ]; do sleep 20; done
for part in kernels profile; do ./lock.sh $part; done
echo done > more.done
