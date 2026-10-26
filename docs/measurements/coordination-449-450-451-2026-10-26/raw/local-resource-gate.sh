#!/bin/bash
set -eu
case "$1" in
    A|B|C) grant=2; quota=200 ;;
    A-test|B-test|C-test) grant=4; quota=800 ;;
    *) exit 2 ;;
esac
role=$1
case "$role" in
    A*) issue=450 ;;
    B*) issue=449 ;;
    C*) issue=451 ;;
esac
shift
directory=$(cd -- "$(dirname -- "$0")" && pwd)
queue=$(command -v cores)
export CORES_OWNER="Codex agent $role"
export CORES_TITLE="Buster #$issue local validation"
export CORES_LINK="https://github.com/buster14a/buster/issues/$issue"
exec flock "$directory/validation.lock" "$queue" -n "$grant" --priority low -- "$directory/granted-job.sh" "$quota" "$@"
