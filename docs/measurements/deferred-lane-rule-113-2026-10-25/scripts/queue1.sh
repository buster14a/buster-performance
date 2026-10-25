#!/bin/bash
# #113's deferred lanes from the bodies' work: what L lanes cost against one, on main with the lane costs reported
# (probe: 14d59dad, main's rule min(--lanes, bodies)). Each unit and lane count runs in a process of its own (runs.sh);
# a lock hold covers one round of every unit (about 40 s), the units' and lane counts' order rotating by round.
# Synthetic units (synthetic/, gen.c: B bodies of S stanzas of 52 tokens, after stdio.h, stdlib.h and string.h, or
# bare), six of c-testsuite's programs and the frozen sqlite3.c.
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes from body work: lane costs"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6402314088"
L="$D/log1.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/round1.sh" << 'EOF'
#!/bin/bash
# One round of every unit's lane counts: LOG ROUND.
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
round="$2"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
units=(
    synthetic/h16x1.c:2,3,4,6,8 synthetic/h16x2.c:2,3,4,6,8 synthetic/h16x5.c:2,3,4,6,8 synthetic/h16x10.c:2,3,4,6,8
    synthetic/h16x19.c:2,3,4,6,8 synthetic/h16x38.c:2,3,4,6,8 synthetic/h16x77.c:2,3,4,6,8 synthetic/h16x154.c:2,3,4,6,8
    synthetic/h2x40.c:2,8 synthetic/h2x80.c:2,8 synthetic/h2x160.c:2,8 synthetic/h64x1.c:2,8 synthetic/h64x3.c:2,8
    synthetic/h64x10.c:2,8 synthetic/b16x5.c:2,8 synthetic/b16x19.c:2,8 synthetic/b16x77.c:2,8
    inputs/00001.c:2,3,4,6,8 inputs/00169.c:2,3,4,6,8 inputs/00213.c:2,3,4,6,8 inputs/00200.c:2,3,4,6,8
    inputs/00182.c:2,3,4,6,8 inputs/00204.c:2,3,4,6,8 sqlite:2,3,4,6,8
)
count=${#units[@]}
for ((i = 0; i < count; i += 1)); do
    entry="${units[$(((i + (round - 1) * 7) % count))]}"
    unit="${entry%%:*}"
    IFS=, read -r -a lanes <<< "${entry#*:}"
    passes=21
    file="$D/$unit"
    if [ "$unit" = sqlite ]; then
        passes=9
        file="$corpus/sqlite/sqlite3.c"
    fi
    n=${#lanes[@]}
    runs=()
    for ((j = 0; j < n; j += 1)); do
        runs+=("probe:${lanes[$(((j + round - 1) % n))]}")
    done
    "$D/runs.sh" "$L" "$round" "$unit" "$file" "$passes" "${runs[@]}"
done
EOF
chmod +x "$D/round1.sh"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/round1.sh" "$L" "$round" > /dev/null 2>> "$D/queue1.lock.txt"
    sleep 30
done
echo done >> "$L"
