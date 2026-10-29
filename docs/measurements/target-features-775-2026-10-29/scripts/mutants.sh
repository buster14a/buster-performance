#!/usr/bin/env bash
# #775's mutation check: each mutant, built from a copy of the worktree with one part of the check undone, must fail
# test-checker-driver's target-feature sections. $1: the worktree.
set -uo pipefail
tree="$1"
export CORES_TITLE="#775 target-feature checks: mutants" CORES_LINK="https://github.com/buster14a/buster/issues/775"
base=/home/david/.cache/claude-775/mutants
mutate()
{
    local name="$1" file="$2" from="$3" to="$4" expected="$5"
    local dir="$base/$name"
    rm -rf "$dir" && mkdir -p "$dir"
    (cd "$tree" && git ls-files -z | xargs -0 -I{} cp --parents {} "$dir")
    local found
    found=$(grep -cF -- "$from" "$dir/$file")
    [ "$found" = "$expected" ] || { echo "$name: pattern found $found times, wanted $expected"; return; }
    python3 - "$dir/$file" "$from" "$to" <<'PY'
import sys, pathlib
p = pathlib.Path(sys.argv[1]); s = p.read_text(); p.write_text(s.replace(sys.argv[2], sys.argv[3]))
PY
    (cd "$dir" && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C cores -n 3 -- ./build.sh > build.log 2>&1) || { echo "$name: build failed"; tail -3 "$dir/build.log"; return; }
    (cd "$dir" && env -u CPATH cores -n 1 -- ./build/compiler test-checker-driver --executable ./build/compiler > test.log 2>&1)
    echo "$name: test-checker-driver status $? ($(grep -E 'checks, [0-9]+ failures' "$dir/test.log" | tail -1))"
    grep -E "^test-checker-driver: .*(target|clang's|-c's|errors are|the first function|deferred|argument|flatten|address|declared|dead|intrinsic|arch=)" "$dir/test.log" | head -4
    rm -rf "$dir/build"
}
F=src/buster/compiler/c_check_target_feature.c
D=src/buster/compiler/c_checker_driver.c
mutate no-check $F 'if (program->attribute_keys != 0 && options != NULL)' 'if (false && program->attribute_keys != 0 && options != NULL)' 1 &
mutate callee-limit $F 'object != 0 ? check_target_feature_attributes(program, object, token)' 'object != 0 ? check_target_feature_attributes(program, object, UINT32_MAX)' 1 &
mutate indirect-direct $F 'graph->ops[callee] == CHECK_OP_VALUE && value.category == CHECK_FUNCTION' 'value.category == CHECK_FUNCTION' 1 &
wait
mutate source-order $F 'if (external == (deferred == 0))' 'if ((external || true) == (deferred == 0))' 1 &
mutate no-flatten $F ' || (caller->flatten && (caller->targeted || callee->targeted))' '' 1 &
wait
mutate no-caller-branch $F 'else if (object != 0 && check_target_feature_checked(caller, &callee) && caller->targeted && !caller->versions)' 'else if (false && object != 0 && check_target_feature_checked(caller, &callee) && caller->targeted && !caller->versions)' 1 &
mutate table-order $F 'return result >= 0 ? result : first;' 'return first;' 1 &
mutate publication-at-call $D 'publication, PP_DIAGNOSTIC_DEFERRED, "%s", message);' 'parser->tokens.sources[error->token] + 0 * publication, PP_DIAGNOSTIC_SEMANTIC, "%s", message);' 1 &
wait
mutate no-stop $F '(deferred != 0 || *count == 0)' 'true' 1 &
mutate deferred-after-errors $F 'valid && *count == 0 && deferred < 2' 'valid && deferred < 2' 1 &
mutate stop-deferred $F '(deferred != 0 || *count == 0)' '(*count == 0)' 1 &
wait
mutate answer-kept-false $F 'answer->fails = keyed && plain ? candidate : answer->fails;' 'answer->fails = keyed && plain ? false : answer->fails;' 1 &
mutate caller-never-keyed $F 'const bool keyed_caller = body->object < program->object_count &&' 'const bool keyed_caller = false && body->object < program->object_count &&' 1 &
P=src/buster/compiler/c_check_program.c
mutate statement-order-dropped $F 'const uint32_t statement = (uint32_t)(calls[(uint32_t)by_end[j]] >> 32);' 'const uint32_t statement = 0;' 1 &
mutate region-statement-own $F 'walk.tag = control < body->entry_count ? control + 1 : (uint32_t)(entry >> 32);' 'walk.tag = control != UINT32_MAX ? control + 1 : (uint32_t)(entry >> 32);' 1 &
wait
mutate inline-bit-dropped $P 'kind == CHECK_ATTRIBUTE_ALWAYS_INLINE || kind == CHECK_ATTRIBUTE_FLATTEN ? BUSTER_CHECK_PROGRAM_ATTRIBUTE_INLINE : 0;' 'kind == CHECK_ATTRIBUTE_FLATTEN ? BUSTER_CHECK_PROGRAM_ATTRIBUTE_INLINE : 0;' 1 &
wait
# The calls' first pass by node rather than by end, with the sort's `varying` from the same keys: two lines, so a script
# of its own.
"$(dirname "$0")/mutant-node-order.sh" "$tree"
echo done
