#!/usr/bin/env bash
# #148's mutation check: each mutant of the new rows, built from a copy of the worktree, must fail test-checker's
# x86 programs. $1: the worktree.
set -uo pipefail
tree="$1"
base=/home/david/.cache/claude-148-sse/mutants
mutate()
{
    local name="$1" from="$2" to="$3"
    local dir="$base/$name"
    rm -rf "$dir" && mkdir -p "$dir"
    (cd "$tree" && git ls-files -z | xargs -0 -I{} cp --parents {} "$dir")
    grep -qF "$from" "$dir/src/buster/compiler/c_check_program_x86.c" || { echo "$name: pattern not found"; return; }
    sed -i "s|$from|$to|" "$dir/src/buster/compiler/c_check_program_x86.c"
    (cd "$dir" && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh > build.log 2>&1) || { echo "$name: build failed"; return; }
    (cd "$dir" && env -u CPATH ./build/compiler test-checker --program-vectors > test.log 2>&1)
    echo "$name: test status $? ($(tail -1 "$dir/test.log"))"
    grep -o "x86-sse[a-z-]*: generated executable agrees[^\"]*" "$dir/test.log" | sort | uniq -c
    grep "x86-sse" "$dir/test.log" | head -4
}
mutate maxps-swapped '"__builtin_ia32_maxps", CHECK_X86_LOWER_BINARY, 4, 16, false, false' '"__builtin_ia32_maxps", CHECK_X86_LOWER_BINARY, 4, 16, false, true'
mutate cvtps2dq-truncating 'X86_FORM_VCVTPS2DQ_X_XM128_EVEX' 'X86_FORM_VCVTTPS2DQ_X_XM128_EVEX'
