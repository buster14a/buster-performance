#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
root=$(pwd)
mkdir -p logs
export EXCLUSIVE_OWNER=codex-593
export EXCLUSIVE_TITLE="Buster #593 string initializer scaling"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/593
lock="$HOME/buster-fast-bench/exclusive.sh"
"$lock" bash ./setup.sh > logs/setup.log 2> logs/setup-lock.log
id=0
for kind in strings repeated wide records pointers characters integers; do
    for n in 20000 40000 80000 160000; do
        versions=(base head)
        if (( (id + n / 20000) % 2 != 0 )); then versions=(head base); fi
        for version in "${versions[@]}"; do
            echo "measure kind=$kind count=$n version=$version"
            "$lock" taskset -c 2 "../$version/build/compiler" measure-compile --runs 3 --warmups 1 \
                --reference /usr/bin/tcc --directory "$root/tmp" -- -c "$root/inputs/$kind-$n.c" \
                > "logs/$kind-$n-$version.log" 2> "logs/$kind-$n-$version-lock.log"
        done
        echo "qualify kind=$kind count=$n"
        "$lock" taskset -c 2 bash ./qualify.sh "$kind" "$id" "$n" \
            > "logs/$kind-$n-verify.log" 2> "logs/$kind-$n-verify-lock.log"
    done
    id=$((id + 1))
done
echo 'campaign status=0'
