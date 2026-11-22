#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD; cd ../switch-inputs;source ../switch-local-args.sh
source_tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$source_tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $source_tree/src/buster/compiler/main.c"
mkdir -p "$d/four" "$d/objects";cd "$d/objects"
for workload in sqlite main lua musl; do
 v=${workload}_arguments;eval "args=(${!v})"
 if test "$workload" = main || test "$workload" = sqlite;then args+=(-o unit.o);fi
 for mode in prior source;do
  tree="$d/../ordinary-store-transfers"; mode_env=();[[ $mode == prior ]] || mode_env=(BUSTER_CHECK_ORDINARY_ACTION_ROWS=1)
  for kind in normal warn diagnostic;do
   case $kind in normal) flags=();;warn) flags=(-Wall -Wextra);;diagnostic) flags=(-Weverything -Wno-c++-compat);;esac
   rm -f -- ./*.o
   stem="$d/four/$workload-$mode-$kind"
   rc=0
   env "${mode_env[@]}" "$tree/build/compiler" --lanes 1 -c "${flags[@]}" "${args[@]}" >"$stem.stdout" 2>"$stem.stderr" || rc=$?
   echo "$rc" >"$stem.status"
   shopt -s nullglob
   objs=(./*.o)
   if (( ${#objs[@]} > 0 ));then sha256sum -- "${objs[@]}" | LC_ALL=C sort -k2 >"$stem.objects";else : >"$stem.objects";fi
   if (( rc != 0 ));then echo "$workload $mode $kind status $rc" >>"$d/four/mismatches.txt";fi
   if [[ $mode == source ]];then
      for ext in objects stdout stderr;do
        if true; then cmp "$d/four/$workload-prior-$kind.$ext" "$stem.$ext" || echo "$workload $kind $ext" >>"$d/four/mismatches.txt";fi
      done
   fi
  done
 done
done
