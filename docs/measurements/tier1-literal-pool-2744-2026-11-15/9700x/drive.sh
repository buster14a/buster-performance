#!/usr/bin/env bash
D=$1; shift
for side in base head; do
    for list in lexer sqlite sqlite-tier1; do
        case $list in lexer) args=$LEXER ;; sqlite) args=$SQLITE ;; *) args="--tier1 $SQLITE" ;; esac
        timeout 600 "$D/results/compiler-$side" $args > /dev/null 2>&1
        echo "drive check $side $list status $?"
    done
done
