#!/bin/bash
# PR #1186's review: the head that releases a lane's memory into its pool before clearing it, merged with main
# (tree-5ca7ae10), against main (tree-ee694254): final2.sh's tests, control, synth and Lua; the other tests of head 1;
# test-lanes twice by each; musl's -c by 8 lanes by main, the head and 1177419c (its release unmapped directly).
cd $HOME/buster-fast-bench/777-claude
./final2.sh tree-ee694254 tree-5ca7ae10
./extra.sh tree-5ca7ae10
./lanes.sh tree-ee694254 tree-5ca7ae10
./musl8.sh review tree-ee694254 tree-5ca7ae10 tree-1177419c
echo review-finished
