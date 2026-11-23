#!/bin/bash
# result.sh NAME: waits for run-NAME, prints both tables, the four stages' sums and the objects' hashes.
until timeout 30 tailscale ssh david@benchpress "grep -c exit ~/buster-fast-bench/3393-claude/results/run-$1.log" 2>/dev/null | grep -q '^14$'; do sleep 20; done
timeout 60 tailscale ssh david@benchpress "D=~/buster-fast-bench/3393-claude; for t in main-$1 $1; do echo == \$t; bash \$D/scripts/table.sh \$D/results/\$t | tee /tmp/3393-t.txt | head -10; awk '/^(emit-setup|code-atoms|publish-data|object-build)\t/ {s+=\$2} END {print \"four\", s}' /tmp/3393-t.txt; cat \$D/results/\$t/object.sha256; done"
