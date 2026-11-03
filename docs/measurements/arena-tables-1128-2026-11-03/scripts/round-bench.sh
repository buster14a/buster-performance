#!/bin/bash
# round-bench.sh MAIN HEAD: build HEAD, then in one hold the 9700X step's benchmark-check-units command (HEAD's) of each
# build's compiler. Logs in logs/round-HEAD/.
set -u
D=$HOME/buster-fast-bench/1128-claude
main=$1; head=$2
R=$D/logs/round-$head
mkdir -p $R
X=(env EXCLUSIVE_OWNER=claude-1128 EXCLUSIVE_TITLE=solve-1128-units-arenas EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1128)
S=$R/status
: > $S
(cd $D/$head && find . -type f ! -path './build/*' -print0 | LC_ALL=C sort -z | xargs -0 sha256sum) > $R/host-manifest-$head.txt
cd $D/$head && "${X[@]}" ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh > $R/build-$head.log 2>&1
echo "build $head $?" >> $S
M=$D/$main/build/compiler; H=$D/$head/build/compiler
sha256sum $M $H > $R/receipts.txt
cat > $R/inner-bench.sh <<INNER
#!/bin/bash
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
options=(--predefines "\$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "\$corpus/headers/usr/lib/clang/23/include" -isystem "\$corpus/headers/usr/local/include" -isystem "\$corpus/headers/usr/include")
for b in main head; do
  exe=$M; [ \$b = head ] && exe=$H
  echo "== benchmark-check-units of \$b"
  $H benchmark-check-units --executable \$exe --lanes 1,2,4,8 --runs 5 -- "\${options[@]}"
  echo "status \$?"
done
INNER
chmod +x $R/inner-bench.sh
"${X[@]}" ~/buster-fast-bench/exclusive.sh $R/inner-bench.sh > $R/bench.log 2>&1
echo "bench $?" >> $S
echo done >> $S
