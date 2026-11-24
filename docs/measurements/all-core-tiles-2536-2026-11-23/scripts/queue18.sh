#!/bin/bash
# The pieces together on one tree (main with the tiles' fix, the reader by the parse's tiles, the page policy), each
# configuration the one before it with one piece more: the unit as one; the parser's tiles; the reader's too; and those
# with the host's 64 KB knob on. One hold, three passes in turn.
set -uo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
cd "$dir"
git -C main fetch -q origin claude/blissful-cannon-kcl1ed:refs/heads/pr3497 || { echo "fetch failed"; exit 1; }
./setup2.sh be47869a2c17cda5e370264d44426dd786d112a6 all all1.patch > setup-all.log 2>&1
grep -q SETUP-DONE setup-all.log || { echo "setup all failed"; exit 1; }
./run9.sh all all-pair 3 'one|||--parse-tile=0' 'parser|||--reader-tiles=off' 'reader|||' 'pages|64||'
echo QUEUE-DONE
