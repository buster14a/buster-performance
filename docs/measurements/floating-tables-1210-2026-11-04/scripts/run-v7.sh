#!/bin/sh
# Builds head7-1210 (8abc6cbf) and times main, head6 (39f13edf) and head7 against main again, each run under the lock.
set -e
d=~/buster-fast-bench/652-658-claude
export EXCLUSIVE_OWNER=claude-652-1210 EXCLUSIVE_TITLE="652 1210 takeover" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1210
cd $d/inputs
for n in 128 4096 200000; do [ -f t_float_xfallback_$n.c ] || ./gen2 float $n x | sed '$ s/};/16777217};/' > t_float_xfallback_$n.c; done
cd $d/repo && git fetch -q origin chatgpt/658-floating-literal-tables
[ -d ../head7-1210 ] || git worktree add -q --detach ../head7-1210 8abc6cbf7b89972d7550d4760ae4319927facc9b
cd ../head7-1210 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../head7-1210-build.log 2>&1
B=$d/base-1210/build/cmake/znver5-g0/Release/compiler
P=$d/head6-1210/build/cmake/znver5-g0/Release/compiler
H=$d/head7-1210/build/cmake/znver5-g0/Release/compiler
cd $d/inputs
L=""
for st in float_f float_x float_s float_l float_m double_x float_fallback float_xfallback; do L="$L --list -fsyntax-only t_${st}_200000.c"; done
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 15 --warmups 2 --copies 3 --build main $B --build head6 $P --build head7 $H --build main-again $B $L > ../ab-1210-v7-large.txt 2>&1
L=""
for n in 128 4096; do for st in float_f float_x float_s float_l float_m double_x float_fallback float_xfallback; do L="$L --list -fsyntax-only t_${st}_$n.c"; done; done
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 60 --warmups 5 --copies 3 --build main $B --build head6 $P --build head7 $H --build main-again $B $L > ../ab-1210-v7-small.txt 2>&1
cd $d/inputs
cat > ../prof-v7.sh <<EOP
#!/bin/sh
for t in "fallback t_float_fallback_200000.c" "xfallback t_float_xfallback_200000.c"; do
  set -- \$t
  taskset -c 2 perf record -q -F 25000 -o ../v7-\$1.data -- sh -c "for i in 1 2 3 4 5; do $H -fsyntax-only \$2; done" > /dev/null 2>&1
done
EOP
chmod +x ../prof-v7.sh
~/buster-fast-bench/exclusive.sh ../prof-v7.sh
echo done > ../run-v7.done
