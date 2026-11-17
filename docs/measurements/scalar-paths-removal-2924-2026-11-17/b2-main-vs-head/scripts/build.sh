#!/bin/bash
# #2924 phase B2's PR measurement, step 1: main's and the head's Release builds (native, the 9700X's), each under the
# lock. The head comes from the bundle beside this script (B2 isn't pushed until #2939 merges).
set -euo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: B2 main vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p compilers logs
if [ ! -d src ]; then git clone -q https://github.com/buster14a/buster src; fi
git -C src fetch -q origin main claude/wonderful-wozniak-vbfba7
git -C src fetch -q "$D/b2.bundle" "+refs/heads/b2:refs/heads/b2"
main=$(git -C src rev-parse "${MAIN:-origin/main}")
head=$(git -C src rev-parse b2)
printf 'main %s\nhead %s\n' "$main" "$head" > logs/commits.txt
cd src
for side in main head; do
    git checkout -q --detach "$(eval echo \$$side)"
    $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-$side.log" 2>&1
    cp build/compiler "$D/compilers/$side"
done
cd "$D"
sha256sum compilers/* > logs/compilers.sha256
date -u +%FT%TZ > logs/.built
