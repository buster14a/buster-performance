#!/usr/bin/env bash
# #2624: Develop's edit loop at the base and with SIDES: in each round and side, one hold of the 9700X's lock for a
# function appended to c_check_input.c and ./build.sh, timed; then, outside the timing, the file put back (a new mtime)
# and built again, so that the next round starts from the unedited source's build.
set -euo pipefail
d=~/buster-fast-bench/2624-claude
export EXCLUSIVE_OWNER=claude-2624 EXCLUSIVE_TITLE="Develop's edit loop (#2624)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2624
export BUSTER_HOST_ARCH=znver5 LC_ALL=C
lock=~/buster-fast-bench/exclusive.sh
read -r -a sides <<< "base ${SIDES:?}"
out=$d/edits-${SIDES// /-}.tsv
: > "$out"
for round in $(seq 1 "${ROUNDS:-3}"); do
    for side in "${sides[@]}"; do
        "$lock" bash -c '
            set -euo pipefail
            cd "$1/$2"
            ./build.sh > /dev/null 2>&1
            file=src/buster/compiler/c_check_input.c
            cp "$file" "$1/saved-$2.c"
            printf "\n__attribute__((used)) static const char* buster_edit_round_%s(void)\n{\n    return \"%s\";\n}\n" "$3" "$3" >> "$file"
            start=${EPOCHREALTIME//[!0-9]/}
            ./build.sh > "$1/edit-$2-$3.log" 2>&1
            end=${EPOCHREALTIME//[!0-9]/}
            printf "%s\t%s\t%s\t%s\n" "$3" "$2" "$(( (end - start) / 1000 ))" "$(grep -c "Optimizing and generating" "$1/edit-$2-$3.log")" >> "$4"
            cp "$1/saved-$2.c" "$file"
            ./build.sh > /dev/null 2>&1' edit "$d" "$side" "$round" "$out"
    done
done
echo done >> "$out"
