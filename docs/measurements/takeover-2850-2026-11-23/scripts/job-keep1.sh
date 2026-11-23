#!/bin/bash
# The pool keeps its arenas' pages between units (a prototype on the fix's merged head): build, then the switch off
# and on in one executable on musl's command, Lua's and a mixed command.
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
git -C src fetch -q origin claude/stoic-albattani-kgajm2
./exp.sh keep1 b7e3552cefb0 "$PWD/experiment-keep.patch" Release || exit 1
[[ -x trees/keep1/build/compiler ]] || { echo "no compiler"; exit 1; }
sleep 30
for w in musl lua mixed; do
    ./pair-env.sh keep1 $w 5 BUSTER_EXPERIMENT_KEEP_PAGES
done
echo job-complete
