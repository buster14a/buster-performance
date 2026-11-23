#!/usr/bin/env bash
# run.sh BASE_COMMIT: the whole record, each step in lock holds of its own. The tree is a clone of buster at BASE_COMMIT
# with head.patch applied as the head; the corpus is CI's (fetch-corpus.sh).
set -u
source "$(dirname "$0")/common.sh"
cd $W || exit 1
mkdir -p out
echo "start $(date -u +%FT%TZ)" >> progress.txt
[ -d tree ] || { git init -q tree && git -C tree remote add origin https://github.com/buster14a/buster; }
git -C tree fetch -q --depth 1 origin "$1"
[ -d corpus ] || BUSTER_CI_CACHE=$HOME/.cache/buster/ci bash tree/tools/ci/fetch-corpus.sh corpus > out/corpus.log 2>&1
./build.sh base "$1"; echo "built base $(date -u +%FT%TZ)" >> progress.txt
git -C tree checkout -q --detach "$1" && git -C tree -c user.name=claude -c user.email=noreply@anthropic.com am -q < head.patch && git -C tree rev-parse HEAD > head-commit.txt
./build.sh head "$(cat head-commit.txt)"; echo "built head $(date -u +%FT%TZ)" >> progress.txt
rm -rf tree/build/cmake
{ uname -a; $CLANG --version | head -1; perf --version; grep -m1 'model name' /proc/cpuinfo; echo "governor cpu2: $(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor)"; cat out/commit-*.txt; sha256sum bin/*; } > out/env.txt 2>&1
./zen5.sh; echo "zen5 $(date -u +%FT%TZ)" >> progress.txt
./forms.sh; echo "forms $(date -u +%FT%TZ)" >> progress.txt
./kernels.sh; echo "kernels $(date -u +%FT%TZ)" >> progress.txt
./compile.sh; echo "compile $(date -u +%FT%TZ)" >> progress.txt
./programs.sh base; echo "programs base $(date -u +%FT%TZ)" >> progress.txt
./programs.sh head; echo "programs head $(date -u +%FT%TZ)" >> progress.txt
echo done > run.done
