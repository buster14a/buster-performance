#!/bin/bash
# Lua 5.4.8's 34 files, each -c; extra arguments (--tier1) first.
for f in /home/david/buster-fast-bench/2958-claude/inputs/lua-5.4.8/src/*.c; do /home/david/buster-fast-bench/2958-claude/head/build/compiler "$@" -c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o /home/david/buster-fast-bench/2958-claude/out/lua-head.o "$f" || exit 1; done
