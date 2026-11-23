#!/bin/bash
# usage: step.sh TREE MODE CFG [FILE N] ; one measured build of TREE's Develop, run inside a hold (lock.sh held.sh):
#   clean  the tree configured for CFG, Develop cleaned, then the timed build, and a timed build of nothing after it;
#   noop   the tree configured and built for CFG, then the timed build of nothing;
#   edit   the tree built for CFG, then a function appended to FILE (the N-th edit's own), the timed build, the file put
#          back (a copy with a new time) and the untimed build after it.
# CFG is off (BUSTER_SELF_BUILT unset) or tests (BUSTER_SELF_BUILT=tests). Prints a `result` line: the mode, the
# configuration, the file, the timed build's wall seconds and build.sh's own line.
set -u
. "$HOME/buster-fast-bench/2630-claude/scripts/env.sh"
tree=$1; mode=$2; cfg=$3; file=${4:-}; n=${5:-0}
cd "$tree" || exit 2
if [ "$cfg" = tests ]; then export BUSTER_SELF_BUILT=tests; else unset BUSTER_SELF_BUILT; fi
./build.sh configure > /dev/null 2>&1 || exit 3
case "$mode" in
    clean) ./build.sh clean --config Develop > /dev/null 2>&1 || exit 3 ;;
    noop|edit) ./build.sh > /dev/null 2>&1 || exit 3 ;;
esac
if [ "$mode" = edit ]; then
    cp -p "$file" "$d/tmp/edit-saved" || exit 3
    printf '\n__attribute__((used)) static const char* buster_2630_edit_%s(void)\n{\n    return "edit %s";\n}\n' "$n" "$n" >> "$file"
fi
start=$(date +%s.%N)
./build.sh > "$d/tmp/step.log" 2>&1
status=$?
end=$(date +%s.%N)
line=$(grep "units compiled" "$d/tmp/step.log" | tail -1)
[ "$status" = 0 ] || line="FAILED $status: $(tail -3 "$d/tmp/step.log" | tr '\n' ' ')"
printf 'result\t%s\t%s\t%s\t%.3f\t%s\n' "$mode" "$cfg" "${file##*/}" "$(awk -v a="$start" -v b="$end" 'BEGIN { printf "%.3f", b - a }')" "$line"
grep -c "with the previous stage" "$d/tmp/step.log" | sed 's/^/previous-stage compiles: /'
grep -c "Optimizing and generating" "$d/tmp/step.log" | sed 's/^/parts optimized: /'
if [ "$mode" = clean ] && [ "$status" = 0 ]; then
    start=$(date +%s.%N)
    ./build.sh > "$d/tmp/step.log" 2>&1
    status=$?
    end=$(date +%s.%N)
    printf 'result\t%s\t%s\t%s\t%s\t%s\n' noop "$cfg" "" "$(awk -v a="$start" -v b="$end" 'BEGIN { printf "%.3f", b - a }')" "$(grep "units compiled" "$d/tmp/step.log" | tail -1)"
fi
if [ "$mode" = edit ]; then
    cat "$d/tmp/edit-saved" > "$file"
    ./build.sh > /dev/null 2>&1 || exit 3
fi
exit "$status"
