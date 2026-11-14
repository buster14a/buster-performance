#!/bin/bash
# unpack.sh ARCHIVE: extracts a .tar.zst of compilers into local/ and refreshes SHA256SUMS, under one lock grant.
cd ~/buster-fast-bench/1489-claude/local || exit 2
EXCLUSIVE_OWNER=claude-1489 EXCLUSIVE_TITLE="Solve 1489 (check-input growth)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1489 \
    ~/buster-fast-bench/exclusive.sh bash -c "zstd -d -q < '$1' | tar xf - && sha256sum compiler-local-* > SHA256SUMS"
status=$?
[ $status = 0 ] && rm -f "$1"
for f in compiler-local-*; do ln -sfn ../../local/$f ../root/bin/$f; done
exit $status
