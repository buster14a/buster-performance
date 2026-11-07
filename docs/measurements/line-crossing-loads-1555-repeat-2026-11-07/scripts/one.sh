#!/bin/bash
# one.sh NAME -- COMMAND...: one run under the 9700X's lock (exclusive.sh), taken for this run alone, with its receipts
# in runs/NAME/: the command, when the lock was requested, taken and given back, the exit status, standard output and
# standard error. exclusive.sh's own message when it waits names the current holder; only whether it waited is kept.
# The command runs in the current directory.
set -u
root=$HOME/buster-fast-bench/1555-claude-r2
name=$1
shift
[ "$1" = -- ] && shift
dir=$root/runs/$name
mkdir -p "$dir"
printf '%q ' "$@" > "$dir/command"
echo >> "$dir/command"
pwd > "$dir/directory"
date +%s.%N > "$dir/requested"
EXCLUSIVE_OWNER=claude-1555 EXCLUSIVE_TITLE="#1555 repeat, one run: $name" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1555 \
    "$HOME/buster-fast-bench/exclusive.sh" bash -c 'd=$1; shift; date +%s.%N > "$d/acquired"; "$@" > "$d/stdout" 2> "$d/stderr"; s=$?; date +%s.%N > "$d/released"; echo $s > "$d/status"; exit $s' _ "$dir" "$@" 2> "$dir/.lock-messages"
status=$?
if grep -q '^exclusive.sh: waiting' "$dir/.lock-messages"; then
    echo "waited for the lock (holder omitted)" > "$dir/lock"
else
    echo "took the lock without waiting" > "$dir/lock"
fi
grep -v -e '^exclusive.sh: waiting' -e '^  title: ' -e '^  link: ' "$dir/.lock-messages" > "$dir/lock-other-messages"
rm -f "$dir/.lock-messages"
[ -s "$dir/lock-other-messages" ] || rm -f "$dir/lock-other-messages"
echo "$name $status" >> "$root/runs/manifest"
exit $status
