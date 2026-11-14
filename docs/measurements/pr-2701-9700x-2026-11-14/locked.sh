#!/usr/bin/env bash
set -uo pipefail
printf '=== start %s ===\n' "$(date -Is)"
printf 'load: '; cat /proc/loadavg
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12
"$@"
status=$?
printf '=== end %s status %s ===\n' "$(date -Is)" "$status"
printf 'load: '; cat /proc/loadavg
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -12
exit "$status"
