#!/usr/bin/env bash
# chain4.sh, after chain3.sh: compile time at main 2ebfe68 with #2773's branch (bc298522) merged, the base the pull
# request has after merging them (its tree checked by hash), against the pull request's head be6bfc78. Each build and
# each input's measure-compile is one hold of the lock.
W=$HOME/buster-fast-bench/2774-claude
export EXCLUSIVE_OWNER=claude-2774 EXCLUSIVE_TITLE="Tier 1 allocation: evict a value that continues in its slot first (#2774)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2774
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
cd $W || exit 1
until grep -qE 'chain done|FAILED' chain.log; do sleep 30; done
log() { echo "$(date -u +%FT%TZ) $*" >> $W/chain.log; }
log "chain4 start"
rm -rf base2 head2
git clone -q https://github.com/buster14a/buster.git base2 || exit 1
git -C base2 fetch -q origin claude/fervent-wozniak-barcil claude/sleepy-albattani-6yj7xf || exit 1
git -C base2 checkout -q bc298522db73d7d96243c62dac9674c2443a3317 && git -C base2 -c user.name=claude-2774 -c user.email=noreply@anthropic.com -c core.hooksPath=/dev/null merge -q --no-edit 2ebfe68a856613e300231520af5e7ec5627708b6 || exit 1
[ "$(git -C base2 rev-parse HEAD^{tree})" = 7b508fc2583e1737746e3a22173a0900218b09db ] || { log "chain4 base2 tree differs"; exit 1; }
git clone -q base2 head2 && git -C head2 checkout -q be6bfc783d29f316104b0755bd13aeca89d464bb || exit 1
for t in base2 head2; do
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > $W/build-$t-compiler.log 2>&1"
    log "chain4 $t compiler exit $? sha256 $(sha256sum $W/$t/build/compiler | cut -d' ' -f1)"
    cp $W/$t/build/compiler $W/compilers/$t && rm -rf $W/$t/build
done
unset CPATH C_INCLUDE_PATH
mkdir -p $W/compile-be6bfc7 && cd $W/compile-be6bfc7 || exit 1
$L bash -c "head -1 /var/lib/buster-9700x/owner; cat /proc/loadavg; taskset -c 2 $W/compilers/head2 measure-compile --runs 21 --reference $W/compilers/base2 -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > sqlite3.txt 2>&1
log "chain4 sqlite3 exit $?"
$L bash -c "head -1 /var/lib/buster-9700x/owner; cat /proc/loadavg; taskset -c 2 $W/compilers/head2 measure-compile --runs 41 --reference $W/compilers/base2 -- --tier1 --lanes 1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $I/lua/lua-5.4.8/src/lvm.c" > lvm.txt 2>&1
log "chain4 lvm exit $?"
log "chain4 done"
