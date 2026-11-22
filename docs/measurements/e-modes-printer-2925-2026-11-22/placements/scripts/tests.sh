#!/bin/bash
# #2925's tests on the 9700X with a tree's Develop build: the preprocessor's, the carets', the lexer's and the frozen
# preprocessor corpus's CI blocks (one parallel run), test-preprocessor whole, and test-checker --requests (the option
# table), each run under the lock alone, with CI's Clang 23.1.4 first on PATH.
set -u
D=~/buster-fast-bench/1380-claude-2925
NAME=${1:?usage: tests.sh NAME}
export EXCLUSIVE_OWNER=claude-2925 EXCLUSIVE_TITLE='PR sweep: #2925 -E modes' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2925
export PATH=$(dirname $(ls -d ~/.cache/buster/benchpress-clang/*/bin/clang | head -1)):$PATH
export BUSTER_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
T=$D/$NAME
DEV=$T/build/cmake/native/Develop/compiler
cd $T
clang --version | head -1
awk 'BEGIN { split("Test the preprocessor on the repository\x27s translation units against clang|Test the caret display against clang|Test the preprocessor\x27s cases against clang (part 1 of 4)|Test the preprocessor\x27s cases against clang (part 2 of 4)|Test the preprocessor\x27s cases against clang (part 3 of 4)|Test the preprocessor\x27s cases against clang (part 4 of 4)|Test the C lexer as C++|Test the C lexer with C11\x27s raw-string prefixes|Test the C lexer with the R and LR raw-string prefixes|Test the C lexer without digraphs and // comments, as c89|Test the C lexer without digraphs, as -fno-digraphs|Test the C lexer without // comments, as C94|Test the C lexer|Compare a frozen preprocessor corpus subset with Clang|Test the independent preprocessor fuzz harness in C23|Test the independent preprocessor fuzz harness in C17|Test the preprocessor directive tables", h, "|"); for (i in h) want[h[i]] = 1 }
     /^== / { name = substr($0, 4); sub(/ \[[0-9]+ CPUs\]$/, "", name); keep = name in want }
     keep' tools/ci/correctness.tests > $D/tests-$NAME.list
echo "blocks: $(grep -c '^== ' $D/tests-$NAME.list)"
~/buster-fast-bench/exclusive.sh timeout -k 10 540 env BUSTER_COMPILER=$DEV $DEV parallel --jobs 8 --timeout 500 < $D/tests-$NAME.list > $D/tests-$NAME-blocks.log 2>&1
echo "blocks exit $?"
~/buster-fast-bench/exclusive.sh timeout -k 10 300 $DEV test-preprocessor > $D/tests-$NAME-preprocessor.log 2>&1
echo "test-preprocessor exit $?"
~/buster-fast-bench/exclusive.sh timeout -k 10 120 $DEV test-checker --requests > $D/tests-$NAME-requests.log 2>&1
echo "requests exit $?"
echo "tests done"
