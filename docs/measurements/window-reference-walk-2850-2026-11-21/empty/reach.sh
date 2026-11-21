#!/bin/bash
set -eu
d=$1;cc=$2;w=$3;mkdir -p "$w"
clang -std=gnu17 -c "$d/reach.c" -o "$w/clang.o"
clang "$d/driver.c" "$w/clang.o" -o "$w/clang"
"$w/clang" >"$w/expected"
for mode in off on empty one six fault;do
 opts=()
 [[ $mode == off ]] || opts+=(NODE_REF_WINDOW=1 NODE_REF_REPORT=1)
 [[ $mode != empty ]] || opts+=(NODE_REF_EMPTY=1)
 [[ $mode != one ]] || opts+=(NODE_REF_ROUNDS=1)
 [[ $mode != six ]] || opts+=(NODE_REF_ROUNDS=6)
 [[ $mode != fault ]] || opts+=(NODE_REF_FAULT=1)
 rm -f "$w/$mode.refs" "$w/$mode.o"
 set +e
 env "${opts[@]}" NODE_REF_ORACLE="$w/$mode.refs" "$cc" --lanes 1 -std=gnu17 -nostdinc -c "$d/reach.c" -o "$w/$mode.o" >"$w/$mode.out" 2>"$w/$mode.err";s=$?
 set -e
 echo "$s" >"$w/$mode.code"
 if [[ $mode != fault ]];then
  test "$s" = 0;test -s "$w/$mode.refs"
  cmp "$w/off.refs" "$w/$mode.refs";cmp "$w/off.o" "$w/$mode.o"
  clang "$d/driver.c" "$w/$mode.o" -o "$w/$mode.exe"
  "$w/$mode.exe" >"$w/$mode.value";cmp "$w/expected" "$w/$mode.value"
 else
  if [[ $s == 0 ]] && cmp -s "$w/off.refs" "$w/fault.refs";then echo 'reference fault missed';exit 1;fi
 fi
done
