#!/bin/bash
# #764's mutation check: each mutant a copy of the PR head's src/ and build.sh with one change undone or broken (an exact
# replacement that must match once), built at -O1 through the cores queue, then test-checker-deferred, which must fail.
set -u
W=/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500
M=~/.cache/claude-764/mutants
L="$M/results.txt"
mutate()
{
    name="$1"; file="$2"; from="$3"; to="$4"
    rm -rf "$M/$name" && mkdir -p "$M/$name" && cp -a "$W/src" "$W/build.sh" "$M/$name/" || return 1
    python3 - "$M/$name/$file" "$from" "$to" <<'PY' || return 1
import sys
path, a, b = sys.argv[1:4]
s = open(path).read()
assert s.count(a) == 1, (path, a)
open(path, 'w').write(s.replace(a, b))
PY
    sed -i 's/^optimization=-O3$/optimization=-O1/' "$M/$name/build.sh" && grep -q '^optimization=-O1$' "$M/$name/build.sh" || return 1
    (cd "$M/$name" && CORES_TITLE="#764 mutation check ($name)" CORES_LINK="https://github.com/buster14a/buster/issues/764" BUSTER_DEBUG_INFO=0 cores -n 4 -- ./build.sh > build.log 2>&1) || { echo "$name: build failed" >> "$L"; return 1; }
    (cd "$M/$name" && nice -n 19 timeout 900 ./build/compiler test-checker-deferred > test.log 2>&1); status=$?
    echo "$name: test-checker-deferred exit=$status, failures: $(grep -c '^test-checker-deferred:' "$M/$name/test.log")" >> "$L"
    grep '^test-checker-deferred:' "$M/$name/test.log" | head -3 >> "$L"
    rm -rf "$M/$name/build"
}
: > "$L"
mutate planned-one src/buster/compiler/c_check_deferred.c \
    '    deferred->planned = check_deferred_rule(deferred, body_tokens, bodies, largest, second,' \
    '    deferred->planned = 1 + 0 * check_deferred_rule(deferred, body_tokens, bodies, largest, second,'
mutate first-head src/buster/compiler/c_check_input.c \
    '    input->rare_columns_shared = deferred != 0 && check_deferred_shared(deferred);' \
    '    input->rare_columns_shared = deferred != 0 && (check_deferred_shared(deferred) || true);'
mutate arena-ignores src/buster/compiler/c_check_input.c \
    '    const uint64_t small = shared ? pages : small_bytes;' \
    '    const uint64_t small = shared ? small_bytes + 0 * pages : small_bytes;'
mutate second-largest src/buster/compiler/c_check_deferred.c \
    '                second = tokens > largest ? largest : tokens > second ? tokens : second;' \
    '                second = tokens > second ? tokens : second;'
echo "done $(date -Is)" >> "$L"
