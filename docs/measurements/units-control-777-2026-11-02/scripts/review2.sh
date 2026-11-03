#!/bin/bash
# PR #1186's second review: the head merged with main after #1158 (tree-8dad76a2) against that main (tree-b70deb47):
# final2.sh's units tests, control, synth and Lua; the other tests of head 1; test-lanes twice by each; musl's -c by 8
# lanes and one, with peaks.
cd $HOME/buster-fast-bench/777-claude
echo $$ > review2.pid
./final2.sh tree-b70deb47 tree-8dad76a2
./extra.sh tree-8dad76a2
./lanes.sh tree-b70deb47 tree-8dad76a2
./musl.sh tree-b70deb47 tree-8dad76a2
echo review2-finished
