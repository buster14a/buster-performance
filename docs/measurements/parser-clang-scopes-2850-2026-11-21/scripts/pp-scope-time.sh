#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh;until [[ -f results/scopeadmit/.built ]];do sleep 2;done
out=$root/scopeadmit-time;mkdir -p "$out";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/scopeadmit/build.log"|head -1)
for label in base cand;do defs=();tag=enumqueuebase;[[ $label != cand ]] || { tag=scopeadmit;defs=(-DPP_SCOPE); }
 "$root/lock.sh" taskset -c 2 "$clang" -std=gnu17 -O3 -g0 -march=znver5 -fwrapv -funsigned-char "${defs[@]}" -I"$root/trees/$tag/src" pp-scope-meter.c -o "$out/$label-meter" >"$out/$label.build" 2>&1
done
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
for r in {0..5};do for c in sqlite main lua musl;do
 case $c in
 sqlite) eval "args=($sqlite_arguments)";;
 main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 lua)args=("$lua/lvm.c");;
 musl)eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
 esac
 f=${args[-1]};opts=("${args[@]:0:${#args[@]}-1}")
 case $r in 0) arms=(parent off publish fused read);;1) arms=(off read fused publish parent);;2) arms=(publish fused read parent off);;3) arms=(fused publish off parent read);;4) arms=(read parent off publish fused);;5) arms=(parent read fused publish off);;esac
 flock -x 9
 if [[ $c == sqlite ]];then
   "$root/lock.sh" taskset -c 2 env BUSTER_TEST_SCOPE_KERNEL=1 "$out/cand-meter" "${opts[@]}" -- "$f" >"$out/$r-$c.kernel" 2>"$out/$r-$c.kernel.lock"
 fi
 for pos in 0 1 2 3 4;do arm=${arms[$pos]};tag=scopeadmit;mode=0;meter=cand;case $arm in parent)tag=enumqueuebase;meter=base;;publish)mode=1;;fused)mode=2;;read)mode=3;;esac
 cc=$root/results/$tag/compiler;p=$out/$r-$c-$pos-$arm
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.rawperf" -- "$@" >"$p.front" 2>"$p.raw.err"' _ "$p" env BUSTER_TEST_SCOPE_ADMISSION="$mode" "$out/$meter-meter" "${opts[@]}" -- "$f" >"$p.raw.lock" 2>&1
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_TEST_SCOPE_ADMISSION="$mode" BUSTER_HUGE_PAGES=1 "$cc" --lanes 1 --time-stages -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1
 "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES BUSTER_TEST_SCOPE_ADMISSION="$mode" "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list --lanes 1 -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err"
 sha256sum "$out/current.o" |cut -d' ' -f1 >"$p.sha256";cmp "$p.sha256" "$root/first-history-enum-queue-parent/$c-default.sha256"
 echo "$r $c $pos $arm">>"$out/status"
 done;flock -u 9
done;done;rm -f "$out/current.o";date -u +%FT%TZ >"$out/done"
