#!/bin/sh
# #1444: kernel and user cycles of 300 processes of each build's one-line -c, sampled on every CPU with call chains
# (perf record -a -g), each build's processes apart; the report by symbol for the compiler's threads. One hold.
#   kprof.sh TAG
d=~/buster-fast-bench/1444-claude-lanes
cd $d/inputs
export EXCLUSIVE_OWNER=claude-1444-lanes EXCLUSIVE_TITLE="Start fewer lanes for a small compile (#1444)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1444
tag=$1
cat > $d/kprof-inner.sh <<'INNER'
#!/bin/sh
d=~/buster-fast-bench/1444-claude-lanes
tag=$1
for build in base head; do
    cat > $d/kprof-loop.sh <<LOOP
#!/bin/sh
i=0
while [ \$i -lt 300 ]; do
    $d/shifts-$build/compiler-0 -c tiny.c -o /dev/null
    i=\$((i + 1))
done
LOOP
    chmod +x $d/kprof-loop.sh
    perf record -q -a -g -F 25000 -o $d/results/kprof-$build-$tag.data -- $d/kprof-loop.sh
    perf report -i $d/results/kprof-$build-$tag.data --comm compiler-0 --no-children --sort sym --stdio -g none --percent-limit 0.3 > $d/results/kprof-$build-$tag.txt 2>/dev/null
    perf report -i $d/results/kprof-$build-$tag.data --comm compiler-0 --children --sort sym --stdio -g none --percent-limit 1 > $d/results/kprof-children-$build-$tag.txt 2>/dev/null
done
INNER
chmod +x $d/kprof-inner.sh
~/buster-fast-bench/exclusive.sh $d/kprof-inner.sh $tag > $d/results/kprof-$tag.log 2>&1
echo done > $d/results/kprof-$tag.done
