#!/bin/bash
# Peak RSS of the address row's four longest unit compiles (the ones a 4-job build runs at once), at once, from this
# session's worktree's build tree: their sum bounds what --jobs 4 asks of a 16 GB runner.
set -u
export LC_ALL=C
D=$HOME/.cache/claude-pr2056-review/2030
tree=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500/build/cmake/native-address-O3
cd "$tree" || exit 2
for unit in main_unit_checker main_unit_backend main_unit_frontend main_unit_executable; do
    command=$(ninja -f build-Release.ninja -t commands "CMakeFiles/buster_$unit.dir/Release/src/buster/compiler/$unit.c.o" | tail -1)
    command=${command//-o CMakeFiles\/buster_$unit.dir\/Release\/src\/buster\/compiler\/$unit.c.o/-o $D/mem-$unit.o}
    "$D/tools/maxrss" "$unit" bash -c "$command" 2>> "$D/mem.txt" > /dev/null &
done
wait
tail -4 "$D/mem.txt"
