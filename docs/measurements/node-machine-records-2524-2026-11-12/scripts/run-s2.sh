#!/bin/bash
cd $(dirname $0)
./measure2.sh s2 claude/zen-johnson-cah6b5 27ee009a3 $PWD/patches/s2.patch annotate
./measure2.sh stagger claude/zen-johnson-cah6b5 27ee009a3 $PWD/patches/stagger.patch
./measure2.sh split claude/zen-johnson-cah6b5 27ee009a3 -
