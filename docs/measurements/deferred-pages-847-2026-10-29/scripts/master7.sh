#!/bin/bash
# #847: build headhuge-95fc3668, then E1 on five units.
. ~/buster-fast-bench/claude-764/scripts/env.sh
"$D/scripts/make-headhuge.sh" >> "$D/logs/master7.out" 2>&1
if [ ! -x "$D/trees/headhuge-95fc3668/build/compiler" ]; then echo "master7: no headhuge build $(date -Is)" >> "$D/logs/chain.txt"; exit 1; fi
"$D/scripts/e1.sh" h16x10 d2x1f384s288 b16x19 l16x19f192 h16x154 >> "$D/logs/master7.out" 2>&1
echo "master7 done $(date -Is)" >> "$D/logs/chain.txt"
