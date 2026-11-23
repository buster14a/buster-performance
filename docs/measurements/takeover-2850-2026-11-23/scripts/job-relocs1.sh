#!/bin/bash
# The fix's tree linked again with its relocations kept (--emit-relocs), for a post-link layout experiment.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./exp.sh relocs1 55008c81e "$PWD/relocs1.patch" Release || exit 1
[[ -x trees/relocs1/build/compiler ]] || { echo "no compiler"; exit 1; }
readelf -SW trees/relocs1/build/compiler | grep -c "\.rela\." 
size trees/relocs1/build/compiler trees/fix1/build/compiler
echo job-complete
