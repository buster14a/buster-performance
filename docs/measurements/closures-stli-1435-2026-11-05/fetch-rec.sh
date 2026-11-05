#!/usr/bin/env bash
# 1435 IBS fetch: closures.lua's instruction fetches sampled by IBS (every 4096th fetch, user space; the kernel throttles
# a run to about 5,000 samples), each build at shift SHIFT, RUNS runs alternating, each record and its parsing one hold,
# pinned to CPU 2. Each sample: symbol+offset, completed, latency, IC miss, op cache miss, L1 ITLB miss, file offset.
set -u
W=$HOME/buster-fast-bench/1435-claude
export EXCLUSIVE_OWNER=claude-1435 EXCLUSIVE_TITLE='Problem 1435' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1435
L=$HOME/buster-fast-bench/exclusive.sh
RUNS=${RUNS:-30}
SHIFT=${SHIFT:-0}
BUILDS=${BUILDS:-main pad0 pad0w pad8}
exe() { case $1 in main) echo $W/base/lua-main-p$SHIFT ;; *) echo $W/pad/lua-$1-p$SHIFT ;; esac; }
O=$W/fetch
mkdir -p $O && cd $O || exit 1
cat > $O/parse.sh <<'EOF'
#!/usr/bin/env bash
D=$1; T=$2
perf report -i $D -D 2>/dev/null | awk '
/^ibs_fetch_ctl:/ { lat = 0; comp = 0; ic = 0; oc = 0; tlb = 0; for (i = 1; i <= NF; i++) { if ($i == "Lat") lat = $(i+1); if ($i == "Comp") comp = $(i+1); if ($i == "IcMiss") ic = $(i+1); if ($i == "FetchOcMiss") oc = $(i+1); if ($i == "L1TlbMiss") tlb = $(i+1) } }
/PERF_RECORD_SAMPLE/ { for (i = 1; i <= NF; i++) if ($i ~ /^0x/ && $(i+1) == "period:") ip = $i; have = 1 }
/^ \.\.\.\.\.\. dso:/ && have { print ip, comp, lat, ic, oc, tlb; have = 0 }' > $T.f
perf script -i $D -F ip,sym,symoff,dso 2>/dev/null | awk '{ ip = "0x" $1; s = $2; d = $NF; gsub(/[()]/, "", d); n = split(d, p, "/"); print ip, s, p[n] }' > $T.s
paste -d' ' $T.f $T.s | awk '$1 == $7 { print $8, $2, $3, $4, $5, $6, $9 }'
rm -f $T.f $T.s
EOF
chmod +x $O/parse.sh
for c in $BUILDS; do : > $O/$c-p$SHIFT.tsv; done
for r in $(seq 1 $RUNS); do
    for c in $BUILDS; do
        $L bash -c "taskset -c 2 perf record -q -e ibs_fetch/swfilt=1/u -R -c 4096 -o $O/one.data $(exe $c) $W/base/closures.lua > /dev/null 2>&1; $O/parse.sh $O/one.data $O/one >> $O/$c-p$SHIFT.tsv"
    done
done
rm -f $O/one.data
echo done > $O/done-p$SHIFT.txt
