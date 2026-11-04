#!/bin/sh
# Links main (base-1210, c79fd007) and head8-1210 (188d0a10) at four placements of main_unit_checker.c's code
# (./build.sh shifts, as the 9700X workflow's checker A/B does) and times them over their placements, main's
# placements again as the floor, each build and run under the lock.
set -e
d=~/buster-fast-bench/652-658-claude
export EXCLUSIVE_OWNER=claude-652-1210 EXCLUSIVE_TITLE="652 1210 takeover" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1210
export BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
shifts="0 1088 2112 3136"
cd $d/repo && git fetch -q origin chatgpt/658-floating-literal-tables
[ -d ../head8-1210 ] || git worktree add -q --detach ../head8-1210 188d0a10bbcba60c4559fbb0a08df2db06dc83e4
(cd $d/base-1210 && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-main main_unit_checker.c $shifts) > $d/shifts-main.log 2>&1
(cd $d/head8-1210 && ~/buster-fast-bench/exclusive.sh taskset -c 0-7 ./build.sh shifts --config Release $d/shifts-head8 main_unit_checker.c $shifts) > $d/shifts-head8.log 2>&1
builds=""
for build in main:main head8:head8 main-again:main; do
    for shift in $shifts; do builds="$builds --build ${build%%:*} $d/shifts-${build#*:}/compiler-$shift"; done
done
H=$d/shifts-head8/compiler-0
cd $d/inputs
L=""
for st in float_f float_x float_s float_l float_m double_x float_fallback float_xfallback; do L="$L --list -fsyntax-only t_${st}_200000.c"; done
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 7 --warmups 1 --copies 2 $builds $L > ../ab-1210-v8-large.txt 2>&1
L=""
for n in 128 4096; do for st in float_f float_x float_s float_l float_m double_x float_fallback float_xfallback; do L="$L --list -fsyntax-only t_${st}_$n.c"; done; done
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 30 --warmups 3 --copies 2 $builds $L > ../ab-1210-v8-small.txt 2>&1
echo done > ../run-v8.done
