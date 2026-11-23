#!/bin/bash
# The three runs in turn, each under the lock on its own.
cd ~/buster-fast-bench/2719-claude
for part in kernels compile programs; do ./lock.sh $part; done
echo all-done > all.done
