#!/bin/sh
# #1444 item 5: the session's clone of buster14a/buster, with the base (main when the branch was cut) and the head.
set -e
d=~/buster-fast-bench/1444-claude-options
mkdir -p $d && cd $d
[ -d repo ] || git clone -q https://github.com/buster14a/buster repo
cd repo && git fetch -q origin main claude/awesome-volta-43z617 && git rev-parse origin/claude/awesome-volta-43z617
