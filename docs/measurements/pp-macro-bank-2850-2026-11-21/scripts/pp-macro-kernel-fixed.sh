#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD;source ./corpora.sh
out=$root/macrobank-kernel-fixed;mkdir -p "$out/overlay/buster/compiler"
base=$root/trees/enumqueuebase
(cd "$base" && git show HEAD:src/buster/compiler/c_preprocessor.c > "$out/overlay/buster/compiler/c_preprocessor.c" && git show HEAD:src/buster/compiler/c_preprocessor_impl.c > "$out/overlay/buster/compiler/c_preprocessor_impl.c")
(cd "$out" && sed -e 's,a/src/buster/,a/overlay/buster/,g' -e 's,b/src/buster/,b/overlay/buster/,g' "$root/pp-macro-bank-capture.patch" | patch --quiet -p1)
clang=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/enumqueuebase/build.log"|head -1)
"$root/lock.sh" taskset -c 2 "$clang" -DPP_BANK_CAPTURE -std=gnu17 -march=znver5 -O3 -g0 -fwrapv -funsigned-char -I"$out/overlay" -I"$base/src" -I"$base/src/buster/compiler" pp-macro-kernel-safe.c -o "$out/probe" > "$out/build.log" 2>&1
cd "$HOME/buster-fast-bench/2850-codex-step2/trees/chainprbase6e9";exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
for c in sqlite main lua musl;do
 case $c in
 sqlite) eval "args=($sqlite_arguments)";;
 main) args=(-march=znver5 -Isrc -fwrapv -funsigned-char --predefines "$root/oracle/predefines.h" src/buster/compiler/main.c);;
 lua)args=("$lua/lvm.c");;
 musl)eval "raw=($musl_arguments)";args=();for a in "${raw[@]}";do [[ $a == *.c ]] && break;args+=("$a");done;args+=("$musl/src/stdio/vfprintf.c");;
 esac
 f=${args[-1]};opts=("${args[@]:0:${#args[@]}-1}")
 flock -x 9;"$root/lock.sh" taskset -c 2 "$out/probe" "${opts[@]}" -- "$f" >"$out/$c.log" 2>"$out/$c.lock";flock -u 9;echo "$c" >>"$out/status"
done
date -u +%FT%TZ >"$out/done"
