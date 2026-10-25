#!/bin/bash
# #113's deferred lanes from the bodies' work, with the benchmark's six orders (balanced: 8c538df3): the grid again on
# the units around the rule's steps, every lane the bodies can take (--every-lane) on 2, 3, 4 and 8 lanes against one,
# each unit and lane count in a process of its own (runs.sh); a lock hold covers one round of every unit, the order
# rotating by round. Then queue7.sh and queue8.sh.
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes from body work: balanced grid"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6402314088"
L="$D/log6.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/round6.sh" << 'INNER'
#!/bin/bash
# One round of every unit's lane counts: LOG ROUND.
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
round="$2"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
units=(
    inputs/00204.c synthetic/b16x5.c synthetic/h16x10.c synthetic/x16x10.c synthetic/h64x3.c synthetic/l16x19f192.c
    synthetic/l16x38f384.c synthetic/h2x240.c synthetic/h2x480.c synthetic/b16x19.c synthetic/h16x19.c synthetic/x16x19.c
    synthetic/l16x38f192.c synthetic/h16x38.c synthetic/x16x38.c synthetic/h64x10.c synthetic/l16x77f384.c synthetic/h16x77.c
    synthetic/x16x77.c synthetic/b16x77.c synthetic/h16x154.c sqlite
)
lanes=(2 3 4 8)
count=${#units[@]}
for ((i = 0; i < count; i += 1)); do
    unit="${units[$(((i + (round - 1) * 7) % count))]}"
    passes=24
    file="$D/$unit"
    if [ "$unit" = sqlite ]; then
        passes=12
        file="$corpus/sqlite/sqlite3.c"
    fi
    runs=()
    for ((j = 0; j < 4; j += 1)); do
        runs+=("balanced:${lanes[$(((j + round - 1) % 4))]}:every")
    done
    "$D/runs.sh" "$L" "$round" "$unit" "$file" "$passes" "${runs[@]}"
done
INNER
chmod +x "$D/round6.sh"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/round6.sh" "$L" "$round" > /dev/null 2>> "$D/queue6.lock.txt"
    sleep 30
done
echo done >> "$L"
exec "$D/queue7.sh"
