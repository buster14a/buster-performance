#!/bin/bash
# #113's deferred lanes from the bodies' work, after queue4.sh: one large body beside fifteen smaller ones, on probe
# (14d59dad, main's rule), for the largest body's share of the rule (gen.c 16 S - F: the first body of F stanzas, the
# others of S): 9,989 beside fifteen of 993 and of 1,981 tokens, and 19,973 beside fifteen of 1,981 and of 4,009. Each
# unit and lane count in a process of its own (runs.sh); a lock hold covers one round of every unit, the order rotating.
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
while kill -0 "$1" 2> /dev/null; do sleep 10; done
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes from body work: a large body"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6402314088"
L="$D/log5.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/round5.sh" << 'INNER'
#!/bin/bash
# One round of every unit's lane counts: LOG ROUND.
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
round="$2"
units=(synthetic/l16x19f192.c synthetic/l16x38f192.c synthetic/l16x38f384.c synthetic/l16x77f384.c)
lanes=(2 3 4 8)
count=${#units[@]}
for ((i = 0; i < count; i += 1)); do
    unit="${units[$(((i + round - 1) % count))]}"
    runs=()
    for ((j = 0; j < 4; j += 1)); do
        runs+=("probe:${lanes[$(((j + round - 1) % 4))]}")
    done
    "$D/runs.sh" "$L" "$round" "$unit" "$D/$unit" 21 "${runs[@]}"
done
INNER
chmod +x "$D/round5.sh"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/round5.sh" "$L" "$round" > /dev/null 2>> "$D/queue5.lock.txt"
    sleep 30
done
echo done >> "$L"
