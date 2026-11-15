#!/bin/bash
D=~/buster-fast-bench/2718-claude
$D/measure.sh full
$D/measure.sh fold BUSTER_MEM_FOLD=1
$D/measure.sh block BUSTER_MEM_CROSS=0
