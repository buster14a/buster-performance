#!/bin/bash
# Inside a hold: src's Develop built off and with BUSTER_SELF_BUILT=tests, each executable copied to
# src/build/copies/CFG/compiler for runtime.sh; the tree is left configured and built with the setting on.
set -eu
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
cd "$d/src"
mkdir -p build/copies/off build/copies/tests
unset BUSTER_SELF_BUILT
./build.sh > "$d/tmp/copies-off.log" 2>&1
cp build/cmake/native/Develop/compiler build/copies/off/compiler
export BUSTER_SELF_BUILT=tests
./build.sh > "$d/tmp/copies-tests.log" 2>&1
cp build/cmake/native/Develop/compiler build/copies/tests/compiler
sha256sum build/copies/*/compiler build/cmake/native/Release/compiler
