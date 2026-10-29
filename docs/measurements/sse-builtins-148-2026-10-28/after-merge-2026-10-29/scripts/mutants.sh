#!/usr/bin/env bash
# #759's review: a mutant whose ldmxcsr encodes as stmxcsr, so that our code converts in MXCSR's default mode whatever
# the program sets, must fail x86-sse with its new block (new) and passes without it (old). $1: the worktree.
set -uo pipefail
tree="$1"
export CORES_TITLE="#759 review: MXCSR mutants" CORES_LINK="https://github.com/buster14a/buster/pull/759"
base=/home/david/.cache/claude-759r/mutants
run()
{
    local name="$1" old_test="$2"
    local dir="$base/$name"
    rm -rf "$dir" && mkdir -p "$dir"
    (cd "$tree" && git ls-files -z | xargs -0 -I{} cp --parents {} "$dir")
    if [ "$old_test" = 1 ]; then (cd "$tree" && git show HEAD:src/buster/compiler/c_check_program_x86_test.c) > "$dir/src/buster/compiler/c_check_program_x86_test.c"; fi
    local from='X(LDMXCSR_M32, "ldmxcsr", 0, 2, 0x0fae, D2,' to='X(LDMXCSR_M32, "ldmxcsr", 0, 2, 0x0fae, D3,'
    [ "$(grep -cF "$from" "$dir/src/buster/compiler/x86_64_encoder.c")" = 1 ] || { echo "$name: pattern not found once"; return; }
    sed -i "s|$from|$to|" "$dir/src/buster/compiler/x86_64_encoder.c"
    (cd "$dir" && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C cores -n 4 -- ./build.sh > build.log 2>&1) || { echo "$name: build failed"; return; }
    (cd "$dir" && env -u CPATH cores -n 4 -- ./build/compiler test-checker --program-vectors > test.log 2>&1)
    echo "$name: test-checker --program-vectors status $? ($(tail -1 "$dir/test.log"))"
    grep -n "x86-sse" "$dir/test.log" | head -6
}
run new 0 &
run old 1 &
wait
