#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
d=$PWD
root=${d%/*}
cd "$root/switch-inputs"
source ../switch-local-args.sh
tree=$root/pregraph-warning-study/compiler-source
main_arguments="-march=native -I$tree/src -fwrapv -funsigned-char --predefines $root/proof-predefines.h $tree/src/buster/compiler/main.c"
mkdir -p "$d/dump"
for name in sqlite main; do
 var=${name}_arguments
 eval "args=(${!var})"
 for source in main-fbef-clean pending-native-windows; do
  log=$d/dump/$name-$source
  "$root/$source/build/compiler" --dump-typed --lanes 1 -c "${args[@]}" -o "$d/dump/out.o" > "$log.stdout" 2> "$log.stderr"
  sha256sum "$d/dump/out.o" "$log.stdout" "$log.stderr" | cut -d" " -f1 > "$log.sha256"
 done
 cmp "$d/dump/$name-main-fbef-clean.sha256" "$d/dump/$name-pending-native-windows.sha256"
 wc -c "$d/dump/$name-pending-native-windows."{stdout,stderr}
done
