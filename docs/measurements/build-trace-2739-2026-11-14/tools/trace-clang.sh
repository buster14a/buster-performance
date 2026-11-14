#!/bin/bash
# A clang that traces every compile: -ftime-trace beside the object (OBJECT.json) and -ftime-report's text in
# OBJECT.time-report, its other diagnostics passed through. REAL_CLANG is the clang it runs.
real="${REAL_CLANG:?}"
compile=0
out=""
previous=""
for a in "$@"; do
    [ "$a" = "-c" ] && compile=1
    [ "$previous" = "-o" ] && out="$a"
    previous="$a"
done
if [ "$compile" = 1 ] && [ -n "$out" ]; then
    "$real" "$@" -ftime-trace -ftime-trace-granularity=500 -ftime-report 2> "$out.stderr"
    status=$?
    # The report starts at its first ruler line; whatever comes before it is the compile's own output.
    awk -v report="$out.time-report" 'started == 0 && /^===-+===$/ { started = 1 } started { print > report; next } { print > "/dev/stderr" }' "$out.stderr"
    rm -f -- "$out.stderr"
    exit $status
fi
exec "$real" "$@"
