#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/buster-fast-bench/1219-codex"
export S=$PWD
export EXCLUSIVE_OWNER=codex-1219 EXCLUSIVE_TITLE='Issue 1219 integration baseline' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1419
(cd latest-base && "$HOME/buster-fast-bench/exclusive.sh" env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --jobs 8) > latest-base-build.log 2>&1
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 bash scripts/progs.sh "$PWD/latest-base/build/compiler" "$PWD/results/latest-base"
printf '%s\n' 1bfc57eedf9c2fc3deb5a71a22b7c2a4f01ee29f > results/latest-base/source.txt
sha256sum latest-base/build/compiler results/latest-base/{st-t1,lua-t1} > latest-base-binaries.sha256
touch latest-base-programs.done
"$HOME/buster-fast-bench/exclusive.sh" taskset -c 2 latest-base/build/compiler measure-tier1-programs --runs 11 --warmups 1 --clang /usr/bin/clang --sqlite "$PWD/corpus/sqlite" --speedtest "$PWD/inputs/st" --lua "$PWD/inputs/lua/lua-5.4.8/src" --scripts "$PWD/inputs/lua" --directory /dev/shm --keep > latest-base-runtime.log 2>&1
touch latest-base-runtime.done
