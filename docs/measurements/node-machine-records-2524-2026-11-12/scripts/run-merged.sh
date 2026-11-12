#!/bin/bash
cd $(dirname $0)
./measure2.sh split-f5b919f2 claude/zen-johnson-cah6b5 f5b919f20 - && rm -rf src/build
./measure2.sh 04abc91b claude/trusting-ramanujan-0q09lz 04abc91bb - && rm -rf src/build
./corpora.sh 04abc91b
