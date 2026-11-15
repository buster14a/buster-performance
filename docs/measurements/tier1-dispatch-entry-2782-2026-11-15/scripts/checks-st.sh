#!/usr/bin/env bash
for e in /home/david/buster-fast-bench/2782-claude/exe/st-*; do
    d=$(mktemp -d /dev/shm/st2782.XXXXXX) && mkdir $d/db $d/tmp && cd $d/db && SQLITE_TMPDIR=$d/tmp $e --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 --verify speedtest1.db > /home/david/buster-fast-bench/2782-claude/check/st.txt 2>&1; rc=$?; cd /home/david/buster-fast-bench/2782-claude; rm -rf $d
    if [ $rc = 0 ] && grep -qx "Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739" /home/david/buster-fast-bench/2782-claude/check/st.txt; then echo "exe/$(basename $e) ok"; else echo "exe/$(basename $e) failed:$rc $(grep 'Verification Hash' /home/david/buster-fast-bench/2782-claude/check/st.txt)"; fi
done
