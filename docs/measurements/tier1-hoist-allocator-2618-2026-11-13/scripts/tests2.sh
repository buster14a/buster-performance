#!/usr/bin/env bash
# More of tools/ci/correctness.tests' Tier 1 steps: the driver's Tier 1 oracles, SQLite's shell, the checker driver.
set -u
cd /home/user/buster
B=${B:-$PWD/build/compiler}
L=$HOME/.cache/claude-2618/tests/logs2; mkdir -p $L
step() { local name=$1; shift; "$@" > $L/$name.log 2>&1; echo "$name $?" | tee -a $L/summary.txt; }
: > $L/summary.txt
unset CPATH C_INCLUDE_PATH
mapfile -d '' -t sanitizer_flags < <(./build.sh print-sanitizer-flags)
for t in truth patterns symbols; do
  clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "${sanitizer_flags[@]}" tests/driver/tier1_$t.c -o build/test-driver-tier1-$t
  step driver-tier1-$t ./build/test-driver-tier1-$t "$B" "$(command -v clang)"
done
if [ ! -d build/sqlite/test ]; then bash tools/ci/fetch-sqlite.sh build/sqlite > $L/fetch-sqlite.log 2>&1; fi
directory=$(mktemp -d "build/test sqlite.XXXXXX")
mkdir "$directory/sqlite scripts" "$directory/sqlite tests"
cp tests/sqlite/*.sql "$directory/sqlite scripts/"
printf 'CREATE TABLE t(x);\n' > "$directory/sqlite scripts/silent.sql"
cp build/sqlite/test/*.sql "$directory/sqlite tests/"
step test-sqlite "$B" test-sqlite --clang clang --sqlite "$HOME/.cache/claude-2618/S/corpus/sqlite" --tests "$directory/sqlite tests" --scripts "$directory/sqlite scripts" --directory "$directory"
rm -rf "$directory"
for part in 1 2 3 4; do step checker-driver-$part "$B" test-checker-driver --executable "$B" --part $part/4 --in-process; done
echo done >> $L/summary.txt
