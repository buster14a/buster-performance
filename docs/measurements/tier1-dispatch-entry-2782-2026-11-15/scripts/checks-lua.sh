#!/usr/bin/env bash
cd /home/david/buster-fast-bench/2782-claude/inputs/lua || exit 1
for e in /home/david/buster-fast-bench/2782-claude/exe/lua-*; do
    bad=''
    for s in calls tables strings arithmetic closures; do $e $s.lua > /home/david/buster-fast-bench/2782-claude/check/out.txt 2>&1; rc=$?; { [ $rc = 0 ] && cmp -s /home/david/buster-fast-bench/2782-claude/check/out.txt /home/david/buster-fast-bench/2782-claude/inputs/ref/$s-clang0.out; } || bad="$bad $s:$rc"; done
    echo "exe/$(basename $e) ${bad:-ok}"
done
