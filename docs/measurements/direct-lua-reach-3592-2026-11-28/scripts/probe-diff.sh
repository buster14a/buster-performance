#!/bin/bash
# probe-diff.sh COMPILER FILE...: each file by -c on the default path and by --no-direct; prints the path taken and
# whether stderr and status agree. A unit the direct path takes must agree.
bin=$1; shift
bad=0
for f in "$@"; do
    d=$("$bin" -c "$f" -o /tmp/claude-0/probes/d.o 2>&1); ds=$?
    path=$(readelf -p .comment /tmp/claude-0/probes/d.o 2>/dev/null | grep -c 'buster direct')
    [ $ds -ne 0 ] && path=0
    n=$("$bin" --no-direct -c "$f" -o /tmp/claude-0/probes/n.o 2>&1); ns=$?
    same=same; [ "$d" != "$n" ] || [ $ds -ne $ns ] && same=DIFFERENT
    [ "$same" = DIFFERENT ] && bad=$((bad + 1))
    printf '%-28s direct=%s %s %s\n' "$(basename "$f")" "$path" "$same" "$(echo "$n" | grep -o 'warning:.*\|error:.*' | head -1 | cut -c1-70)"
done
echo "different: $bad"
