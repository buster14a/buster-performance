#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
mkdir -p inputs/st inputs/lua corpus tools results
ln -s /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite corpus/sqlite
curl --fail --location --retry 3 -o inputs/st/speedtest1.c https://raw.githubusercontent.com/sqlite/sqlite/ccc132c5be20ab5c755c97a08d06b1b592fef330/test/speedtest1.c
curl --fail --location --retry 3 -o inputs/lua/lua-5.4.8.tar.gz https://www.lua.org/ftp/lua-5.4.8.tar.gz
printf '%s  %s\n' b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675 inputs/st/speedtest1.c 4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae inputs/lua/lua-5.4.8.tar.gz 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d corpus/sqlite/sqlite3.c | sha256sum --check
tar -xzf inputs/lua/lua-5.4.8.tar.gz -C inputs/lua
cat > inputs/st/speedtest1-unity.c <<'EOF'
#include "sqlite3.c"
#define randomFunc speedtest1_randomFunc
#include "speedtest1.c"
EOF
sha256sum inputs/st/* inputs/lua/*.lua inputs/lua/lua-5.4.8/src/*.[ch] > inputs.sha256
