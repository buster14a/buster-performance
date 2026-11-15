#!/usr/bin/env bash
W=$HOME/buster-fast-bench/1118-claude
$W/setup.sh && $W/measure.sh
echo done > $W/all.done
