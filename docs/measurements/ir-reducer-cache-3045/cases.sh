#!/usr/bin/env bash
set -euo pipefail
inputs=$1
out=$2
revision=$3
mkdir -p "$out"
run()
{
    local name=$1 rc=0
    shift
    ./build/compiler reduce-ir --revision "$revision" --output "$out/$name" --milliseconds 120000 --predicate-ms 5000 --max-candidates 6000 "$@" > "$out/$name.out" 2> "$out/$name.err" || rc=$?
    echo "$rc" > "$out/$name.rc"
    printf '\n%s exit=%s\n' "$name" "$rc"
    cat "$out/$name.out"
    awk '/^cache-work / || /^ir-reduce:/{print}' "$out/$name.err"
    if [[ -f "$out/$name/result.json" ]]; then
        jq -c '{status,failure,original,reduced,work,replayed}' "$out/$name/result.json"
        sha256sum "$out/$name/reduced.ir"
    else
        test ! -e "$out/$name"
    fi
    awk '/^observe /{print}' "$out/$name.err" > "$out/$name.order"
}
run real-natural --arg 5 --arg 2 --arg 1 --arg 8 "$inputs/real.ir"
run real --inject verify-phi "$inputs/real.ir"
run stress --inject memory-store --passes 0 --frames 2 --arg 0 "$inputs/stress.ir"
run exhausted --inject memory-store --passes 0 --frames 2 --arg 0 --memory 4194304 "$inputs/stress.ir"
run rejected --inject memory-store --passes 0 --frames 2 --arg 1 "$inputs/stress.ir"
test "$(cat "$out/real.rc")" = 0
test "$(cat "$out/stress.rc")" = 0
test "$(cat "$out/exhausted.rc")" = 0
test "$(cat "$out/rejected.rc")" = 2
jq -e '.status == 0 and .work.predicates >= 200 and .work.cache_hits > 0 and .work.accepted > 0' "$out/stress/result.json" > /dev/null
jq -e '.status == 3' "$out/exhausted/result.json" > /dev/null
