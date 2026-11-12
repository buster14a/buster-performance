#!/bin/bash
# Develop's clean build and the checker's edit again at the pull request's head (5f6f8d9, which keeps
# c_preprocessor_benchmark.c in Develop), one lock hold each; results/queue.txt has each step.
set -u
d=$HOME/buster-fast-bench/2559-claude
s=$d/scripts
echo $$ > "$d/queue-head.pid"
cd "$d/src" && git fetch -q --depth 1 https://github.com/buster14a/buster claude/bold-faraday-lvh60i && git checkout -q FETCH_HEAD && git log --oneline -1 > "$d/results/head.txt"
step() {
    local start=$(date -u +%FT%TZ)
    "$s/lock.sh" "$@"
    printf '%s\t%s\trc=%s\t%s\n' "$start" "$(date -u +%FT%TZ)" "$?" "$*" >> "$d/results/queue.txt"
}
for rep in 1 2 3; do
    step "$s/run.sh" head src clean clean - "$rep" --config Develop
done
step "$s/run.sh" head src nothing none - 1 --config Develop
for rep in 1 2 3; do
    step "$s/run.sh" head src checker append c_check_input.c "$rep" --config Develop
done
step "$s/run.sh" head src restore restore - 1 --config Develop
echo done-head >> "$d/results/queue.txt"
