set -u
head -1 /var/lib/buster-9700x/owner >> /home/david/buster-fast-bench/2618-claude/holds.txt
status=0
for s in calls tables strings arithmetic closures; do
    (cd /home/david/buster-fast-bench/2618-claude/inputs && /home/david/buster-fast-bench/2618-claude/lua-clang0 $s.lua > /home/david/buster-fast-bench/2618-claude/ref-$s.out 2>&1)
    for o in $(seq 0 5); do
        for t in base head; do
            (cd /home/david/buster-fast-bench/2618-claude/inputs && /home/david/buster-fast-bench/2618-claude/lua-$t-o$o $s.lua > /home/david/buster-fast-bench/2618-claude/check.out 2>&1); rc=$?
            if cmp -s /home/david/buster-fast-bench/2618-claude/check.out /home/david/buster-fast-bench/2618-claude/ref-$s.out && [ $rc = 0 ]; then echo "check $s $t o$o same"; else echo "check $s $t o$o FAILED"; status=1; fi
        done
    done
done
for e in /home/david/buster-fast-bench/2618-claude/st-base /home/david/buster-fast-bench/2618-claude/st-head /home/david/buster-fast-bench/2618-claude/lay/st-base-p0 /home/david/buster-fast-bench/2618-claude/lay/st-head-p0 /home/david/buster-fast-bench/2618-claude/lay/st-base-p16 /home/david/buster-fast-bench/2618-claude/lay/st-head-p16 /home/david/buster-fast-bench/2618-claude/lay/st-base-p32 /home/david/buster-fast-bench/2618-claude/lay/st-head-p32 /home/david/buster-fast-bench/2618-claude/lay/st-base-p48 /home/david/buster-fast-bench/2618-claude/lay/st-head-p48 /home/david/buster-fast-bench/2618-claude/lay/st-base-p1072 /home/david/buster-fast-bench/2618-claude/lay/st-head-p1072 /home/david/buster-fast-bench/2618-claude/lay/st-base-p3088 /home/david/buster-fast-bench/2618-claude/lay/st-head-p3088; do
    rm -rf /home/david/buster-fast-bench/2618-claude/db /home/david/buster-fast-bench/2618-claude/tmp; mkdir -p /home/david/buster-fast-bench/2618-claude/db /home/david/buster-fast-bench/2618-claude/tmp
    (cd /home/david/buster-fast-bench/2618-claude/db && SQLITE_TMPDIR=/home/david/buster-fast-bench/2618-claude/tmp $e --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 --verify speedtest1.db > /home/david/buster-fast-bench/2618-claude/verify.out 2>&1)
    if grep -qx 'Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739' /home/david/buster-fast-bench/2618-claude/verify.out; then echo "verify $e same"; else echo "verify $e FAILED"; status=1; fi
done
exit $status
