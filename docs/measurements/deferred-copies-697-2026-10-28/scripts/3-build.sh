#!/bin/bash
# The trees: main3 (main MAIN, with items 1 and 4) and each named TREE (main3 with TREE.diff applied), each built by
# Buster's build.sh with BUSTER_DEBUG_INFO=0, as the 9700X job builds it, in a lock hold of its own, with its source
# manifest (build.sh and every file under src/, as record A2's). Arguments: MAIN TREE...
D=~/buster-fast-bench/697-cloud
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-697-cloud
export EXCLUSIVE_TITLE="#697 deferred bodies (cloud session): item 2's builds on the 9700X"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/697"
main="$1"
shift
for t in main3 "$@"; do
    if [ "$t" = main3 ] && [ -x main3/build/compiler ] && [ "$(git -C main3 rev-parse HEAD)" = "$main" ]; then
        continue
    fi
    rm -rf "$t"
    { git init -q --template= "$t" && git -C "$t" fetch -q --depth 1 https://github.com/buster14a/buster.git "$main" && git -C "$t" checkout -q --detach FETCH_HEAD; } || exit 1
    if [ "$t" != main3 ]; then
        (cd "$t" && git apply "../$t.diff") || exit 1
    fi
    (cd "$t" && sha256sum build.sh && find src -type f | LC_ALL=C sort | xargs sha256sum) > "source-$t.sha256"
    echo "== $(date -Is) build $t on $(git -C "$t" rev-parse --short HEAD) $(git -C "$t" status --short | tr '\n' ' ')" >> 3-builds.txt
    (cd "$t" && ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh) >> 3-builds.txt 2>&1
    echo "exit=$? $(date -Is)" >> 3-builds.txt
done
