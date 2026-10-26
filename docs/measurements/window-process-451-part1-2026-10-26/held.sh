#!/bin/bash
set -u
printf 'start: '; date -Is
cat /var/lib/buster-9700x/owner
printf 'command:'; printf ' %q' "$@"; printf '\n'
"$@"
status=$?
printf 'exit=%s end: ' "$status"; date -Is
exit "$status"
