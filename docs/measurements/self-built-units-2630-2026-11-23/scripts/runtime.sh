#!/bin/bash
# #2630 step 2's run-time cost: the tests by Develop's clang-built executable (off) and the self-built one (tests), in
# turns, each pass its own hold; then the compile path's user cycles and instructions by time-runs (-c of the frozen
# sqlite3.c, -fsyntax-only of the checker's unit), pinned to CPU 2, each list its own hold. The executables are copies
# in src/build/copies, whose tree's src/buster/include the preprocessor finds.
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
L=$d/scripts/lock.sh; H=$d/scripts/held.sh
out=$d/results
off=$d/src/build/copies/off/compiler
tests=$d/src/build/copies/tests/compiler
for round in 1 2; do
    "$L" "$H" "$out/runtime.log" "$d/scripts/tests.sh" off "$off" "$round"
    "$L" "$H" "$out/runtime.log" "$d/scripts/tests.sh" tests "$tests" "$round"
done
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
cd "$d/src" || exit 2
"$L" "$H" "$out/runtime.log" taskset -c 2 "$off" time-runs --runs 11 --warmups 1 --build off "$off" --build tests "$tests" \
    --list -c "$corpus/sqlite/sqlite3.c" -o /dev/null -march=native
"$L" "$H" "$out/runtime.log" taskset -c 2 "$off" time-runs --runs 11 --warmups 1 --build off "$off" --build tests "$tests" \
    --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main_unit_checker.c
echo runtime-done
