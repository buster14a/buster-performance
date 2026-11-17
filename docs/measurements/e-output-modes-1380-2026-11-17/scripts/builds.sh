#!/bin/bash
set -euo pipefail
cd ~/buster-fast-bench/1380-claude
export EXCLUSIVE_OWNER=claude-1380 EXCLUSIVE_TITLE="Solve 1380" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1380
for tree in base head; do
    echo "== $tree $(date -u +%FT%TZ)"
    (cd "$tree" && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release)
    echo "== $tree built $(date -u +%FT%TZ): $(ls -la $tree/build/compiler)"
done
echo done
