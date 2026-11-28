#!/bin/bash
# census-host.sh COMPILER LUA_SRC: each Lua unit's first leave on this host's headers (BUSTER_DEBUG_BAIL build).
bin=$1; src=$2
for f in "$src"/*.c; do
    n=$(basename "$f" .c)
    line=$(BUSTER_DEBUG_BAIL=1 "$bin" --lanes 1 -std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c "$f" -o /dev/shm/3592-lua-claude/x.o 2>&1 | grep '^BAIL' | head -1)
    echo "$n: ${line:-direct}"
done
