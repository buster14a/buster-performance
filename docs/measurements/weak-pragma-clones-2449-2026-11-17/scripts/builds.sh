#!/bin/bash
# #2449's trees on the 9700X: base is main 2d817432, head is the PR's merge of it (b2aa1e3f). Each build is one hold.
set -euo pipefail
cd ~/buster-fast-bench/2449-claude
export EXCLUSIVE_OWNER=claude-2449 EXCLUSIVE_TITLE="Solve 2449 (#2896)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2896
for pair in base:2d817432864947a0853abd1e79879b0086fbd9b7 head:b2aa1e3f12ccaaaa00d94810350f9ea70802c3e3; do
    tree=${pair%%:*}; commit=${pair#*:}
    if [ ! -d "$tree" ]; then git clone -q https://github.com/buster14a/buster "$tree"; fi
    git -C "$tree" fetch -q origin "$commit" && git -C "$tree" checkout -q --detach "$commit"
    echo "== $tree $(git -C "$tree" rev-parse HEAD) $(date -u +%FT%TZ)"
    (cd "$tree" && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > "build-$tree.log" 2>&1 || echo "$tree build failed"
    echo "== $tree built $(date -u +%FT%TZ): $(ls -la $tree/build/compiler)"
done
echo builds-done
