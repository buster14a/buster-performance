#!/bin/bash
T=$HOME/.cache/claude-1128/trace
cd $HOME/.cache/claude-1128/lua
L=(-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w)
lists=()
for n in 1 6; do lists+=(--list "${L[@]}" --lanes $n -o $T/lua-tr *.c -lm -ldl); done
$HOME/.cache/claude-1128/compiler-main-dbc time-runs --runs 11 --warmups 1 --build k0 $T/keep-0.sh --build k256k $T/keep-262144.sh --build k1m $T/keep-1048576.sh --build k4m $T/keep-4194304.sh "${lists[@]}"
