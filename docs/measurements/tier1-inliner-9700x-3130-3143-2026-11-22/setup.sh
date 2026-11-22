#!/usr/bin/env bash
# setup.sh: the inputs: the frozen corpus's sqlite3.c and Lua 5.4.8's sources from CI's cached archive.
set -euo pipefail
. "$HOME/buster-fast-bench/3130-claude/env.sh"
cd "$W"
mkdir -p inputs/lua
ln -sfn "$CORPUS/sqlite/sqlite3.c" inputs/sqlite3.c
archive="$HOME/.cache/buster/ci/downloads/4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae"
echo "4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae  $archive" | sha256sum -c
tar -xzf "$archive" -C inputs/lua --strip-components=2 --wildcards 'lua-5.4.8/src/*'
ls inputs/lua | wc -l
sha256sum inputs/sqlite3.c
