#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
until [[ -e results/ppdecode/.built ]];do sleep 2;done
out=$root/decode-check;mkdir -p "$out";source ./corpora.sh
cat > "$out/fixture.c" <<'C'
int f(void) { return 7; }
int h(int value) { return value; }
int main(void) { return f() - 7 + h(0); }
C
basecc="$HOME/buster-fast-bench/2850-codex-step2/results/sourcebb8/compiler"
for c in fixture sqlite lua musl main;do
 case $c in
  fixture) args=("$out/fixture.c");;
  sqlite) eval "args=($sqlite_arguments)";;
  lua) args=("$lua/lvm.c");;
  musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 esac
 cd "$root/trees/ppdecode"
 for policy in default wall;do
  opts=();[[ $policy != wall ]] || opts+=(-Wall -Wextra)
  for mode in before plain verify publish fault;do
   if [[ $policy == wall || $c != fixture && $c != sqlite ]];then [[ $mode != fault ]] || continue;fi
   p="$out/$c-$policy-$mode";cc=$root/results/ppdecode/compiler;[[ $mode != before ]] || cc=$basecc
   pp=off;[[ $mode != verify && $mode != publish && $mode != fault ]] || pp=stream
   feature=(env -u BUSTER_TEST_PP_RETURN_DECODE)
   [[ $mode != publish ]] || feature+=(BUSTER_TEST_PP_RETURN_DECODE=on)
   [[ $mode != fault ]] || feature+=(BUSTER_TEST_PP_RETURN_DECODE=fault)
   st=0
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" "${feature[@]}" NODE_SOURCE_COMPACT_REPORT=1 NODE_SPLICE_REPORT=1 NODE_SOURCE_NATIVE_ORACLE="$p.native" BUSTER_TEST_PP_RETURN_WINDOW="$pp" BUSTER_TEST_PP_RETURN_USE=off BUSTER_TEST_PP_RETURN_REPORT=1 "$cc" --node-window-source --lanes 1 "${opts[@]}" -c -o "$p.o" "${args[@]}" >"$p.lock" 2>&1 || st=$?
   echo "$st" >"$p.status";if ((st!=0));then tail -4 "$p.stderr";exit 1;fi
   (cd "$out" && sha256sum "$c-$policy-$mode.o" "$c-$policy-$mode.native" > "$c-$policy-$mode.sha256")
   if [[ $c == fixture && $policy == default ]];then
    "$root/lock.sh" taskset -c 2 cc -o "$p.exe" "$p.o" >"$p.link" 2>&1
    code=0;"$root/lock.sh" taskset -c 2 "$p.exe" >"$p.run" 2>&1 || code=$?;echo "$code" >"$p.exit";rm "$p.exe"
   fi
  done
  for mode in plain verify publish;do
   cmp "$out/$c-$policy-before.o" "$out/$c-$policy-$mode.o"
   cmp "$out/$c-$policy-before.native" "$out/$c-$policy-$mode.native"
  done
  if [[ $c == fixture && $policy == default ]];then
   test "$(cat "$out/fixture-default-publish.exit")" = 0;test "$(cat "$out/fixture-default-fault.exit")" != 0
  fi
  if [[ -f "$out/$c-$policy-fault.o" ]];then
   if cmp -s "$out/$c-$policy-before.o" "$out/$c-$policy-fault.o" || cmp -s "$out/$c-$policy-before.native" "$out/$c-$policy-fault.native";then exit 2;fi
  fi
  rm "$out/$c-$policy"-*.o "$out/$c-$policy"-*.native
  echo "$c $policy pass" >>"$out/status"
 done
done
date -u +%FT%TZ >"$out/done"
