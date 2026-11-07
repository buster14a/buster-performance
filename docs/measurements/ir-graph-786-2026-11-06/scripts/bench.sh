#!/bin/bash
# 786-claude: benchmark-ir and benchmark-ir-optimize of each tree's shifted builds, pinned to CPU 2. One hold of the
# 9700X's lock per round runs every placement of every tree back to back (about a second a run, a minute a round): the
# placements' order rotates by round, the trees' by placement and round.
#   ./bench.sh OUT ROUNDS TREE...   (shifts-TREE/compiler-SHIFT for SHIFT in $SHIFTS)
set -u
cd ~/buster-fast-bench/786-claude
export EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="Solve 786 (IR verifier/CFG/optimizer placements)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786
if [ "$1" = --round ]; then
    # Under the lock: OUT ROUND TREE...
    out=$2 round=$3
    shift 3
    trees=("$@")
    shifts=(${SHIFTS:-0 640 1344 2048 2752 3456})
    for ((s = 0; s < ${#shifts[@]}; s += 1)); do
        bytes=${shifts[$(((s + round) % ${#shifts[@]}))]}
        for ((t = 0; t < ${#trees[@]}; t += 1)); do
            tree=${trees[$(((t + s + round) % ${#trees[@]}))]}
            exe=shifts-$tree/compiler-$bytes
            for bench in ${BENCHES:-ir optimize}; do
                file=$out/$tree-$bytes-$round-$bench.txt
                case $bench in
                    ir) taskset -c 2 "$exe" benchmark-ir > "$file" 2>&1 ;;
                    optimize) taskset -c 2 "$exe" benchmark-ir-optimize > "$file" 2>&1 ;;
                esac
                echo "$(date +%T) round $round shift $bytes $tree $bench status $?"
            done
        done
    done
    exit 0
fi
out=$1 rounds=$2
shift 2
mkdir -p "$out"
for ((round = 0; round < rounds; round += 1)); do
    ~/buster-fast-bench/exclusive.sh ./bench.sh --round "$out" "$round" "$@"
done
echo bench-done
