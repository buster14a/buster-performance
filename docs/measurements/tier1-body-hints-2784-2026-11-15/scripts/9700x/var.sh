#!/usr/bin/env bash
# 2784 variants on the 9700X: head with switches that turn off the body hints (X2784_NOHINTS) or the slot stamps
# (X2784_NOSTAMPS); speedtest1 by each, linked at the 8 shifts, checked, then ROUNDS rounds of st over base, head and
# both variants (round-var.sh), a hold of the lock per build, per objects, per links and checks, and per round.
set -u
W=$HOME/buster-fast-bench/2784-claude
export EXCLUSIVE_OWNER=claude-2784 EXCLUSIVE_TITLE="Tier 1 allocation: loop bodies before their headers (#2784)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2784
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
SQLFLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
SHIFTS="0 528 1056 1584 2112 2640 3168 3696"
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
HASH="1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739"
ROUNDS=${ROUNDS:-7}
log() { echo "$(date -u +%FT%TZ) $*" >> $W/var.log; }
unset CPATH C_INCLUDE_PATH
cd $W || exit 1
if [ ! -x variant/build/compiler ]; then
    rm -rf variant && git clone -q head variant && git -C variant checkout -q $(git -C head rev-parse HEAD) && git -C variant apply $W/var2784.patch || exit 1
    $L bash -c "cd $W/variant && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-variant.log 2>&1"
    log "variant compiler exit $? sha256 $(sha256sum variant/build/compiler | cut -d' ' -f1)"
fi
C=$W/variant/build/compiler
mkdir -p obj-same obj-nohints obj-nostamps
$L bash -c "$C --tier1 -fno-asynchronous-unwind-tables --tier1-report $SQLFLAGS -I$I/sqlite -c -o obj-same/speedtest1.o $I/st/speedtest1-unity.c > obj-same/speedtest1.report 2>&1 && X2784_NOHINTS=1 $C --tier1 -fno-asynchronous-unwind-tables --tier1-report $SQLFLAGS -I$I/sqlite -c -o obj-nohints/speedtest1.o $I/st/speedtest1-unity.c > obj-nohints/speedtest1.report 2>&1 && X2784_NOSTAMPS=1 $C --tier1 -fno-asynchronous-unwind-tables --tier1-report $SQLFLAGS -I$I/sqlite -c -o obj-nostamps/speedtest1.o $I/st/speedtest1-unity.c > obj-nostamps/speedtest1.report 2>&1"
log "objects exit $?; variant without switches equals head: $(cmp -s obj-same/speedtest1.o obj-head/speedtest1.o && echo yes || echo NO)"
cat > links-var.sh <<LINKS
#!/usr/bin/env bash
cd $W || exit 1
for n in $SHIFTS; do for t in nohints nostamps; do cc -o exe/st-\$t-s\$n pad/pad\$n.o obj-\$t/speedtest1.o -lm || exit 1; done; done
for e in exe/st-nohints-* exe/st-nostamps-*; do
    d=\$(mktemp -d /dev/shm/st2784.XXXXXX) && mkdir \$d/db \$d/tmp && cd \$d/db && SQLITE_TMPDIR=\$d/tmp $W/\$e $STOPTS --verify speedtest1.db > $W/check/st.txt 2>&1; rc=\$?; cd $W; rm -rf \$d
    if [ \$rc = 0 ] && grep -qx "Verification Hash: $HASH" $W/check/st.txt; then echo "\$e ok"; else echo "\$e failed:\$rc"; fi
done
LINKS
chmod +x links-var.sh
$L ./links-var.sh > checks-var.txt
log "links and checks: $(awk '{print $2}' checks-var.txt | sort | uniq -c | tr '\n' ' ')"
grep -vq ' ok$' checks-var.txt && exit 1
sed -e "s|^O=\$W/runs$|O=\$W/runs-var|" -e "s|^REVS=.*|REVS=\${REVS:-base head nohints nostamps}|" round.sh > round-var.sh
chmod +x round-var.sh
mkdir -p runs-var
: > runs-var/runs.txt
$L ./round-var.sh warm st 0
for r in $(seq 1 $ROUNDS); do $L ./round-var.sh time st $r; log "round $r done"; done
log "variants done, $(grep -vc ' status=0 ' runs-var/runs.txt) failed of $(wc -l < runs-var/runs.txt)"
