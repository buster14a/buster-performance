#!/bin/bash
# #113's deferred lanes from the bodies' work: eight lanes against one, before and after the rule. probe: main with the
# lane costs reported (its rule, min(--lanes, bodies)); rule: probe with the rule (one lane, and one more per
# BUSTER_CHECK_DEFERRED_LANE_TOKENS of the bodies' tokens beyond twice the largest body's); and rule-every: the rule's
# binary with --every-lane, every lane the bodies can take, as main runs them. Each unit and tree runs in a process of
# its own (runs.sh); a lock hold covers one round of every unit (about 70 s), the units' and trees' order rotating by
# round.
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes from body work: before and after"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6402314088"
L="$D/log2.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/round2.sh" << 'EOF'
#!/bin/bash
# One round of every unit's three trees: LOG ROUND.
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
trees=(probe:8 rule:8 rule:8:every)
count=${#units[@]}
for ((i = 0; i < count; i += 1)); do
    unit="${units[$(((i + (round - 1) * 5) % count))]}"
    passes=21
    file="$D/$unit"
    if [ "$unit" = sqlite ]; then
        passes=9
        file="$corpus/sqlite/sqlite3.c"
    fi
    runs=()
    for ((j = 0; j < 3; j += 1)); do
        runs+=("${trees[$(((j + round - 1) % 3))]}")
    done
    "$D/runs.sh" "$L" "$round" "$unit" "$file" "$passes" "${runs[@]}"
done
EOF
chmod +x "$D/round2.sh"
for round in 1 2 3 4 5; do
    ~/buster-fast-bench/exclusive.sh "$D/round2.sh" "$L" "$round" > /dev/null 2>> "$D/queue2.lock.txt"
    sleep 30
done
echo done >> "$L"
