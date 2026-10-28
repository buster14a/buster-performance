#!/bin/bash
# The second merge with main (06bda16): its build and the tests the change touches, each in a lock hold of its own
# (job.sh), into tests2.txt.
D=~/buster-fast-bench/113-lanes-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
echo $$ > "$D/tests2.pid"
J="$D/job.sh"
"$J" tests2.txt merge2 env BUSTER_DEBUG_INFO=0 ./build.sh || { echo "build failed $(date -Is)" >> "$D/tests2.txt"; exit 1; }
grep -q "^exit=0" <(tail -1 "$D/tests2.txt") || { echo "done (build failed) $(date -Is)" >> "$D/tests2.txt"; exit 1; }
"$J" tests2.txt merge2 taskset -c 0-7 ./build/compiler test-checker-deferred
"$J" tests2.txt merge2 taskset -c 0-7 ./build/compiler test-lanes
"$J" tests2.txt merge2 taskset -c 0-7 bash -c "./build/compiler test-call-graph && ./build.sh check-call-graph"
"$J" tests2.txt merge2 taskset -c 0-7 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 "$D/c-testsuite/tests/single-exec"
"$J" tests2.txt merge2 taskset -c 0-7 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols --report build/checker-sqlite.tsv --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
"$J" tests2.txt merge2 taskset -c 0-7 ./build/compiler test-checker --seed 133
"$J" tests2.txt merge2 taskset -c 0-7 ./build/compiler test-types
echo "done $(date -Is)" >> "$D/tests2.txt"
