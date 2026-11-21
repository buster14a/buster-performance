#!/bin/bash
set -euo pipefail
cd "$HOME/buster-fast-bench/2850-pp-parser-window";root=$PWD
mkdir -p enum-shadow-controls;out=$root/enum-shadow-controls; cp "$root"/focused-controls/c_check*.c "$out/"
cat >"$out/availability.c" <<'C'
int available(void) { if (__builtin_available(macos 1.2_3, *)) return 1; return 0; }
C
for tag in enumsourcebase enumprod enumqueuebase enumqueue;do
 cc=$root/results/$tag/compiler; parent=enumqueuebase;case "$tag" in enumsourcebase)cc=$HOME/buster-fast-bench/2850-codex-step2/results/constbaseb86/compiler;parent=enumsourcebase;; enumprod)parent=enumsourcebase;;esac
 for policy in default wall all;do
  opt=();case $policy in wall)opt=(-Wall -Wextra);;all)opt=(-Weverything -Wno-c++-compat);;esac
  for src in "$out/availability.c" "$out"/c_check*.c;do
   name=$(basename "$src" .c);p="$out/$name-$policy-$tag"; st=0
   "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.stdout" 2>"$p.stderr"' _ "$p" "$cc" measure-node-machine --shadow --window-rows --passes 0 --list 3 "${opt[@]}" "$src" >"$p.lock" 2>&1 || st=$?
   echo "$st" >"$p.status"
   if [[ $name == availability ]];then
    "$root/lock.sh" bash -c 'p=$1;shift;exec taskset -c 2 "$@" >"$p.syntax-out" 2>"$p.syntax-err"' _ "$p" "$cc" -fsyntax-only "${opt[@]}" "$src" >"$p.syntax-lock" 2>&1
    grep -q -- '-Wavailability' "$p.syntax-err"
   fi
   python3 - "$p.stdout" >"$p.summary" <<'PY'
from pathlib import Path
import re,sys
for line in Path(sys.argv[1]).read_text().splitlines():
 if 'differ' in line or 'unsound takes' in line or 'warning id=72' in line:
  for name,val in re.findall(r'(\S*differ\S*|unsound takes|\S*wrong|failures)=([0-9]+)',line):
   if int(val):print(name,val)
  if 'warning id=72' in line: print(line)
PY
   for v in status summary stderr;do cmp "$p.$v" "$out/$name-$policy-$parent.$v";done
   if [[ $name == availability ]];then cmp "$p.syntax-err" "$out/$name-$policy-$parent.syntax-err";fi
   echo "$name $policy $tag pass" >> "$out/status"
  done
 done
done
date -u +%FT%TZ > "$out/done"
