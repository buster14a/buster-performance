#!/usr/bin/env bash
# 2592 runtime, step 2b (after prepare.sh built the objects): Lua linked by cc in ORDERS orders (order 0 the usual one,
# the others shuf's seeded by the order's number, as #1435's orders.sh), speedtest1 after a padding object of each
# SHIFTS' bytes; then every executable checked (each script's output against clang -O0's, speedtest1's --verify hash).
# The links are one hold of the lock (about 15 s), the Lua checks one and speedtest1's checks one: the 9700X's queue was
# ten deep with other sessions' builds, so a hold per link and per check would have waited hours.
set -u
W=$HOME/buster-fast-bench/2592-claude
export EXCLUSIVE_OWNER=claude-2592 EXCLUSIVE_TITLE="Tier 1: dispatch tails without the r11 rotation (#2592)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2592
L=$HOME/buster-fast-bench/exclusive.sh
REVS=${REVS:-base head}
I=$W/inputs
ORDERS=${ORDERS:-33}
SHIFTS=${SHIFTS:-0 528 1056 1584 2112 2640 3168 3696}
files="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
scripts="calls tables strings arithmetic closures"
STOPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
HASH="1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739"
LUAHOT="luaV_execute luaD_precall luaD_poscall luaH_getshortstr luaH_get luaH_newkey luaV_finishget luaC_step"
STHOT="sqlite3VdbeExec sqlite3BtreeIndexMoveto sqlite3BtreeTableMoveto sqlite3VdbeRecordCompareWithSkip sqlite3VdbeSerialGet"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/prepare.log; }
cd $W || exit 1
rm -rf exe; mkdir -p exe pad check
: > orders.txt
for o in $(seq 0 $((ORDERS - 1))); do
    if [ $o = 0 ]; then perm="$files"; else perm=$(echo $files | tr ' ' '\n' | shuf --random-source=<(yes $o) | tr '\n' ' '); fi
    echo "$o $perm" >> orders.txt
done
for n in $SHIFTS; do printf '\t.text\n\t.skip %d, 0xcc\n' $n | clang -c -x assembler -o pad/pad$n.o -; done
cat > links.sh <<LINKS
#!/usr/bin/env bash
cd $W || exit 1
status=0
while read -r o perm; do
    for t in $REVS; do
        objs=""; for f in \$perm; do objs="\$objs $W/obj-\$t/\$f.o"; done
        cc -o $W/exe/lua-\$t-o\$o \$objs -lm -ldl || status=1
    done
done < orders.txt
for n in $SHIFTS; do for t in $REVS; do cc -o $W/exe/st-\$t-s\$n $W/pad/pad\$n.o $W/obj-\$t/speedtest1.o -lm || status=1; done; done
exit \$status
LINKS
chmod +x links.sh
$L ./links.sh
log "links exit $?"
cat > checks-lua.sh <<CHECKS
#!/usr/bin/env bash
cd $I/lua || exit 1
for e in $W/exe/lua-*; do
    bad=''
    for s in $scripts; do \$e \$s.lua > $W/check/out.txt 2>&1; rc=\$?; { [ \$rc = 0 ] && cmp -s $W/check/out.txt $I/ref/\$s-clang0.out; } || bad="\$bad \$s:\$rc"; done
    echo "exe/\$(basename \$e) \${bad:-ok}"
done
CHECKS
cat > checks-st.sh <<CHECKS
#!/usr/bin/env bash
for e in $W/exe/st-*; do
    d=\$(mktemp -d /dev/shm/st2592.XXXXXX) && mkdir \$d/db \$d/tmp && cd \$d/db && SQLITE_TMPDIR=\$d/tmp \$e $STOPTS --verify speedtest1.db > $W/check/st.txt 2>&1; rc=\$?; cd $W; rm -rf \$d
    if [ \$rc = 0 ] && grep -qx "Verification Hash: $HASH" $W/check/st.txt; then echo "exe/\$(basename \$e) ok"; else echo "exe/\$(basename \$e) failed:\$rc \$(grep 'Verification Hash' $W/check/st.txt)"; fi
done
CHECKS
chmod +x checks-lua.sh checks-st.sh
$L ./checks-lua.sh > checks.txt
$L ./checks-st.sh >> checks.txt
log "checks: $(awk '{print $2}' checks.txt | sort | uniq -c | tr '\n' ' ')"
status=0
grep -vq ' ok$' checks.txt && status=1
[ $(wc -l < checks.txt) = $(( ORDERS * 2 + $(echo $SHIFTS | wc -w) * 2 )) ] || status=1
(cd exe && sha256sum *) > executables.sha256
for e in exe/*; do
    case $e in exe/lua-*) hot=$LUAHOT ;; *) hot=$STHOT ;; esac
    echo "$e $(stat -c %s $e) $(nm $e | awk -v h=" $hot " 'index(h, " " $3 " ") { printf "%s=%s ", $3, $1 }')"
done > addresses.txt
log "link done, status $status"
exit $status
