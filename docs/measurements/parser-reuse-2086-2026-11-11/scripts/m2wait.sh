#!/bin/bash
D=~/buster-fast-bench/2086-claude
until grep -q 'more done' $D/more.log 2>/dev/null; do sleep 10; done
exec bash $D/measure2.sh
