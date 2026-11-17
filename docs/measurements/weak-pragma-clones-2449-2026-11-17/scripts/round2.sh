#!/bin/bash
# #2449 round 2: head is 2560a51d (b2aa1e3f plus CheckInputReader.name_hooks). Builds it, then measures as measure.sh
# did, into results2.
set -uo pipefail
cd ~/buster-fast-bench/2449-claude
export EXCLUSIVE_OWNER=claude-2449 EXCLUSIVE_TITLE="Solve 2449 (#2896)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2896
git -C head fetch -q origin 2560a51d36a75ba20a40f30770a5b302694258f4 && git -C head checkout -q --detach 2560a51d36a75ba20a40f30770a5b302694258f4 || { echo "head checkout failed"; exit 1; }
echo "== head $(git -C head rev-parse HEAD) $(date -u +%FT%TZ)"
(cd head && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > build-head2.log 2>&1 || { echo "head build failed"; exit 1; }
echo "== head built $(date -u +%FT%TZ): $(ls -la head/build/compiler)"
sed 's|results/|results2/|g; s|mkdir -p results |mkdir -p results2 |' measure.sh > measure2.sh && chmod +x measure2.sh && ./measure2.sh
