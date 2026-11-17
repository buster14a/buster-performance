#!/bin/bash
# job-tests.sh LABEL PATCH [READINGS]: the tests on the window (PATCH against main BASE, default the piece's first
# base; its build's label BASE_LABEL, default `base`), measured on the 9700X.
#   1. At reader time, READINGS readings in turn on sqlite3.c and Lua (default 7), three on musl: the window's tests
#      (LABEL, --window-tests: their own ticks, by sweep), and at the base the own form by its sets: T, C and X
#      (--front-sweeps) and with the own form (--front-own-tests).
#   2. The window's tests with every warning, and beside T checking itself against the action: one reading a corpus.
#   3. The window without the tests (--front-window), base against LABEL: three readings in turn (the kernel's, the
#      front's and the names' pass's ticks are not this piece's to change).
#   4. -c sqlite3.c as whole processes, base against LABEL, twice (compile.sh).
cd "$(dirname "$0")"
label=$1; patch=$2; readings=${3:-7}
base=${BASE:-0e8342dd7f1be0c07b97e9c6ec8dc2413887ef06}
b=${BASE_LABEL:-base}
test -x results/$b/compiler || ./build-label.sh $b $base || exit 1
./build-label.sh "$label" $base "$patch" || exit 1
./turns.sh "" "$readings" "sqlite3 lua" "$label window-tests --shadow --passes 0 --window-tests" "$b sweeps --shadow --passes 0 --front-sweeps" "$b own --shadow --passes 0 --front-own-tests" || exit 1
./turns.sh "" 3 "musl" "$label window-tests --shadow --passes 0 --window-tests" "$b sweeps --shadow --passes 0 --front-sweeps" "$b own --shadow --passes 0 --front-own-tests" || exit 1
./turns.sh "" 1 "sqlite3 lua musl" "$label window-tests-wall --shadow --passes 0 --window-tests -Wall -Wextra" "$label window-tests-verify --shadow --passes 0 --window-tests --verify" || exit 1
./turns.sh "" 3 "sqlite3 lua musl" "$b window --shadow --passes 0 --front-window" "$label window --shadow --passes 0 --front-window" || exit 1
./compile.sh $b "$label" 2 || exit 1
echo job finished
