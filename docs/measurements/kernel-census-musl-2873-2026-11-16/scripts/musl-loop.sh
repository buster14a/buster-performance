#!/bin/bash
# musl-loop.sh MODE COMPILER: the units one after another, each its own process under waitall (as a build tool runs
# them on one core; waitall waits for the exit helper too), MODE `units`; `true` runs /usr/bin/true in each compile's
# place (the harness alone); `command` runs them as one command on one lane, the one-core record's way. Objects to
# tmpfs: a unit's over the last one's, the command's in a directory of its own.
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
source "$here/scripts/musl-common.sh"
mode=$1
compiler=$2
status=0
case $mode in
    units)
        for f in "${files[@]}"; do
            "$here/tools/waitall" "$compiler" "${options[@]}" -c "$f" -o /dev/shm/2873-musl.o || status=1
        done ;;
    true)
        for f in "${files[@]}"; do
            "$here/tools/waitall" /usr/bin/true "${options[@]}" -c "$f" -o /dev/shm/2873-musl.o || status=1
        done ;;
    command)
        mkdir -p /dev/shm/2873-musl-objects && cd /dev/shm/2873-musl-objects || exit 1
        "$here/tools/waitall" "$compiler" "${options[@]}" --lanes 1 -c "${files[@]}" || status=1
        cd / && rm -rf /dev/shm/2873-musl-objects ;;
esac
rm -f /dev/shm/2873-musl.o
exit $status
