#!/bin/bash
# #2630 step 1, completed: the Tier 1 self-build of selfbuild.sh given the release's predefines (clang -dM -E with the
# units' own flags, CI's Clang 23.1.4), its executable placed as the ci2630 tree's Release executable (the original kept
# beside it), then the 4 commands that failed in inventory2630.sh, then (with "all") the whole inventory in SHARDS
# shards. Each step its own hold of the lock.
#   selftree.sh build | failed | all | restore
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2626-claude
L=$d/scripts/lock.sh
out=$d/selfp
ci=$d/ci2630
results=$d/results/inventory2630p
shards=${SHARDS:-12}
mkdir -p "$out/t1" "$results" "$d/tmp"
. "$d/scripts/env.sh"
export BUSTER_DEBUG_INFO=0 BUSTER_ORACLE_CACHE=use
export BUSTER_CI_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/buster/ci"
export BUSTER_CORPUS=/var/lib/buster-9700x/corpora/preprocessor-391e729af658 BUSTER_PPF_PRAGMA_ORACLE="$d/preprocessor-pragma-oracle"
cd "$ci" || exit 2
product=$(./build.sh print-output --config Release)
case "${1:-}" in
    build)
        cp "$d/self/options.txt" "$d/self/sources.txt" "$out/"
        mapfile -t options < "$out/options.txt"
        clang --version | head -1 > "$out/clang.txt"
        (cd "$d/base" && clang -dM -E "${options[@]}" -x c /dev/null) > "$out/predefines.h"
        grep -c . "$out/predefines.h"
        cat > "$out/compile.sh" <<'INNER'
#!/bin/bash
out=$1
cd "$(dirname "$out")/base" || exit 2
compile_one()
{
    local name
    name=$(basename "$1" .c)
    mapfile -t options < "$out/options.txt"
    if "$(dirname "$out")/placements/base/compiler-0" --tier1 --predefines "$out/predefines.h" "${options[@]}" -c -o "$out/t1/$name.o" "$1" > "$out/t1/$name.log" 2>&1; then echo "ok $name"; else echo "FAILED $name"; fi
}
export -f compile_one
export out
xargs -a "$out/sources.txt" -P 8 -I{} bash -c 'compile_one "$@"' _ {} > "$out/compile.txt"
INNER
        chmod +x "$out/compile.sh"
        "$L" "$out/compile.sh" "$out"
        echo "compiled $(grep -c '^ok' "$out/compile.txt"), failed $(grep -c FAILED "$out/compile.txt")"
        rewritten=$(sed "s|$d/self/t1/|$out/t1/|g; s|-o $d/self/stage2-t1|-o $out/stage2-t1p|" "$d/self/link.txt")
        printf '%s\n' "$rewritten" > "$out/link.txt"
        tree=$(dirname "$(dirname "$(cd "$d/base" && ./build.sh print-output --config Release)")")
        "$L" bash -c "cd '$tree' && $rewritten" > "$out/link.log" 2>&1
        echo "link $?"
        [ -e "$product.clang" ] || cp -p "$product" "$product.clang"
        cp "$out/stage2-t1p" "$product"
        sha256sum "$out/stage2-t1p" "$product" "$product.clang" build/compiler | tee "$out/placed.txt"
        ;;
    failed)
        awk '/^== /{keep = ($0 ~ /^== (Check unity fixture ownership without rebuilding|Test integer builtin actions against Clang \(part [23] of 4\)|Test the preprocessor.s cases against clang \(part 1 of 4\))$/)} keep' tools/ci/correctness.tests > "$out/failed.tests"
        grep '^== ' "$out/failed.tests"
        "$L" bash -c 'taskset -c 0-7 "$1" parallel --jobs 8 --timeout 600 < "$2" > "$3/failed.log" 2>&1; echo "status $?" >> "$3/failed.log"' failed "$product" "$out/failed.tests" "$results"
        tail -6 "$results/failed.log"
        ;;
    all)
        sha256sum "$product" > "$results/compiler.sha256"
        for k in $(seq 1 "$shards"); do
            "$L" bash -c 'taskset -c 0-7 "$1" parallel --jobs 8 --timeout 600 --shard "$2/$3" --costs tools/ci/costs/vector-none-O3.costs < tools/ci/correctness.tests > "$4/shard-$2-of-$3.log" 2>&1; echo "status $?" >> "$4/shard-$2-of-$3.log"' shard "$product" "$k" "$shards" "$results"
            tail -1 "$results/shard-$k-of-$shards.log"
        done
        grep -h '^parallel: .* commands in ' "$results"/shard-*.log | awk '{c += $2; p += $(NF-9)} END {print c " commands"}'
        grep -h ' failed (exit status' "$results"/shard-*.log | sort -u
        echo inventory-done
        ;;
    restore)
        cp "$product.clang" "$product" && rm "$product.clang" && sha256sum "$product" build/compiler
        ;;
    *) echo "usage: selftree.sh build | failed | all | restore" >&2; exit 2 ;;
esac
