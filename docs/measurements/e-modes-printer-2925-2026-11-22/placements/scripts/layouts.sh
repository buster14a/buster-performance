#!/bin/bash
# The preprocessor's structures' layouts in each tree's Release executable (gdb ptype /o), for #2925's default path.
set -u
D=~/buster-fast-bench/1380-claude-2925
for t in "$@"; do
    gdb -batch -ex 'ptype /o struct PPOptions' -ex 'ptype /o struct Preprocessor' -ex 'ptype /o struct PPPrepare' -ex 'ptype /o struct PPFileData' -ex 'ptype /o struct PPMarkers' -ex 'ptype /o struct FileCache' $D/$t/build/compiler > $D/layout-$t.txt 2>&1
    echo "$t: $(wc -l < $D/layout-$t.txt) lines"
done
