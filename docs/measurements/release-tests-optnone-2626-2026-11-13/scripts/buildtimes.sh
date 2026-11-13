#!/bin/bash
# The build's times by side, each its own hold (lock.sh): buildtimes.sh SIDE ROUND. A clean Release build with -g as
# ./build.sh --config Release builds it (eight jobs), then the edits the issue names: the backend's unit and the front
# end's, each its file's time alone (touch), rebuilt. Lines go to results/buildtimes.tsv: side, round, case, wall s.
set -u
export LC_ALL=C
side=$1; round=$2
d=$HOME/buster-fast-bench/2626-claude
. "$d/scripts/env.sh"
export BUSTER_DEBUG_INFO=1
cd "$d/$side-g" || exit 2
timed()
{
    local start end
    start=${EPOCHREALTIME//[!0-9]/}
    ./build.sh --config Release --jobs 8 > "$d/logs/buildtimes-$side-$round-$1.log" 2>&1
    end=${EPOCHREALTIME//[!0-9]/}
    printf '%s\t%s\t%s\t%s\n' "$side" "$round" "$1" "$(awk -v n="$(( end - start ))" 'BEGIN { printf "%.1f", n / 1e6 }')" >> "$d/results/buildtimes.tsv"
}
case $3 in
    clean) rm -rf build; timed clean ;;
    backend) touch src/buster/compiler/main_unit_backend.c; timed backend ;;
    frontend) touch src/buster/compiler/main_unit_frontend.c; timed frontend ;;
esac
