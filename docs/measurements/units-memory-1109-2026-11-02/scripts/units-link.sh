#!/bin/bash
# units-link.sh TREE OUT LABEL [OPTION...]: build.sh's sources linked into one executable (-o selfhost, -lm -lpthread) by
# TREE's compiler, in a fresh directory: its status, wall ms, peak RSS, lanes, the self-hosted compiler's --version status and
# the units-memory report, appended to OUT.
export LC_ALL=C
tree=$1; out=$2; label=$3; shift 3
work=$(mktemp -d ~/buster-fast-bench/1109-claude/run.XXXXXX)
cd "$tree" || exit 1
mapfile -d '' sources < <(./build.sh print-sources)
for i in "${!sources[@]}"; do sources[$i]="$tree/${sources[$i]}"; done
flags=(-march=native -I"$tree/src" -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector -Wno-unused-function -Wno-psabi)
cd "$work"
begin=$EPOCHREALTIME
"$tree/build/compiler" --time-stages "$@" "${flags[@]}" -o selfhost "${sources[@]}" -lm -lpthread 2> err > /dev/null
status=$?
end=$EPOCHREALTIME
us=$(( ${end/[.,]/} - ${begin/[.,]/} ))
printf '%s\t%d\t%d.%03d\t%s\t%s\t%s\t%s\t%s\n' "$label" "$status" $((us / 1000)) $((us % 1000)) \
    "$(sed -n 's/^time-process\tpeak-rss-kb\t//p' err)" "$(sed -n 's/^time-process\tlanes\t//p' err)" \
    "$(test -x selfhost && ./selfhost --version > /dev/null 2>&1; echo $?)" "$(sed -n 's/^units memory: //p' err)" "$(grep -c 'error' err)" >> "$out"
[ $status -eq 0 ] || head -5 err >> "$out"
cd /; rm -rf "$work"
