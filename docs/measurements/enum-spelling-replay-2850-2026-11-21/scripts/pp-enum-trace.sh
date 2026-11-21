#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
label=$1;cc=$2;out=$root/first-history-$label;mkdir -p "$out";cat > "$out/calls.gdb" <<'GDB'
set pagination off
set confirm off
set debuginfod enabled off
set print frame-arguments none
set print thread-events off
break pp_history_record
commands
silent
printf "first history record\n"
bt 14
continue
end
break pp_preprocess_file
commands
silent
printf "preprocess file\n"
bt 4
continue
end
run
GDB
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9"
for c in lua main sqlite musl;do
 case $c in
  sqlite) eval "args=($sqlite_arguments)";; lua) args=("$lua/lvm.c");;
  musl) eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
  main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 esac
 for policy in default wall;do
  flags=();[[ $policy == default ]] || flags=(-Wall)
  "$root/lock.sh" taskset -c 2 gdb -nx -q -batch -x "$out/calls.gdb" --args "$cc" "${flags[@]}" -c -o "$out/current.o" "${args[@]}" >"$out/$c-$policy.log" 2>&1
  sha256sum "$out/current.o" | cut -d' ' -f1 >"$out/$c-$policy.sha256"
  echo "$c $policy" >>"$out/status"
 done
done
rm "$out/current.o";date -u +%FT%TZ >"$out/done"
