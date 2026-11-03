#!/usr/bin/env bash
# run.sh MODE BINARY OUT [args]: one speedtest1 run (MODE st) from a fresh database, or one Lua script (MODE lua, args
# the script), its output in OUT. With VG=1, under callgrind, whose output goes to OUT.cg.
set -u
S=${S:?S names the scratch directory, laid out as the README says}
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mode=$1; bin=$(readlink -f $2); out=$(readlink -f $3); shift 3
pre=()
[ "${VG:-0}" = 1 ] && pre=(valgrind --tool=callgrind --callgrind-out-file=$out.cg ${VGOPTS:-})
if [ $mode = st ]; then
    d=$(mktemp -d /dev/shm/st.XXXXXX); mkdir -p $d/db $d/tmp
    (cd $d/db && SQLITE_TMPDIR=$d/tmp "${pre[@]}" $bin $OPTS "$@" speedtest1.db > $out 2> $out.err)
    rc=$?; rm -rf $d
else
    (cd $S/inputs/lua && "${pre[@]}" $bin "$@" > $out 2> $out.err)
    rc=$?
fi
exit $rc
