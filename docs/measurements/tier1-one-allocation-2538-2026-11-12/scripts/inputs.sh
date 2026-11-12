#!/bin/bash
# inputs.sh: Lua 5.4.8's release by its hash (the 9700X job's pin), unpacked under inputs/. No lock: no build, no run.
set -eu
cd "$(dirname "$0")"
mkdir -p inputs
if [ ! -f inputs/lua-5.4.8.tar.gz ]; then
    curl --fail --location --silent --show-error https://www.lua.org/ftp/lua-5.4.8.tar.gz --output inputs/lua-5.4.8.tar.gz
fi
printf '%s  %s\n' 4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae inputs/lua-5.4.8.tar.gz | sha256sum --check
tar -xzf inputs/lua-5.4.8.tar.gz -C inputs
ls inputs/lua-5.4.8/src/*.c | wc -l
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c | sha256sum --check
