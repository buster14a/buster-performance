#!/bin/bash
# #2627 prototype on the 9700X: an edit of c_check_input.c rebuilt by the tree's Develop build (base: its whole checker
# unit) and by the pieces' build (pieces: 8 pieces of it, gen.sh), both with Ninja on 8 jobs to the same executable's
# link and bake. Two edits: `append`, #2624's (a function added at the file's end), and `body` (one string literal of
# check_input_invalid_redefinition_note changed, no line moved). Each round and side is one hold of the lock: the build
# brought up to date, the edit, the timed build, then (untimed) the file put back and both builds brought up to date.
#   edits.sh [ROUNDS]       results to results/edits.tsv: round, edit, side, milliseconds, front ends, parts
# EDITS (append body), SIDES (base pieces) and PIECES (the pieces' build directory, n) choose; FIRST numbers the rounds.
set -eu
d=$HOME/buster-fast-bench/2627-claude
export EXCLUSIVE_OWNER=claude-2627 EXCLUSIVE_TITLE="#2627: the checker's unit in pieces (prototype)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2627
. $HOME/buster-fast-bench/2626-claude/scripts/env.sh
export BUSTER_HOST_ARCH=znver5
cd "$d/base"
tree=$(dirname "$(dirname "$(./build.sh print-output)")")
mkdir -p "$d/results" "$d/logs"
out=$d/results/edits.tsv
[ -s "$out" ] || printf 'round\tedit\tside\tms\tfront_ends\tparts\n' > "$out"
cat > "$d/one.sh" <<'INNER'
#!/bin/bash
set -eu
d=$1; tree=$2; round=$3; edit=$4; side=$5; out=$6; n=$d/${7:-n}
cd "$d/base"
file=src/buster/compiler/c_check_input.c
ninja -C "$tree" -f build-Develop.ninja -j 8 Develop/compiler > /dev/null
ninja -C "$n" -j 8 > /dev/null
cp "$file" "$d/saved.c"
case $edit in
    append) printf '\n__attribute__((used)) static const char* buster_edit_round_%s(void)\n{\n    return "%s";\n}\n' "$round" "$round" >> "$file" ;;
    body) sed -i '12487s/an object with linkage"/an object with linkage '"$round"'"/' "$file"; grep -c "an object with linkage $round\"" "$file" > /dev/null ;;
esac
log=$d/logs/$edit-$side-${7:-n}-$round.log
start=${EPOCHREALTIME//[!0-9]/}
if [ "$side" = base ]; then
    ninja -C "$tree" -f build-Develop.ninja -j 8 Develop/compiler > "$log" 2>&1
    fronts=$(grep -c "main_unit_checker.c.o" "$log" || true)
    parts=$(grep -c "Optimizing and generating" "$log" || true)
else
    ninja -C "$n" -j 8 -v > "$log" 2>&1
    fronts=$(grep -c "piece-cc.sh" "$log" || true)
    parts=$(grep -c -- "-x ir" "$log" || true)
fi
end=${EPOCHREALTIME//[!0-9]/}
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$round" "$edit" "$side${7:+-$7}" "$(( (end - start) / 1000 ))" "$fronts" "$parts" >> "$out"
cp "$d/saved.c" "$file"
ninja -C "$tree" -f build-Develop.ninja -j 8 Develop/compiler > /dev/null
ninja -C "$n" -j 8 > /dev/null
INNER
chmod +x "$d/one.sh"
for round in $(seq "${FIRST:-1}" $(( ${FIRST:-1} + ${1:-3} - 1 ))); do
    for edit in ${EDITS:-append body}; do
        for side in ${SIDES:-base pieces}; do
            ~/buster-fast-bench/exclusive.sh timeout 900 "$d/one.sh" "$d" "$tree" "$round" "$edit" "$side" "$out" "${PIECES:-n}"
            tail -1 "$out"
        done
    done
done
echo edits-done
