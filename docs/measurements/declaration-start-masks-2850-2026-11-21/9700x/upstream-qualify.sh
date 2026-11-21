#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-declaration-starts"
root=$PWD
until [[ -e results/after/.built && -e results/before/.built ]]; do sleep 5; done
source ./corpora.sh
mkdir -p checks
cd trees/before
exe=$(sed -n 's/.*toolchain: clang \([^ ]*\) (.*/\1/p' "$root/results/before/build.log" | head -1)
exec 9>"$HOME/buster-fast-bench/2850-codex-step2/our-timing.lock"
flock -x 9
"$root/lock.sh" taskset -c 2 "$exe" -dM -E -march=znver5 -fwrapv -funsigned-char -x c /dev/null >"$root/checks/predefines.h"
main_arguments="-march=znver5 -Isrc -fwrapv -funsigned-char --predefines $root/checks/predefines.h src/buster/compiler/main.c"
for c in sqlite lua musl main; do
  key=${c}_arguments; eval "args=(${!key})"
  case "$c" in
    lua) sample=("$lua/lvm.c");;
    musl) sample=(); for arg in "${args[@]}"; do [[ $arg == *.c ]] && break; sample+=("$arg"); done; sample+=("$musl/src/stdio/vfprintf.c");;
    *) sample=("${args[@]}");;
  esac
  for warn in default wall; do
    opts=(); [[ $warn == default ]] || opts=(-Wall -Wextra)
    for tag in before after; do
      cc=$root/results/$tag/compiler; base="$root/checks/$c-$warn-$tag"; st=0
      "$root/lock.sh" taskset -c 2 "$cc" -fsyntax-only "${opts[@]}" "${args[@]}" >"$base.syntax.stdout" 2>"$base.syntax.stderr" || st=$?
      echo "$st" >"$base.syntax.status"
      st=0; obj="$root/checks/current.o"; rm -f "$obj"
      "$root/lock.sh" taskset -c 2 "$cc" -c -o "$obj" "${opts[@]}" "${sample[@]}" >"$base.object.stdout" 2>"$base.object.stderr" || st=$?
      echo "$st" >"$base.object.status"
      if test -f "$obj"; then sha256sum "$obj" >"$base.sha256"; wc -c < "$obj" >"$base.bytes"; fi
    done
    for suffix in syntax.stdout syntax.stderr syntax.status object.stdout object.stderr object.status sha256 bytes; do
      a="$root/checks/$c-$warn-before.$suffix"; b="$root/checks/$c-$warn-after.$suffix"
      if [[ ! -f $a && ! -f $b ]]; then continue; fi
      if cmp -s "$a" "$b"; then echo "$c $warn $suffix pass"; else echo "$c $warn $suffix differs"; fi
    done
  done
done
rm -f "$root/checks/current.o"
date -u +%FT%TZ > "$root/checks/done"
