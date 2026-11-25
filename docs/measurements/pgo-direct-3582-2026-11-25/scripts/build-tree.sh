#!/bin/bash
# build-tree.sh TREE MODE NAME: trees/TREE built as the 9700X job builds (znver5 Release, no debug information), with
# BUSTER_PGO=1 when MODE is pgo, copied to bin/compiler-NAME. Run under exclusive.sh, one build a hold.
set -euo pipefail
here=$HOME/buster-fast-bench/3582-claude
tree=$1 mode=$2 name=$3
cd "$here/trees/$tree"
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
unset BUSTER_PGO BUSTER_PGO_CORPUS
case "$mode" in pgo) export BUSTER_PGO=1 ;; pgo-corpus) export BUSTER_PGO=1 BUSTER_PGO_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658 ;; esac
start=$(date +%s.%N)
./build.sh --config Release > "$here/results/build-$name.log" 2>&1
end=$(date +%s.%N)
cp "$(./build.sh print-output --config Release)" "$here/bin/compiler-$name"
echo "build-$name: $(git log --oneline -1 | cut -c1-60) mode=$mode seconds=$(awk -v a="$start" -v b="$end" 'BEGIN{printf "%.1f", b-a}')"
"$here/bin/compiler-$name" --version | head -1
grep -E "merged [0-9]+ profiles|Training the direct|units compiled" "$here/results/build-$name.log" || true
tail -2 "$here/results/build-$name.log"
