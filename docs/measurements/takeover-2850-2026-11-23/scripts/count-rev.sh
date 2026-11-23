#!/bin/bash
# count-rev.sh REV...: for each revision, the instrumented compiler built in /home/user/wt-exp and the sum of the raw
# profile's counters after one default -c of sqlite3.c (three runs).
cd /home/user/wt-exp || exit 1
S=/home/user/corpora/sqlite
for rev in "$@"; do
    git checkout -q --detach "$rev" || { echo "$rev checkout-failed"; continue; }
    BUSTER_PGO=1 BUSTER_PGO_TRAIN=/home/user/keep/pgo/train-tiny.sh ./build.sh --config Release --target compiler > /home/user/keep/pgo/build-$rev.log 2>&1
    P=build/cmake/native-pgo/pgo/compiler
    [ -x $P ] || { echo "$rev no-instrumented-compiler"; continue; }
    for i in 1 2 3; do
        LLVM_PROFILE_FILE=/home/user/keep/pgo/$rev-$i.profraw $P --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S $S/sqlite3.c -o /home/user/keep/pgo/$rev.o
    done
    python3 - "$rev" <<'PY'
import struct, sys
rev = sys.argv[1]
sums = []
for i in (1, 2, 3):
    d = open(f'/home/user/keep/pgo/{rev}-{i}.profraw', 'rb').read()
    w = struct.unpack('<19Q', d[:152])
    assert w[0] == 0xff6c70726f667281 and w[1] == 11
    off = 152 + w[2] + w[3] * 72 + w[4]
    sums.append(sum(struct.unpack('<%dQ' % w[5], d[off:off + 8 * w[5]])))
print(rev, 'sums', sums, flush=True)
PY
    rm -f /home/user/keep/pgo/$rev-2.profraw /home/user/keep/pgo/$rev-3.profraw
done
echo counts-complete
