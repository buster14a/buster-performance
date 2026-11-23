#!/bin/bash
D=~/buster-fast-bench/3393-claude
$D/scripts/stages.sh $D/bin/main main-f1 7
$D/scripts/stages.sh $D/bin/f1 f1 7
