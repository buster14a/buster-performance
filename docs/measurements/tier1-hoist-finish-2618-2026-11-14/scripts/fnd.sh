#!/usr/bin/env bash
# fnd.sh A.tsv B.tsv FUNCTION [MIN]: the function's executed instructions in A and B, normalized (addresses and rip
# displacements out), diffed; lines with counts of at least MIN.
n() { bash ~/.cache/claude-2618b/scripts/fn.sh "$1" "$2" | awk -v m=${3:-1} '$1>=m {print $1, substr($0, index($0,$3))}' | sed 's/-\?0x[0-9a-f]*(%rip)/RIP/; s/<[^>]*>//; s/ [0-9a-f]\{5,\} / ADDR /g; s/# [0-9a-f]* /# /'; }
diff <(n "$1" "$3" "$4") <(n "$2" "$3" "$4") | grep '^[<>]'
