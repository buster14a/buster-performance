#!/bin/bash
# One timed ./build.sh of a timing tree (tbase: main, thead: the head), inside the lock (lock.sh), with the host's clang
# as #2559's design and Develop's records measured, eight jobs: timed.sh TREE CASE EDIT FILE [BUILD_ARGUMENT...]
# EDIT is what happens first: clean (rm -rf build), none, touch (FILE's time alone), append (an emitted function that
# returns a new string literal appended to src/buster/compiler/FILE), prepend (the same before its first line), restore
# (the edits undone). Writes logs/timed-TREE-CASE.*, the commands that reran (Ninja's log's new lines) and a line of
# results/timed.txt: wall, user and system seconds, the part jobs that ran, and the executable's SHA-256.
set -u
export LC_ALL=C
d=$HOME/buster-fast-bench/2559-release-claude
tree=$1; case=$2; edit=$3; file=$4
shift 4
cd "$d/$tree" || exit 2
log=$d/logs/timed-$tree-$case
head -1 /var/lib/buster-9700x/owner > "$log.holder.txt"
probe=$(printf '\n__attribute__((used)) static const char* buster_2559_release_probe_%s(void)\n{\n    return "buster 2559 release probe %s";\n}\n' "${case//-/_}" "$case")
path=src/buster/compiler/$file
case $edit in
    clean) rm -rf build ;;
    none) ;;
    touch) touch "$path" ;;
    append) printf '%s\n' "$probe" >> "$path" ;;
    prepend) { printf '%s\n' "$probe"; cat "$path"; } > "$path.new" && mv "$path.new" "$path" ;;
    restore) git checkout -q -- src ;;
    *) echo "unknown edit $edit" >&2; exit 2 ;;
esac
binary=$(./build.sh print-output "$@" 2> /dev/null | tail -1)
ninja_log=$(dirname "$(dirname "$binary")")/.ninja_log
: > "$log.ninja_log.before"
[ ! -f "$ninja_log" ] || cp "$ninja_log" "$log.ninja_log.before"
TIMEFORMAT='%R %U %S'
{ time ./build.sh --jobs 8 "$@" > "$log.log" 2>&1; } 2> "$log.time"
status=$?
grep -vxF -f "$log.ninja_log.before" "$ninja_log" > "$log.ran.txt" 2> /dev/null
parts=$(grep -c "Optimizing and generating\|Generating .*native part" "$log.log")
sum=$(sha256sum "$binary" | cut -c1-16)
printf '%s\t%s\t%s\t%s\tparts %s\tstatus %s\t%s\n' "$tree" "$case" "$*" "$(head -1 "$log.time")" "$parts" "$status" "$sum" >> "$d/results/timed.txt"
exit $status
