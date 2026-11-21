#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
tag=$1;until [[ -f results/$tag/.built ]];do sleep 2;done
out=$root/$tag-time;mkdir -p "$out"
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for r in {0..6};do for c in sqlite main lua musl;do
 case $c in
 sqlite) eval "args=($sqlite_arguments)";;
 main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 lua)args=("$lua/lvm.c");;
 musl)eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
 esac
 arms=(normal huge);if ((r%2));then arms=(huge normal);fi
 flock -x 9;for arm in "${arms[@]}";do flags=(env -u BUSTER_HUGE_PAGES);[[ $arm != huge ]] || flags=(env BUSTER_HUGE_PAGES=1)
 p=$out/$r-$c-$arm
 "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.log"' _ "$p" "${flags[@]}" BUSTER_TEST_FRONT_PMU=1 BUSTER_TEST_PP_GRAMMAR_STREAM=2 "$root/results/$tag/compiler" --lanes 1 -c -o "$out/current.o" "${args[@]}" >"$p.lock" 2>&1
 sha256sum "$out/current.o" |cut -d' ' -f1 > "$p.elf";cmp "$p.elf" "$root/first-history-enum-queue-parent/$c-default.sha256"
 test "$(grep -c '^front-pmu ' "$p.log")" = 2
 echo "$r $c $arm" >> "$out/status"
 done;flock -u 9
done;done;rm "$out/current.o";date -u +%FT%TZ >"$out/done"
