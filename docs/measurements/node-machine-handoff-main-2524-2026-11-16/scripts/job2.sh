#!/bin/bash
# job2.sh: the branch's final sources (head2.patch: head.patch and the census's test of a string's object in a body
# that is never lowered, with its fixture) on main 1c6cc8ab5, built as head2.
#   1. At reader time, one reading a corpus: the tests with the default warnings and with every warning, the rows and
#      rules against the action, and T, C and X with the lean front.
#   2. The census's own reports, head2's against main's (job1's), with both sets of warnings.
#   3. The shadow's own sweeps after the pipeline, one reading a corpus.
#   4. -c sqlite3.c as whole processes, main against head2, twice.
cd "$(dirname "$0")"
main=1c6cc8ab5e778ab32078cbef17049c4814b30dca
./build-label.sh head2 $main head2.patch || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "head2 tests --shadow --front-tests" "head2 tests-wall --shadow --front-tests -Wall -Wextra" "head2 verify --shadow --verify --front-tests --passes 1" "head2 sweeps-lean --shadow --front-sweeps --front-lean" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "head2 census" "head2 census-wall -Wall -Wextra" "head2 shadow --shadow" || exit 1
mkdir -p results/head2
sed -i 's#results/\$2/compile-\$n.txt#results/$2/compile-$n.txt#' compile.sh
./compile.sh main head2 2 || exit 1
echo job2 finished
