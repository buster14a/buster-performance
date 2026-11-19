#!/bin/bash
# job-x9.sh: the call piece with an experiment switch (BUSTER_TESTS_SKIP: 1 no arguments pass; 2 and no clearing of
# its two tables; 3 and no answers of a type with its row), one executable, each setting in turn on musl.
cd "$(dirname "$0")"
./build-label.sh x9 bc66290c50443c09e75570e4eedcccc607355004 contexts-x9.patch || exit 1
./turns-env.sh "-x" 9 "musl" "x9 lv0 0 --shadow --passes 0 --window-tests" "x9 lv1 1 --shadow --passes 0 --window-tests" "x9 lv2 2 --shadow --passes 0 --window-tests" "x9 lv3 3 --shadow --passes 0 --window-tests" "x9 lv0b 0 --shadow --passes 0 --window-tests" || exit 1
echo job finished
