#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Relink a Release compiler with source counters in the unity unit containing the binder and ELF writer.
set -euo pipefail
root=$(realpath "$1")
mkdir -p -- "$2"
out=$(realpath "$2")
export PATH="$(bash "$root/tools/ci/session-toolchain.sh" stage):$PATH"
record=$(jq -ce '[.[] | select(.file | endswith("/main_unit_dynamic.c"))] | first' "$root/build/compile_commands.json")
build=$(jq -r .directory <<<"$record")
object=$(realpath --relative-to="$build" "$(jq -r .output <<<"$record")")
compile=$(jq -r .command <<<"$record")
cd "$build"
link=$(ninja -f build-Release.ninja -t commands Release/compiler.link | tail -1)
# CMake and Ninja generated both shell commands in this checkout. Only the measured object
# and the final ELF receive different output paths. Preserve every other compile and link flag.
[[ "$compile" == *" -o $object "* && "$link" == *" $object "* && "$link" == *' -o Release/compiler.link '* ]]
compile=${compile/" -o $object "/" -fprofile-instr-generate -fcoverage-mapping -o \"\$1/dynamic.o\" "}
link=${link/" $object "/" \"\$1/dynamic.o\" "}
link=${link/" -o Release/compiler.link "/" -fprofile-instr-generate -o \"\$1/compiler\" "}
bash -c "$compile" _ "$out"
bash -c "$link" _ "$out"
