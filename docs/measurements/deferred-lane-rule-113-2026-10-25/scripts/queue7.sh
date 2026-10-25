#!/bin/bash
# #113's deferred lanes from the bodies' work, with the benchmark's six orders (balanced: 8c538df3): eight lanes against
# one by the rule (balanced) and by main's rule, every lane the bodies can take (balanced-every, --every-lane), on all
# 35 units, each unit and run in a process of its own (runs.sh); a lock hold covers one round of every unit (about
# 60 s), the units' and runs' order rotating by round. Then queue8.sh.
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes from body work: balanced before and after"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6402314088"
L="$D/log7.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/round7.sh" << 'INNER'
#!/bin/bash
# One round of every unit's two runs: LOG ROUND.
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
round="$2"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
units=(
    inputs/00001.c inputs/00169.c inputs/00213.c inputs/00200.c inputs/00182.c inputs/00204.c sqlite
    synthetic/h16x1.c synthetic/h16x2.c synthetic/h16x5.c synthetic/h16x10.c synthetic/h16x19.c synthetic/h16x38.c synthetic/h16x77.c
    synthetic/h16x154.c synthetic/h2x40.c synthetic/h2x80.c synthetic/h2x160.c synthetic/h64x1.c synthetic/h64x3.c synthetic/h64x10.c
    synthetic/b16x5.c synthetic/b16x19.c synthetic/b16x77.c synthetic/h2x240.c synthetic/h2x320.c synthetic/h2x480.c
    synthetic/x16x10.c synthetic/x16x19.c synthetic/x16x38.c synthetic/x16x77.c synthetic/l16x19f192.c synthetic/l16x38f192.c
    synthetic/l16x38f384.c synthetic/l16x77f384.c
)
count=${#units[@]}
for ((i = 0; i < count; i += 1)); do
    unit="${units[$(((i + (round - 1) * 5) % count))]}"
    passes=24
    file="$D/$unit"
    if [ "$unit" = sqlite ]; then
        passes=12
        file="$corpus/sqlite/sqlite3.c"
    fi
    if [ $(((i + round) % 2)) = 0 ]; then
        "$D/runs.sh" "$L" "$round" "$unit" "$file" "$passes" balanced:8 balanced:8:every
    else
        "$D/runs.sh" "$L" "$round" "$unit" "$file" "$passes" balanced:8:every balanced:8
    fi
done
INNER
chmod +x "$D/round7.sh"
for round in 1 2 3 4 5; do
    ~/buster-fast-bench/exclusive.sh "$D/round7.sh" "$L" "$round" > /dev/null 2>> "$D/queue7.lock.txt"
    sleep 30
done
echo done >> "$L"
exec "$D/queue8.sh"
