#!/bin/bash
# #2630 step 1, locally: every unit of the build compiled by stage 1 (the tree's Release executable) at --tier1, with the
# build's flags without debug information less -O3, -Wall and -Werror (as tools/ci/selfhost.c takes them), then the
# Release link command with each unit's object replaced: stage2-t1.
set -u
tree=/home/user/buster-wt-toolchain
stage1=$tree/build/cmake/native/Release/compiler
scratch=/tmp/claude-0/self
mkdir -p "$scratch/t1"
cd "$tree" || exit 2
mapfile -t options < <(BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release | tr '\0' '\n' | grep -vx -- '-O3\|-Wall\|-Werror')
printf '%s\n' "${options[@]}" > "$scratch/options.txt"
./build.sh print-sources | tr '\0' '\n' > "$scratch/sources.txt"
export stage1 scratch
compile_one()
{
    local source=$1 name
    name=$(basename "$source" .c)
    mapfile -t options < "$scratch/options.txt"
    if "$stage1" --tier1 "${options[@]}" -c -o "$scratch/t1/$name.o" "$source" > "$scratch/t1/$name.log" 2>&1; then echo "ok $name"; else echo "FAILED $name"; fi
}
export -f compile_one
xargs -a "$scratch/sources.txt" -n 1 -P 4 -I{} bash -c 'compile_one "$@"' _ {} > "$scratch/compile.txt"
grep -c '^ok' "$scratch/compile.txt"; grep FAILED "$scratch/compile.txt"
command=$(ninja -C build/cmake/native -f build-Release.ninja -t commands Release/compiler.link | tail -1)
command=${command#*&& }
rewritten=""
for word in $command; do
    case $word in
        CMakeFiles/buster_*.c.o) object=$(basename "$word" .c.o) ;;
        Release/codegen/*/native.o) object=$(basename "$(dirname "$word")") ;;
        *) object="" ;;
    esac
    if [ -n "$object" ]; then
        word=$scratch/t1/$object.o
    fi
    rewritten="$rewritten $word"
done
rewritten=${rewritten/-o Release\/compiler.link/-o $scratch/stage2-t1}
printf '%s\n' "$rewritten" > "$scratch/link.txt"
cd build/cmake/native && bash -c "$rewritten" > "$scratch/link.log" 2>&1; echo "link status $?"
ls -la "$scratch/stage2-t1"
