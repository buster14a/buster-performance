#!/bin/bash
set -eu
cd "$(dirname "$0")"; d=$PWD; cd ../full-source-program
./build.sh --config Develop --target compiler --jobs 1 >"$d/build.log" 2>&1
cp ../body-action-rows/build/predefines.h build/
ln -sf ../full-source-program/build/compiler "$d/compiler"
