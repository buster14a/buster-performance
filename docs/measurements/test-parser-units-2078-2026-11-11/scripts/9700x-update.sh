#!/bin/bash
# Moves head to 1c835d9, rebuilds it under the lock, writes the units list and predefines, then runs run.sh.
D=~/buster-fast-bench/2078-claude
export EXCLUSIVE_OWNER=claude-2078 EXCLUSIVE_TITLE="Cut test-parser's own time, CI's longest command (#2078)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2087
cd $D
mkdir -p first-head-8adcc8b && mv -n results.tsv log-* stat-* time-* status-* first-head-8adcc8b/ 2>/dev/null
git -C head fetch -q --depth 1 https://github.com/buster14a/buster 1c835d97c05a1c3dd0a95183844704ded7f6085f && git -C head checkout -q FETCH_HEAD || exit 1
echo "head $(git -C head rev-parse HEAD)"
cd $D/head && ~/buster-fast-bench/exclusive.sh ./build.sh > $D/build-head-2.log 2>&1; echo "build exit $? $(tail -1 $D/build-head-2.log)"
cd $D/base && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > $D/predefines.h
./build.sh print-sources | tr '\0' '\n' | grep -v '/main_unit_' | grep -v '^$' > $D/units.txt; echo "units $(wc -l < $D/units.txt)"
sha256sum $D/base/build/compiler $D/head/build/compiler $D/predefines.h
cd $D && ./run.sh
