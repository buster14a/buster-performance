#!/bin/bash
# per round/tree: list medians (wall, user cycles, instructions)
awk '/^== round/ {round=$3; tree=$5} /^list [0-9] \[/ { n=$2; m=$0; sub(/.*\]: /,"",m); print round, tree, "list" n, m }' ~/buster-fast-bench/2301-claude-d6/ab.log
