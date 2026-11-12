#!/bin/bash
cd $(dirname $0)
while pgrep -x run-s4.sh > /dev/null; do sleep 10; done
./measure2.sh a7554651 claude/trusting-ramanujan-0q09lz a75546513 - annotate
mkdir -p results/main-0af27a30-b && cp results/main-0af27a30/compiler results/main-0af27a30-b/compiler
./time.sh main-0af27a30-b && ./repeat.sh main-0af27a30-b
./corpora.sh a7554651
