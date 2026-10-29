#!/bin/bash
# #847's mutation check of the claims (f3ac8f15): each mutant a copy of the commit's src/ and build.sh with one change undone or broken (an exact
# replacement that must match once), built at -O1 through the cores queue, then test-checker-deferred, which must fail.
# Arguments: the worktree.
set -u
W="$1"
M=~/.cache/claude-764/mutants847c
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
    (cd "$M/$name" && CORES_TITLE="#847 mutation check ($name)" CORES_LINK="https://github.com/buster14a/buster/issues/847" BUSTER_DEBUG_INFO=0 cores -n 4 -- ./build.sh > build.log 2>&1) || { echo "$name: build failed" >> "$L"; return 1; }
    (cd "$M/$name" && CORES_TITLE="#847 mutation check ($name)" CORES_LINK="https://github.com/buster14a/buster/issues/847" cores -n 4 -- nice -n 19 timeout 1800 ./build/compiler test-checker-deferred > test.log 2>&1); status=$?
    echo "$name: test-checker-deferred exit=$status, $(grep -E '^test-checker-deferred: [0-9]+ fixtures' "$M/$name/test.log")" >> "$L"
    grep '^test-checker-deferred:' "$M/$name/test.log" | grep -v ' fixtures, ' | head -3 >> "$L"
    rm -rf "$M/$name/build"
}
: > "$L"
mutate no-claim src/buster/compiler/c_check_input.c \
    '    if (claims != 0)
    {
        uint32_t* const claim' \
    '    if (claims != 0 && false)
    {
        uint32_t* const claim'
mutate claims-not-given src/buster/compiler/c_check_deferred.c \
    '    reader->rare_claims = claims;' \
    '    reader->rare_claims = 0;'
mutate claims-any-size src/buster/compiler/c_check_deferred.c \
    'valid && active > 1 && !input->rare_columns_shared && regions != 0' \
    'valid && active > 1 && regions != 0'
mutate shared-any-size src/buster/compiler/c_check_deferred.c \
    '    return deferred->planned > 1 && deferred->large;' \
    '    return deferred->planned > 1 && (deferred->large || true);'
mutate constants-one-pair src/buster/compiler/c_check_deferred.c \
    '    return large ? BUSTER_CHECK_DEFERRED_BASE_LANE_TOKENS + top_tokens / BUSTER_CHECK_DEFERRED_BASE_LANE_TOP_TOKENS' \
    '    return (large || true) ? BUSTER_CHECK_DEFERRED_BASE_LANE_TOKENS + top_tokens / BUSTER_CHECK_DEFERRED_BASE_LANE_TOP_TOKENS'
mutate size-knob-ignored src/buster/compiler/c_check_deferred.c \
    '    deferred->large = count >= (deferred->base_page_tokens != 0 ? deferred->base_page_tokens : BUSTER_CHECK_DEFERRED_BASE_PAGE_TOKENS);' \
    '    deferred->large = count >= (deferred->base_page_tokens != 0 ? BUSTER_CHECK_DEFERRED_BASE_PAGE_TOKENS : BUSTER_CHECK_DEFERRED_BASE_PAGE_TOKENS);'
echo "done $(date -Is)" >> "$L"
