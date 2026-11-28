#!/bin/bash
# mk.sh NAME [TREE]: the harness (direct_main.c) around TREE's src/buster/compiler/c_direct.c, for znver5 and for
# the machine it is built on, with CI's clang and the product's flags. EXTRA_FLAGS adds the instrumentation's macros
# (-DBUSTER_DIRECT_DUMP, -DBUSTER_DIRECT_TIMERS, -DBUSTER_DIRECT_NOCODE). BUSTER is a buster checkout (for its
# toolchain script), W the directory that has this script's direct_main.c and takes bin/.
set -euo pipefail
BUSTER=${BUSTER:-$HOME/buster}
W=${W:-$(cd "$(dirname "$0")" && pwd)}
name=$1; src=${2:-$BUSTER}
mkdir -p "$W/bin"
cd "$src"
PATH="$(bash "$BUSTER/tools/ci/session-toolchain.sh" stage):$PATH"
flags=(-Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 -ffunction-sections -O3 -g -static ${EXTRA_FLAGS:-})
clang -march=znver5 "${flags[@]}" src/buster/compiler/c_direct.c "$W/direct_main.c" -o "$W/bin/direct-$name" &
clang -march=native "${flags[@]}" src/buster/compiler/c_direct.c "$W/direct_main.c" -o "$W/bin/direct-$name.native" &
wait
