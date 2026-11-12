#!/bin/bash
# One timed ./build.sh of the scenario campaign, to be run inside the 9700X lock (lock.sh), one build a hold:
#   run.sh SET TREE CASE EDIT FILE REP [BUILD_ARGUMENT...]
# SET names the results file (results/SET.txt) and the logs' prefix; TREE is a clone under this directory; CASE names
# the scenario; EDIT is what happens before the build:
#   clean    rm -rf build (the build then configures too)
#   fresh    the earlier runs' edits are undone (git checkout -- src), then rm -rf build
#   restore  the earlier runs' edits are undone, and the build rebuilds what they touched
#   none     nothing (a no-op rebuild of an up-to-date tree)
#   touch    FILE's time alone changes, so that every unit reading it compiles again and comes out the same
#   append   an emitted function that returns a new string literal is appended to src/buster/compiler/FILE, so that the
#            code of every unit reading it changes
#   prepend  the same function goes before FILE's first line, so that every line of FILE moves down as well
#   guarded  the same function goes before FILE's last line, a header's closing #endif
# The BUSTER_* environment selects the build's settings as usual. With RUN_SHIFTS="DIRECTORY SOURCE SHIFT...", the build
# is `./build.sh shifts` of those (the executable and its placements). Each run writes its log, bash's time, the lock's
# holder line, the lines Ninja's log gained (the commands that reran, with their times) and, from 14:25 UTC on, the
# host's busiest processes before and after the build (NAME.ps.txt).
set -u
export LC_ALL=C
set=$1; tree=$2; case=$3; edit=$4; file=$5; rep=$6
shift 6
d=$HOME/buster-fast-bench/2040-claude
cd "$d/$tree" || exit 2
name=$set-$case-$rep
log=$d/logs/$name
head -1 /var/lib/buster-9700x/owner > "$log.holder.txt"
# The edit: a new emitted function that returns a new string literal.
probe=$(printf '\n__attribute__((used)) static const char* buster_2040_probe_%s_%s_%s(void)\n{\n    return "buster 2040 probe %s %s %s";\n}\n' "$set" "$case" "$rep" "$set" "$case" "$rep" | sed '2s/-/_/g')
path=src/buster/compiler/$file
case $edit in
    clean) rm -rf build ;;
    fresh) git checkout -q -- src; rm -rf build ;;
    restore) git diff --stat -- src > "$log.edits.diffstat"; git checkout -q -- src ;;
    none) ;;
    touch) touch "$path" ;;
    append) printf '%s\n' "$probe" >> "$path" ;;
    prepend) { printf '%s\n' "$probe"; cat "$path"; } > "$path.new" && mv "$path.new" "$path" ;;
    guarded) last=$(tail -1 "$path"); sed -i '$d' "$path"; printf '%s\n\n%s\n' "$probe" "$last" >> "$path" ;;
    *) echo "unknown edit $edit" >&2; exit 2 ;;
esac
binary=$(./build.sh print-output "$@" 2> /dev/null | tail -1)
ninja_log=$(dirname "$(dirname "$binary")")/.ninja_log
# The log before the build: the lines it gains are the commands that reran (Ninja may also rewrite the whole log to
# compact it, so the lines are compared, not the file's length).
: > "$log.ninja_log.before"
[ ! -f "$ninja_log" ] || cp "$ninja_log" "$log.ninja_log.before"
TIMEFORMAT='%R %U %S'
# The busiest processes before and after the build (buster#2555): what else ran on the host.
snapshot() { { date -Is; ps -eo psr,pcpu,pid,etimes,comm --sort=-pcpu | head -8; } >> "$log.ps.txt"; }
: > "$log.ps.txt"
snapshot
if [ -n "${RUN_SHIFTS:-}" ]; then
    # shellcheck disable=SC2086
    { time ./build.sh shifts $RUN_SHIFTS "$@" > "$log.log" 2>&1; } 2> "$log.time"
else
    { time ./build.sh "$@" > "$log.log" 2>&1; } 2> "$log.time"
fi
rc=$?
snapshot
grep -v -x -F -f "$log.ninja_log.before" "$ninja_log" > "$log.ninja_log" 2> /dev/null
[ -s "$log.ninja_log.before" ] || cp "$ninja_log" "$log.ninja_log" 2> /dev/null
rm -f "$log.ninja_log.before"
sha256sum "$binary" > "$log.sha256" 2> /dev/null
summary=$(grep 'units compiled' "$log.log" | tail -1)
echo "$case $tree $rep $(tail -1 "$log.time") rc=$rc edges=$(grep -c -v '^#' "$log.ninja_log") | $summary" >> "$d/results/$set.txt"
