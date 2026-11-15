#!/bin/bash
# queue-g.sh: after queue-f, each sanitizer's branch executable against main's (identity.sh: functions, sections, .text),
# the splitters' A/B on MSan's checker, then Release without debug information on main and on the branch, whose
# executables must be the same bytes.
cd ~/buster-fast-bench/2639-claude
while [ ! -e results/queue-f.done ]; do sleep 20; done
for s in memory address thread; do
    ./identity.sh identity2-$s $s
done
./split-ab.sh split-ab2-memory native-memory-O3 main_unit_checker
./release-build2.sh release2-g0-main src
./release-build2.sh release2-g0-branch split
echo finished > results/queue-g.done
