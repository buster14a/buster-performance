#!/bin/bash
# capture446.sh: one run of #424's recorded link-foreign command by main's archived executable (51ab0b63), its objects
# kept and every execve's arguments traced, under the shared lock: the inputs and the exact command lines that
# procbench replays for #446.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
mkdir -p "$D/links"
cd ~/buster-fast-bench/build-270-claude/ab3/base
~/buster-fast-bench/exclusive.sh strace -f -qq -e trace=execve -e abbrev=none -s 4096 -o "$D/links/trace.txt" \
    ./build/compiler benchmark-link --only linkers --linkers link-foreign --kinds dynamic,static --functions 2000,102400 \
    --runs 1 --directory "$D/links" --keep > "$D/links/capture.log" 2>&1
echo "status $?" >> "$D/links/capture.log"
echo "done $(date -Is)" >> "$D/links/capture.log"
