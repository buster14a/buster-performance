#!/bin/bash
# outputs446.sh: #446's outputs, after the campaign and the sizes: each case's last output by main (base) and by the
# head compared byte for byte, each run, and their exit statuses and output compared; main's two labels of the affected
# case against each other. Under one hold of the shared lock; its report is outputs-check.txt. (Run from a shell as
# `ssh ... 'EXCLUSIVE_OWNER=... exclusive.sh bash -c "..."'`; this is the same command as a script.)
set -u
cd ~/buster-fast-bench/perf-445-446-claude/links-out
for c in dyn2000-threads dyn2000-one static2000-threads static2000-one dyn102400-threads dyn102400-one static102400-threads \
    static102400-one dyn500-threads dyn1000-threads dyn4000-threads dyn8000-threads dyn16000-threads dyn32000-threads; do
    b=base-$c
    h=head-$c
    s=$(sha256sum $b | cut -c1-16)
    if cmp -s $b $h; then same=identical; else same=DIFFERENT; fi
    ./$b > /tmp/out-b 2>&1; sb=$?
    ./$h > /tmp/out-h 2>&1; sh=$?
    cmp -s /tmp/out-b /tmp/out-h && o=same || o=differs
    echo "$c: $same ($s, $(stat -c %s $b) bytes), base exit $sb, head exit $sh, output $o, $(wc -c < /tmp/out-b) bytes"
done
cmp -s base-dyn2000-threads base2-dyn2000-threads && echo base2: identical to base
rm -f /tmp/out-b /tmp/out-h
