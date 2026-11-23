#!/bin/bash
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./lbr-train.sh relocs1 train1 main lua musl
./lbr-train.sh relocs1 sqlite1 sqlite
mkdir -p bolt
strip --strip-debug -o bolt/compiler-relocs1 trees/relocs1/build/compiler
ls -la bolt results/lbr-train1 results/lbr-sqlite1
echo job-complete
