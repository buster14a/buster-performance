#!/bin/bash
# The merged tree tests on the 9700X, each in a lock hold of its own (job.sh), into tests.txt: those the change touches.
D=~/buster-fast-bench/113-lanes-cloud
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
echo $$ > "$D/tests.pid"
J="$D/job.sh"
"$J" tests.txt branch taskset -c 0-7 ./build/compiler test-lanes
"$J" tests.txt branch taskset -c 0-7 ./build/compiler test-checker-deferred
"$J" tests.txt branch taskset -c 0-7 bash -c "./build/compiler test-call-graph && ./build.sh check-call-graph"
"$J" tests.txt branch taskset -c 0-7 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 "$D/c-testsuite/tests/single-exec"
"$J" tests.txt branch taskset -c 0-7 ./build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols --report build/checker-sqlite.tsv --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
"$J" tests.txt branch taskset -c 0-7 ./build/compiler test-checker --seed 133
echo "done $(date -Is)" >> "$D/tests.txt"
