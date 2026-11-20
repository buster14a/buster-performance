#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);d="$w/tip-evidence/profiles";mkdir -p "$d";cd "$w/compile-evidence";exe="$w/tip-candidate/build/compiler";export SOURCE_DATE_EPOCH=1792454400
for isdebug in release debug;do
 for item in sqlite parser vm;do
  rep=6;opts=(-DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION inputs/sqlite3.c)
  if [[ $item != sqlite ]];then
   rep=32;x=lparser;[[ $item != vm ]] || x=lvm;opts=(-std=gnu99 -DLUA_USE_LINUX -DLUA_COMPAT_5_3 "inputs/lua/$x.c")
  fi
  extra=();[[ $isdebug != debug ]] || extra+=(-g)
  tag=$isdebug-$item
  perf record -q -e cycles:u -c 100003 -o "$d/$tag.perf" -- bash -ec 'exe=$1;rep=$2;out=$3;shift 3;for ((i=0;i<rep;i++));do "$exe" --tier1 -O2 --lanes 1 -march=znver5 -w "$@" -c -o "$out";done' _ "$exe" "$rep" "$d/$tag.o" "${extra[@]}" "${opts[@]}"
  perf script -i "$d/$tag.perf" -F period,ip,sym,dso > "$d/$tag.samples"
  python "$w/profiles/group-inline.py" "$d/$tag.samples" "$exe" "$d/$tag" --functions '' >"$d/$tag-counts.txt"
 done
done
touch "$d/complete"
