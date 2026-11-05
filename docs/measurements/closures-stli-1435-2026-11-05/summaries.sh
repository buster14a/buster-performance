#!/usr/bin/env bash
# 1435 summaries: the IBS and fetch tables the record quotes, from the raw samples (no runs; reads files only).
set -u
W=$HOME/buster-fast-bench/1435-claude
mkdir -p $W/summary && cd $W || exit 1
(cd ibs && ../ibs-sum.sh main-k0.tsv head-k0.tsv 20) > summary/ibs-k0-main-head.txt 2>&1
(cd ibs && echo "== main: k 0 (STLI 5.1M) against k 2 (1.4M)" && ../stli-attr.sh main-k0b.tsv main-k2.tsv 12 && echo "== head: k 68 (STLI 6.9M) against k 64 (1.7M)" && ../stli-attr.sh head-k68.tsv head-k64.tsv 12) > summary/stli-attribution.txt 2>&1
(cd ibs && for f in main-k0b main-k2 head-k68 head-k64; do awk -v f=$f '{n++} $2=="L"{l++; if($4==0&&$3>=12){s++}; lat+=$3} END{printf "%s ops %d loads %d slow-L1-hit(>=12) %d (%.2f%%) mean-load-tag-to-completion %.2f\n", f, n, l, s, 100*s/l, lat/l}' $f.tsv; done) > summary/load-latency-by-stack-position.txt
(cd fetch && echo "== pad0w (A) against pad0 = #1433 (B), shift 0" && ../fetch-sum.sh pad0w-p0.tsv pad0-p0.tsv && echo "== pad8 (A) against pad0 (B)" && ../fetch-sum.sh pad8-p0.tsv pad0-p0.tsv && echo "== main (A) against pad0 (B)" && ../fetch-sum.sh main-p0.tsv pad0-p0.tsv) > summary/fetch-op-cache-by-function.txt 2>&1
(cd fetch && for b in pad0 pad0w pad8; do echo "== $b"; ../oc-sets.sh $b-p0.tsv ../pad/lua-$b-p0; done; echo "== main"; ../oc-sets.sh main-p0.tsv ../base/lua-main-p0) > summary/fetch-op-cache-by-line.txt 2>&1
for x in pad/lua-pad0-p0 pad/lua-pad0w-p0 pad/lua-pad8-p0 base/lua-main-p0; do echo $x $(nm $x | awk '$3 ~ /^(lua_type|lua_getmetatable|precallC|luaC_checkfinalizer|luaH_getshortstr|luaV_execute|setnodevector)$/ {printf "%s=%s(mod-4K %03x) ", $3, $1, strtonum("0x" $1) % 4096}'); done > summary/hot-function-addresses.txt
sha256sum ibs/*.tsv fetch/*.tsv base/lua-* pad/lua-pad*-p* base/closures.lua > summary/raw.sha256
ls -la ibs/*.tsv fetch/*.tsv >> summary/raw-sizes.txt
(cd exp && git log --format='%H %s' -3) > summary/exp-revisions.txt
echo done > summary/done.txt
