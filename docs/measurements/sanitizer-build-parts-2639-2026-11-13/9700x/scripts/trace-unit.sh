#!/bin/bash
# trace-unit.sh TAG SANITIZER UNIT: the unit's Release compile alone, from that sanitizer tree's compile database in
# src, pinned to CPU 2 under the 9700X's lock, with -ftime-trace (500 us granularity) and -ftime-report, into
# results/TAG. The object goes to the results directory, not the tree.
set -u
base=~/buster-fast-bench/2639-claude
tag=$1
sanitizer=$2
unit=$3
out=$base/results/$tag
mkdir -p "$out"
cd "$base/src"
database=build/cmake/native-$sanitizer-O3/Release/compile_commands.json
jq -r --arg unit "$unit" '.[] | select(.file | endswith("/" + $unit)) | .command' "$database" > "$out/command.txt"
[ -s "$out/command.txt" ] || { echo "no command for $unit" > "$out/error.txt"; exit 1; }
# The command without its output and dependency file: those go to the results directory.
sed -E -e 's/ -o [^ ]+/ -o OBJECT/' -e 's/ -MD -MT [^ ]+ -MF [^ ]+//' "$out/command.txt" > "$out/command-edited.txt"
export EXCLUSIVE_OWNER=claude-2639
export EXCLUSIVE_TITLE="#2639: the sanitizer builds' critical path"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2639
export OUT="$out"
~/buster-fast-bench/exclusive.sh timeout -k 10 1500 bash -c '
    { date -Is; cat /var/lib/buster-9700x/owner; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/before.txt"
    command=$(sed "s#OBJECT#$OUT/unit.o#" "$OUT/command-edited.txt")
    cd build/cmake/native-'"$sanitizer"'-O3
    TIMEFORMAT="wall %R user %U system %S"
    { time taskset -c 2 bash -c "$command -ftime-trace=$OUT/trace.json -ftime-trace-granularity=500 -ftime-report" > "$OUT/report.txt" 2>&1; } 2> "$OUT/time.txt"
    echo "status $?" >> "$OUT/time.txt"
    { date -Is; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12; } > "$OUT/after.txt"
' 2> "$out/exclusive.stderr"
echo "done $?" >> "$out/exclusive.stderr"
