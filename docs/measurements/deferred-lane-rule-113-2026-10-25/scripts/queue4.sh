#!/bin/bash
# #113's deferred lanes from the bodies' work, after queue1.sh: units around the threshold that queue1's grid leaves
# open, on probe (14d59dad, main's rule). Two equal bodies of 12,485, 16,645 and 24,965 tokens (gen.c 2 240, 320 and
# 480), and sixteen of 525 to 4,009 tokens after thirty of the C library's headers (gen.c 16 S heavy), each unit and lane
# count in a process of its own (runs.sh); a lock hold covers one round of every unit, the order rotating by round.
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
while kill -0 2001228 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes from body work: threshold units"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6402314088"
L="$D/log4.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/round4.sh" << 'EOF'
#!/bin/bash
# One round of every unit's lane counts: LOG ROUND.
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
round="$2"
units=(
    synthetic/h2x240.c:2,8 synthetic/h2x320.c:2,8 synthetic/h2x480.c:2,8
    synthetic/x16x10.c:2,3,4,8 synthetic/x16x19.c:2,3,4,8 synthetic/x16x38.c:2,3,4,8 synthetic/x16x77.c:2,3,4,8
)
count=${#units[@]}
for ((i = 0; i < count; i += 1)); do
    entry="${units[$(((i + (round - 1) * 3) % count))]}"
    unit="${entry%%:*}"
    IFS=, read -r -a lanes <<< "${entry#*:}"
    n=${#lanes[@]}
    runs=()
    for ((j = 0; j < n; j += 1)); do
        runs+=("probe:${lanes[$(((j + round - 1) % n))]}")
    done
    "$D/runs.sh" "$L" "$round" "$unit" "$D/$unit" 21 "${runs[@]}"
done
EOF
chmod +x "$D/round4.sh"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/round4.sh" "$L" "$round" > /dev/null 2>> "$D/queue4.lock.txt"
    sleep 30
done
echo done >> "$L"
