#!/bin/bash
# #2719, head2 (one loop analysis): build, then measure-compile default against -hoist, each under the lock on its own.
D=~/buster-fast-bench/2719-claude
export EXCLUSIVE_OWNER=claude-2719 EXCLUSIVE_TITLE="Tier 1 pressure-aware LICM and GVN (#2719)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2719
cd $D/head2 && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > $D/build2.log 2>&1
echo "build rc=$?" >> $D/build2.log
sha256sum $D/head2/build/compiler >> $D/build2.log
cat > $D/compile2.sh <<'INNER'
#!/bin/bash
D=~/buster-fast-bench/2719-claude
B=$D/head2/build/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
echo "tree head2: 061effd6 plus head2.patch $(sha256sum $D/head2.patch | cut -c1-16); compiler $(sha256sum $B | cut -c1-16)"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
mkdir -p $D/tmp && cd $D/tmp && taskset -c 2 $B measure-compile --runs 11 --variant --tier1-passes=-hoist --variant --tier1-passes=+numbering -- -c --tier1 --lanes 1 "${source[@]}" $sqlite/sqlite3.c
echo "rc=$?"
cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6
INNER
chmod +x $D/compile2.sh
cd $D && ~/buster-fast-bench/exclusive.sh ./compile2.sh > $D/compile2.log 2>&1
echo "lock rc=$?" >> $D/compile2.log
echo done > $D/head2.done
