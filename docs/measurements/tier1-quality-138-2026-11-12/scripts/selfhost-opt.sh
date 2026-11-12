#!/bin/bash
# selfhost-opt.sh B|B+inline FLAG... -c -o OBJECT SOURCE: one unit through clang's front end at -O2 without LLVM's
# passes, opt with the ladder's bottom pipeline, and llc -O2 (selfhost-build.sh's B rows).
set -eu
kind=$1; shift
arguments=("$@")
count=${#arguments[@]}
source=${arguments[$((count - 1))]}
object=${arguments[$((count - 2))]}
flags=("${arguments[@]:0:$((count - 4))}")
m2r='function(mem2reg,sccp,adce,simplifycfg)'
passes=$m2r
[ "$kind" = B+inline ] && passes="$m2r,cgscc(inline),function(sccp,adce,simplifycfg)"
clang "${flags[@]}" -O2 -Xclang -disable-llvm-passes -emit-llvm -c -o "$object.0.bc" "$source"
opt "-passes=$passes" -o "$object.bc" "$object.0.bc"
llc -O2 -filetype=obj -relocation-model=pic -o "$object" "$object.bc"
rm -f "$object.0.bc" "$object.bc"
