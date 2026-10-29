#!/usr/bin/env bash
# #775's node-order mutant, both of its lines: the calls' first pass keyed by node rather than by end, with the sort's
# `varying` from the same keys. $1: the worktree.
set -uo pipefail
tree="$1"
export CORES_TITLE="#775 target-feature checks: mutants" CORES_LINK="https://github.com/buster14a/buster/issues/775"
dir=/home/david/.cache/claude-775/mutants/node-order
rm -rf "$dir" && mkdir -p "$dir"
(cd "$tree" && git ls-files -z | xargs -0 -I{} cp --parents {} "$dir")
python3 - "$dir/src/buster/compiler/c_check_target_feature.c" <<'PY'
import sys, pathlib
p = pathlib.Path(sys.argv[1]); s = p.read_text()
a = "const uint32_t end = input->graph.tokens[(uint32_t)calls[c]];"
b = "varying |= end ^ input->graph.tokens[(uint32_t)calls[0]];"
assert s.count(a) == 1 and s.count(b) == 1
p.write_text(s.replace(a, "const uint32_t end = (uint32_t)calls[c];").replace(b, "varying |= end ^ (uint32_t)calls[0];"))
PY
(cd "$dir" && BUSTER_DEBUG_INFO=0 LC_NUMERIC=C cores -n 3 -- ./build.sh > build.log 2>&1) || { echo "node-order: build failed"; exit 1; }
(cd "$dir" && env -u CPATH cores -n 1 -- ./build/compiler test-checker-driver --executable ./build/compiler > test.log 2>&1)
echo "node-order: test-checker-driver status $? ($(grep -E 'checks, [0-9]+ failures' "$dir/test.log" | tail -1))"
for f in /tmp/claude-1000/tf/order/for.c /tmp/claude-1000/tf/order/loops.c; do
    ours=$("$dir/build/compiler" -std=gnu17 -march=x86-64 -w -c -o /dev/null "$f" 2>&1 | grep ': error: ' | sed 's/^[^:]*://')
    theirs=$(env -u CPATH clang -std=gnu17 -march=x86-64 -w -fno-caret-diagnostics -c -o /dev/null "$f" 2>&1 | grep ': error: ' | sed 's/^[^:]*://')
    [ "$ours" = "$theirs" ] && echo "node-order: $(basename "$f") as clang" || echo "node-order: $(basename "$f") DIFFERENT"
done
diff -u --label b0d76846/src/buster/compiler/c_check_target_feature.c --label node-order/src/buster/compiler/c_check_target_feature.c "$tree/src/buster/compiler/c_check_target_feature.c" "$dir/src/buster/compiler/c_check_target_feature.c" > /home/david/.cache/claude-775/record/mutants/node-order.diff
rm -rf "$dir/build"
