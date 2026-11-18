#!/bin/bash
# job-pair-built.sh HEAD BASE: job-pair.sh for a build HEAD that is there already (its window without the tests was
# read by job-window.sh; those readings are kept and three more are taken, in turn with BASE).
cd "$(dirname "$0")"
head=$1; base=$2
test -x results/$head/compiler || exit 1
./turns.sh "" 7 "sqlite3 lua" "$base vs-$head --shadow --passes 0 --window-tests" "$head window-tests --shadow --passes 0 --window-tests" || exit 1
./turns.sh "" 15 "musl" "$base vs-$head --shadow --passes 0 --window-tests" "$head window-tests --shadow --passes 0 --window-tests" || exit 1
./turns.sh "" 5 "sqlite3 lua" "$base vs-$head-wall --shadow --passes 0 --window-tests -Wall -Wextra" "$head window-tests-wall --shadow --passes 0 --window-tests -Wall -Wextra" || exit 1
./turns.sh "" 15 "musl" "$base vs-$head-wall --shadow --passes 0 --window-tests -Wall -Wextra" "$head window-tests-wall --shadow --passes 0 --window-tests -Wall -Wextra" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "$head window-tests-verify --shadow --passes 0 --window-tests --verify" || exit 1
./compile.sh "$base" "$head" 2 || exit 1
echo job finished
