#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
before="$HOME/buster-fast-bench/2850-codex-step2/results/constbaseb86/compiler";after="$root/results/enumprod/compiler"
until [[ -f results/enumprod/.built ]];do sleep 3;done
out=$root/enum-current;mkdir -p "$out"
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/constbaseb86"
git rev-parse HEAD >"$out/source-sha";test "$(cat "$out/source-sha")" = b86eadcbd3d6c5cdf687f6b67b0281df2ac34034
args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c)
for c in default wall extra debug;do
 flags=();case "$c" in wall)flags=(-Wall);;extra)flags=(-Wall -Wextra);; debug)flags=(-g);;esac
 for arm in before after;do
  cc=${!arm}; "$root/lock.sh" taskset -c 2 gdb -nx -q -batch -x "$root/first-history-enum-parent/calls.gdb" --args "$cc" "${flags[@]}" -c -o "$out/current.o" "${args[@]}" >"$out/$c-$arm.gdb" 2>&1
  sha256sum "$out/current.o" | cut -d' ' -f1 >"$out/$c-$arm.sha256"
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.out" 2>"$p.err"' _ "$out/$c-$arm" "$cc" "${flags[@]}" -c -o "$out/current.o" "${args[@]}" >"$out/$c-$arm.lock" 2>&1
  test "$(sha256sum "$out/current.o" | cut -d' ' -f1)" = "$(cat "$out/$c-$arm.sha256")"
 done
 for ext in sha256 out err;do cmp "$out/$c-before.$ext" "$out/$c-after.$ext";done
 echo "$c" >>"$out/trace-status"
done
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for r in {0..6};do for c in default extra;do
 flags=();[[ $c == default ]] || flags=(-Wall -Wextra)
 arms=(before after);if ((r%2));then arms=(after before);fi;flock -x 9
 for pos in 0 1;do tag=${arms[$pos]};cc=${!tag};p="$out/$r-$c-$pos-$tag"
  "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 perf stat -x ";" --no-big-num -e cycles:u,cycles:k,instructions:u,minor-faults,cpu-migrations -o "$p.perf" -- "$@" >"$p.out" 2>"$p.stages"' _ "$p" env BUSTER_HUGE_PAGES=1 "$cc" --time-stages "${flags[@]}" -c -o "$out/current.o" "${args[@]}" >"$p.stages.lock" 2>&1
  "$root/lock.sh" taskset -c 2 env -u BUSTER_HUGE_PAGES "$root/baseline/compiler" time-runs --runs 2 --warmups 1 --executable "$cc" --list "${flags[@]}" -c -o "$out/current.o" "${args[@]}" >"$p.wall" 2>"$p.wall.err"
  sha256sum "$out/current.o" | cut -d' ' -f1 >"$p.sha256";cmp "$p.sha256" "$out/$c-before.sha256";echo "$r $c $pos $tag" >>"$out/status"
 done
 flock -u 9
done;done
rm "$out/current.o";date -u +%FT%TZ >"$out/done"
