#!/bin/bash
# inputs.sh: measure-tier1-programs' own inputs, as the 9700X job's step takes them, into inputs/: SQLite 3.53.2's
# test/speedtest1.c and Lua 5.4.8's release, each by its SHA-256 (tools/ci/cached-download.sh of the measured tree),
# and the cc3387f record's five scripts, which this record's checkout sent (inputs/scripts), by theirs. The frozen
# sqlite3.c is the host's corpus copy. No build and no run, so no lock.
set -eu
cd "$(dirname "$0")"
mkdir -p inputs
bash src/tools/ci/cached-download.sh https://raw.githubusercontent.com/sqlite/sqlite/ccc132c5be20ab5c755c97a08d06b1b592fef330/test/speedtest1.c \
    b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675 inputs/speedtest1.c
bash src/tools/ci/cached-download.sh https://www.lua.org/ftp/lua-5.4.8.tar.gz \
    4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae inputs/lua-5.4.8.tar.gz
tar -xzf inputs/lua-5.4.8.tar.gz -C inputs
sha256sum --check <<'SUMS'
0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d  /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
9f1212609c533224542e33220fce0f384d35c6a939d49b2c3f17cbad6cf9c4f4  inputs/scripts/arithmetic.lua
a0d485c9497cf4bd0530637453e1cb75f52f9a94a913a38ee695c3cfa168aae0  inputs/scripts/calls.lua
b111c0dd5c658b1ed06722531197f34a82c9c4627e5306745ef794b05a2139e4  inputs/scripts/closures.lua
1be7b3a7893cc12e4ce42d18aacd1254111304d3c1fc81af3a5c1084bc8447b6  inputs/scripts/strings.lua
6dc68175ad3d9fd7a09f181f609656c067a9767587ea81cccb38ef2be5202809  inputs/scripts/tables.lua
49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082  /usr/bin/tcc
SUMS
