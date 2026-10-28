#!/bin/bash
# The PR's head with the largest-body part fix (a36179a): its build and the tests the change touches, each in a lock hold
# of its own (job.sh), into tests3.txt.
D=~/buster-fast-bench/113-lanes-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
echo $$ > "$D/tests3.pid"
J="$D/job.sh"
"$J" tests3.txt merge3 env BUSTER_DEBUG_INFO=0 ./build.sh || { echo "build failed $(date -Is)" >> "$D/tests3.txt"; exit 1; }
grep -q "^exit=0" <(tail -1 "$D/tests3.txt") || { echo "done (build failed) $(date -Is)" >> "$D/tests3.txt"; exit 1; }
"$J" tests3.txt merge3 taskset -c 0-7 ./build/compiler test-checker-deferred
"$J" tests3.txt merge3 taskset -c 0-7 ./build/compiler test-lanes
"$J" tests3.txt merge3 taskset -c 0-7 bash -c "./build/compiler test-call-graph && ./build.sh check-call-graph"
"$J" tests3.txt merge3 taskset -c 0-7 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 "$D/c-testsuite/tests/single-exec"
"$J" tests3.txt merge3 taskset -c 0-7 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols --report build/checker-sqlite.tsv --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
"$J" tests3.txt merge3 taskset -c 0-7 ./build/compiler test-checker --seed 133
echo "done $(date -Is)" >> "$D/tests3.txt"
