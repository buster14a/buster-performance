#!/bin/bash
S=/tmp/claude-1000/-home-david-dev-ai-claude-buster--claude-worktrees-issues-764-791-a11500/dd149312-20c0-4fbd-9e60-11bb4742da92/scratchpad
cd "${TREE:-/home/david/dev/ai/claude/buster/.claude/worktrees/issues-764-791-a11500}" || exit 1
F=src/buster/compiler/c_check_target_feature.c
D=src/buster/compiler/c_checker_driver.c
restore() { cp $S/mutants/c_check_target_feature.orig.c $F; cp $S/mutants/c_checker_driver.orig.c $D; }
trap restore EXIT
export CORES_TITLE="solve 137 147 148" CORES_LINK="https://github.com/buster14a/buster/issues/775" BUSTER_DEBUG_INFO=0
for m in ${MUTANTS:-no-predicate prepass one-error order boundary unit-map names message}; do
    restore
    if ! python3 -I $S/mutants/apply.py $m $F $D; then echo "mutant $m: could not apply"; continue; fi
    if ! cores -n 6 -- ./build.sh > $S/mutants/build-$m.log 2>&1; then echo "mutant $m: build failed"; continue; fi
    cores -n 1 -- ./build/compiler test-checker-driver --executable ./build/compiler > $S/mutants/test-$m.log 2>&1
    status=$?
    echo "mutant $m: test status $status, $(grep -E '^checker-driver: [0-9]+ checks' $S/mutants/test-$m.log)"
    grep -E '^test-checker: .*(compare|predicate|side effect|FENV_ACCESS)' $S/mutants/test-$m.log | head -4 | cut -c1-200
done
restore
echo "mutants done"
