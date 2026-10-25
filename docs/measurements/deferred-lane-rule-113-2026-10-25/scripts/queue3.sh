#!/bin/bash
# #113's deferred lanes from the bodies' work: c-testsuite's 220 programs of #145's subset (tests/c-testsuite/subset.txt
# at commit 5c72756), eight lanes against one, before (probe) and after (rule), each program and tree in a process of
# its own (runs.sh), the trees' order alternating by program; a lock hold covers 75 programs' runs (about 40 s).
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes from body work: c-testsuite"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6402314088"
L="$D/log3.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
cat > "$D/batch3.sh" << 'EOF'
#!/bin/bash
# Programs' runs in one lock hold: LOG FIRST PROGRAM... (FIRST: the first program's place in the list, for the order).
D=~/buster-fast-bench/deferred-lanes-claude
L="$1"
place="$2"
shift 2
for program in "$@"; do
    file="$D/c-testsuite/tests/single-exec/$program.c"
    if [ $((place % 2)) = 0 ]; then
        "$D/runs.sh" "$L" 1 "$program" "$file" 21 probe:8 rule:8
    else
        "$D/runs.sh" "$L" 1 "$program" "$file" 21 rule:8 probe:8
    fi
    place=$((place + 1))
done
EOF
chmod +x "$D/batch3.sh"
mapfile -t programs < <(grep -v '^#' "$D/rule/tests/c-testsuite/subset.txt" | grep -v '^$')
count=${#programs[@]}
for ((i = 0; i < count; i += 75)); do
    ~/buster-fast-bench/exclusive.sh "$D/batch3.sh" "$L" "$i" "${programs[@]:i:75}" > /dev/null 2>> "$D/queue3.lock.txt"
    sleep 30
done
echo done >> "$L"
