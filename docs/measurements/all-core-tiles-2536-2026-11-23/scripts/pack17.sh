#!/bin/bash
# pack17.sh NAME...: each results directory as the record keeps it, to stdout as a tar: no objects, the per-run stage
# reports packed in reports.tar.xz, and the lock's wait messages (other sessions' titles and links) left out.
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
work=$(mktemp -d)
for name in "$@"; do
    src=$dir/results/$name
    dst=$work/$name
    mkdir -p "$dst"
    ( cd "$src" && find . -type f ! -name '*.o' ! -name 'w*.i*.txt' ! -name 'hold.sh' ! -name 'lock.err' ! -name '*.report' | cpio -pdm --quiet "$dst" )
    ( cd "$src" && find . -type f \( -name 'w*.i*.txt' -o -name '*.report' \) | sort | tar -cJf "$dst/reports.tar.xz" -T - ) 2>/dev/null || true
    [ -f "$dir/results/$name.lock.err" ] && grep -c "waiting" "$dir/results/$name.lock.err" > "$dst/lock-waits.txt" || true
done
for log in queue12.log queue13.log queue15.log queue16.log smoke12.log; do [ -f "$dir/$log" ] && cp "$dir/$log" "$work/$log"; done
for log in setup-pages.log setup-t2.log setup-t3.log setup-t5.log setup-t6.log; do [ -f "$dir/$log" ] && grep -v "^  title:\|^  link:\|exclusive.sh: waiting" "$dir/$log" | tail -40 > "$work/$log"; done
tar -C "$work" -cf - .
rm -rf "$work"
